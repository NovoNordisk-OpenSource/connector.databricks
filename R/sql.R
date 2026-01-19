#' Create `ConnectorDatabricksSQL` connector
#' `r lifecycle::badge("experimental")`
#' @description
#' Initializes the connector for SQL warehouse type of storage.
#' See [ConnectorDatabricksSQL] for details.
#'
#' @description Initialize the connection to Databricks
#' @param warehouse_id [character] The ID of the Databricks SQL warehouse
#' you want to connect to. Defaults to `DATABRICKS_WAREHOUSE_ID` environment
#' variable.
#' @param catalog [character] The catalog to use
#' @param schema [character] The schema to use
#' @param staging_volume [character] Optional volume path for large dataset
#' staging. Recommended way for better performances.
#' @param ... Additional parameters sent to `brickster::DatabricksSQL()`
#' driver.
#' @param extra_class [character] Extra class to assign to the new connector
#'
#' @return A [ConnectorDatabricksSQL] object
#'
#' @details
#' The `extra_class` parameter allows you to create a subclass of the
#' `ConnectorDatabricksSQL` object. This can be useful if you want to create
#' a custom connection object for easier dispatch of new s3 methods, while still
#' inheriting the methods from the `ConnectorDatabricksSQL` object.
#'
#' @examples
#' \dontrun{
#' # Establish connection to your SQL warehouse
#'
#' con_databricks <- connector_databricks_sql(
#'   warehouse_id = "your-warehouse-id",
#'   catalog = "my_catalog",
#'   schema = "my_schema"
#' )
#'
#' # List tables in my_schema
#'
#' con_databricks$list_content()
#'
#' # Read and write tables
#'
#' con_databricks$write(mtcars, "my_mtcars_table")
#'
#' con_databricks$read("my_mtcars_table")
#'
#' # Use dplyr::tbl
#'
#' con_databricks$tbl("my_mtcars_table")
#'
#' # Remove table
#'
#' con_databricks$remove("my_mtcars_table")
#'
#' # Disconnect
#'
#' con_databricks$disconnect()
#' }
#' @export
connector_databricks_sql <- function(
  warehouse_id = Sys.getenv("DATABRICKS_WAREHOUSE_ID"),
  catalog,
  schema,
  staging_volume = NULL,
  ...,
  extra_class = NULL
) {
  ConnectorDatabricksSQL$new(
    warehouse_id = warehouse_id,
    catalog = catalog,
    schema = schema,
    staging_volume = staging_volume,
    ...,
    extra_class = extra_class
  )
}

#' Connector for connecting to Databricks using brickster DatabricksSQL
#' `r lifecycle::badge("experimental")`
#' @description
#' Extension of the [connector::connector_dbi] making it easier to connect to,
#' and work with tables in Databricks using SQL warehouses.
#'
#' @details
#' All methods for [ConnectorDatabricksSQL] object are working from the
#' catalog and schema provided when initializing the connection.
#' This means you only need to provide the table name when using the built in
#' methods. If you want to access tables outside of the chosen schema, you can
#' either retrieve the connection with `ConnectorDatabricksSQL$conn` or create
#'  a new connector.
#'
#' When creating the connections to Databricks you need to provide the
#' warehouse ID of the SQL warehouse you want to connect to.
#' Authentication to databricks is handled by the `brickster::DatabricksSQL()`
#' driver and supports general use of personal access tokens and credentials
#' through Posit Workbench. See also [brickster::DatabricksSQL()] for more
#' information on how the connection to Databricks is established.
#'
#' @importFrom brickster DatabricksSQL
#' @examples
#' \dontrun{
#' # Establish connection to your SQL warehouse
#'
#' con_databricks <- ConnectorDatabricksSQL$new(
#'   warehouse_id = "your-warehouse-id",
#'   catalog = "my_catalog",
#'   schema = "my_schema"
#' )
#'
#' # List tables in my_schema
#'
#' con_databricks$list_content()
#'
#' # Read and write tables
#'
#' con_databricks$write(mtcars, "my_mtcars_table")
#'
#' con_databricks$read("my_mtcars_table")
#'
#' # Use dplyr::tbl
#'
#' con_databricks$tbl("my_mtcars_table")
#'
#' # Remove table
#'
#' con_databricks$remove("my_mtcars_table")
#'
#' # Disconnect
#'
#' con_databricks$disconnect()
#' }
#' @export
# nolint start
ConnectorDatabricksSQL <- R6::R6Class(
  # nolint end
  classname = "ConnectorDatabricksSQL",
  inherit = connector::ConnectorDBI,
  public = list(
    #' @description Initialize the connection to Databricks
    #' @param warehouse_id [character] The ID of the Databricks SQL warehouse
    #' you want to connect to
    #' @param catalog [character] The catalog to use
    #' @param schema [character] The schema to use
    #' @param staging_volume [character] Optional volume path for large dataset
    #' staging
    #' @param ... Additional parameters sent to `brickster::DatabricksSQL()`
    #' driver.
    #' @param extra_class [character] Extra class to assign to the new connector
    #' @return A [ConnectorDatabricksSQL] object
    initialize = function(
      warehouse_id,
      catalog,
      schema,
      staging_volume = NULL,
      ...,
      extra_class = NULL
    ) {
      checkmate::assert_character(
        x = warehouse_id,
        len = 1,
        any.missing = FALSE
      )
      checkmate::assert_character(x = catalog, len = 1, any.missing = FALSE)
      checkmate::assert_character(x = schema, len = 1, any.missing = FALSE)
      checkmate::assert_character(
        x = staging_volume,
        len = 1,
        any.missing = TRUE,
        null.ok = TRUE
      )
      checkmate::assert_character(
        x = extra_class,
        len = 1,
        any.missing = FALSE,
        null.ok = TRUE
      )
      private$.catalog <- catalog
      private$.schema <- schema
      private$.staging_volume <- staging_volume

      zephyr::msg_info("Connecting to SQL warehouse, please wait..")

      super$initialize(
        drv = brickster::DatabricksSQL(),
        warehouse_id = warehouse_id,
        catalog = catalog,
        schema = schema,
        staging_volume = staging_volume,
        ...,
        extra_class = extra_class
      )
    }
  ),
  active = list(
    #' @field conn The DBI connection object of the connector
    conn = function() {
      # Note: This is field already exist in the super class.
      # Only done here because the active bindings from the super class are not
      # included in the roxygen documentation.
      private$.conn
    },
    #' @field catalog The catalog used in the connector
    catalog = function() {
      private$.catalog
    },
    #' @field schema The schema used in the connector
    schema = function() {
      private$.schema
    },
    #' @field staging_volume Optional volume path for large dataset staging
    staging_volume = function() {
      private$.staging_volume
    }
  ),
  private = list(
    .catalog = NULL,
    .schema = NULL,
    .staging_volume = NULL
  )
)
