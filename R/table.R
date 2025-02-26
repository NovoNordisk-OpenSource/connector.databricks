#' Create `ConnectorDatabricksTable` connector
#'
#' @description
#' Initializes the connector for table type of storage.
#' See [ConnectorDatabricksTable] for details.
#'
#' @param http_path [character] The path to the Databricks cluster or SQL warehouse you want to connect to
#' @param catalog [character] The catalog to use
#' @param schema [character] The schema to use
#' @param extra_class [character] Extra class to assign to the new connector
#'
#' @return A new [ConnectorDatabricksTable] object
#'
#' @details
#' The `extra_class` parameter allows you to create a subclass of the
#' `ConnectorDatabricksTable` object. This can be useful if you want to create
#' a custom connection object for easier dispatch of new s3 methods, while still
#' inheriting the methods from the `ConnectorDatabricksTable` object.
#'
#' @examplesIf FALSE
#' # Establish connection to your cluster
#'
#' con_databricks <- connector_databricks_table(
#'   httpPath = "path-to-cluster",
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
#'
#' @export
connector_databricks_table <- function(
  http_path,
  catalog,
  schema,
  extra_class = NULL
) {
  ConnectorDatabricksTable$new(
    http_path = http_path,
    catalog = catalog,
    schema = schema,
    extra_class = extra_class
  )
}

#' Connector for connecting to Databricks using DBI
#'
#' @description
#' Extension of the [connector::connector_dbi] making it easier to connect to, and work with tables in Databricks.
#'
#' @details
#' All methods for [ConnectorDatabricksTable] object are working from the catalog
#' and schema provided when initializing the connection.
#' This means you only need to provide the table name when using the built in methods.
#' If you want to access tables outside of the chosen schema, you can either retrieve
#' the connection with `ConnectorDatabricksTable$conn` or create a new connector.
#'
#' When creating the connections to Databricks you either need to provide the sqlpath to
#' the Databricks cluster or the SQL warehouse you want to connect to.
#' Authentication to databricks is handed by the `odbc::databricks()` driver and supports
#' general use of personal access tokens and credentials through Posit Workbench.
#' See also [odbc::databricks()] On more information on how the connection to Databricks is established.
#'
#' @importFrom odbc databricks
#' @examplesIf FALSE
#' # Establish connection to your cluster
#'
#' con_databricks <- ConnectorDatabricksTable$new(
#'   httpPath = "path-to-cluster",
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
#'
#' @export

ConnectorDatabricksTable <- R6::R6Class(
  classname = "ConnectorDatabricksTable",
  inherit = connector::ConnectorDBI,
  public = list(
    #' @description Initialize the connection to Databricks
    #' @param http_path [character] The path to the Databricks cluster or SQL warehouse you want to connect to
    #' @param catalog [character] The catalog to use
    #' @param schema [character] The schema to use
    #' @param extra_class [character] Extra class to assign to the new connector
    #' @return A [ConnectorDatabricksTable] object
    initialize = function(http_path, catalog, schema, extra_class = NULL) {
      checkmate::assert_character(x = http_path, len = 1, any.missing = FALSE)
      checkmate::assert_character(x = catalog, len = 1, any.missing = FALSE)
      checkmate::assert_character(x = schema, len = 1, any.missing = FALSE)
      checkmate::assert_character(
        x = extra_class,
        len = 1,
        any.missing = FALSE,
        null.ok = TRUE
      )

      private$.catalog <- catalog
      private$.schema <- schema

      super$initialize(
        drv = odbc::databricks(),
        httpPath = http_path,
        useNativeQuery = FALSE,
        extra_class = extra_class
      )
    }
  ),
  active = list(
    #' @field conn The DBI connection object of the connector
    conn = function() {
      # Note: This is field already exist in the super class.
      # Only done here because the active bindings from the super class are not included in the roxygen documentation.
      private$.conn
    },
    #' @field catalog The catalog used in the connector
    catalog = function() {
      private$.catalog
    },
    #' @field schema The schema used in the connector
    schema = function() {
      private$.schema
    }
  ),
  private = list(
    .catalog = NULL,
    .schema = NULL
  )
)
