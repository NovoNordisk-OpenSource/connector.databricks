#' Create databricks connector object
#'
#' @description Create a new databricks connector object. See [Connector_databricks] for details.
#'
#' @param host Your Workspace Instance URL.
#' @param token Your Personal Authentication Token, it will be retrieved
#' by [get_token]
#' @param cluster_id Cluster id. More about it can be find
#' [here](https://docs.databricks.com/en/workspace/workspace-details.html#cluster-url-and-id).
#' @param catalog Catalog name. More about it can be find
#' [here](https://docs.databricks.com/en/catalogs/index.html).
#' @param schema Schema name. More about it can be find
#' [here](https://docs.databricks.com/en/schemas/index.html).
#' @param ... Additional parameters to pass to the [Connector_databricks] object
#' @param extra_class [character] Extra class added to the object. See details.
#'
#' @return A new [Connector_databricks] object
#'
#' @details
#' The `extra_class` parameter allows you to create a subclass of the `Connector_databricks` object.
#' This can be useful if you want to create a custom connection object for easier dispatch of new s3 methods,
#' while still inheriting the methods from the `Connector_databricks` object.
#'
#' @examplesIf not_on_ci()
#'
#' # Connect
#'
#' db_con <- connector_databricks(
#'   host = Sys.getenv("DATABRICKS_HOST"),
#'   token = Sys.getenv("DATABRICKS_TOKEN"),
#'   cluster_id = "0216-121054-v8tdvp00",
#'   catalog = "samples",
#'   schema = "nyctaxi"
#' )
#' # List content
#' db_con$list_content()
#' # Write a file
#' db_con$write(iris, "iris.csv")
#' # Read a file
#' db_con$read("iris.csv")
#' # Remove a file or directory
#' db_con$remove("iris.csv", confirm = FALSE)
#'
#' @export
connector_databricks <- function(host,
                                 token,
                                 cluster_id,
                                 catalog,
                                 schema,
                                 ...,
                                 extra_class = NULL) {
  checkmate::assert_character(extra_class, null.ok = TRUE)

  layer <- Connector_databricks$new(
    host = host,
    token = token,
    cluster_id = cluster_id,
    catalog = catalog,
    schema = schema,
    ...
  )
  if (!is.null(extra_class)) {
    class(layer) <- c(extra_class, class(layer))
  }
  return(layer)
}


#' @title Connector Object for databricks
#' @description This object is used to interact with databricks spark cluster,
#' adding the ability to list, read, write, download, upload, create tables
#' and remove files.
#'
#' @importFrom R6 R6Class
#' @importFrom sparklyr spark_connect
#'
#' @details
#' About the token, you can retrieve it by following the guideline in your
#' enterprise.
#'
#' @export
#'
#' @name Connector_databricks_object
#'
#' @examplesIf not_on_ci()
#' # Connect to databricks
#' cluster <- Connector_databricks$new(
#'   host = Sys.getenv("DATABRICKS_HOST"),
#'   token = Sys.getenv("DATABRICKS_TOKEN"),
#'   cluster_id = Sys.getenv("DATABRICKS_CLUSTER_ID"),
#'   catalog = catalog,
#'   schema = schema
#' )
#'
#' my_drive$list_content()
Connector_databricks <- R6::R6Class(
  # nolint
  "Connector_databricks",
  public = list(
    #' @description Initializes the Connector_databricks class
    #' @param host Your Workspace Instance URL.
    #' @param token Your Personal Authentication Token, it will be retrieved
    #' by [get_token]
    #' @param cluster_id Cluster id. More about it can be find
    #' [here](https://docs.databricks.com/en/workspace/workspace-details.html#cluster-url-and-id).
    #' @param catalog Catalog name. More about it can be find
    #' [here](https://docs.databricks.com/en/catalogs/index.html).
    #' @param schema Schema name. More about it can be find
    #' [here](https://docs.databricks.com/en/schemas/index.html).
    #' @param ... Additional parameters to pass to the [Connector_databricks] object
    #' @return A [Connector_databricks] object
    #'
    #'
    initialize = function(host = Sys.getenv("DATABRICKS_HOST"),
                          token = Sys.getenv("DATABRICKS_TOKEN"),
                          cluster_id,
                          catalog,
                          schema,
                          ...) {
      checkmate::assert_character(host)
      checkmate::assert_character(token)
      checkmate::assert_character(cluster_id)
      checkmate::assert_character(catalog)
      checkmate::assert_character(schema)

      Sys.setenv("DATABRICKS_HOST" = host)
      Sys.setenv("DATABRICKS_TOKEN" = token)

      sc <- sparklyr::spark_connect(cluster_id = cluster_id,
                                    method = "databricks_connect")

      private$.sc <- sc
      private$.cluster_id <- cluster_id
      private$.catalog <- catalog
      private$.schema <- schema

      return(invisible(self))
    },
    #' @description List tables of the schema
    #' @param ... Additional parameters to pass to the cnt_list_content method
    #' @return A dataframe with list of tables
    list_tables = function(...) {
      self %>%
        cnt_list_content(...)
    },
    #' @description Read the content of a file
    #' @param name The name of the file to read
    #' @param ... Additional parameters to pass to the cnt_read method
    #' @return The content of the file
    read = function(name, ...) {
      self %>%
        cnt_read(name, ...)
    },
    #' @description Write a file
    #' @param x The content to write
    #' @param file The name of the file to write
    #' @param ... Additional parameters to pass to the cnt_write method
    #' @return The content of the file
    write = function(x, file, ...) {
      self %>%
        cnt_write(x, file, ...)
    }
    #' ,
    #' #' @description Download a file
    #' #' @param name The name of the file to download
    #' #' @param ... Additional parameters to pass to the cnt_download_content method
    #' #' @return The file downloaded
    #' download = function(name, ...) {
    #'   self %>%
    #'     cnt_download_content(name, ...)
    #' },
    #' #' @description Upload a file
    #' #' @param name The name of the file to upload
    #' #' @param ... Additional parameters to pass to the cnt_upload_content method
    #' #' @return The file uploaded
    #' upload = function(name, ...) {
    #'   self %>%
    #'     cnt_upload_content(name, ...)
    #' },
    #' #' @description Get the connection
    #' #' @return The connection
    #' get_conn = function() {
    #'   private$sc
    #' },
    #' #' @description Create a directory
    #' #' @param name The name of the directory to create
    #' #' @param ... Additional parameters to pass to the cnt_create_directory method
    #' #' @return The directory created
    #' create_directory = function(name, ...) {
    #'   self %>%
    #'     cnt_create_directory(name, ...)
    #' },
    #' #' @description Remove a file or a directory
    #' #' @param name The name of the file or directory to remove
    #' #' @param ... Additional parameters to pass to the cnt_remove method
    #' remove = function(name, ...) {
    #'   self %>%
    #'     cnt_remove(name, ...)
    #' }
  ),
  active = list(
    #' @field cluster_id (`string`) Cluster ID
    cluster_id = function(value) {
      if (missing(value)) {
        return(private$.cluster_id)
      }
      checkmate::assert_character(x = value,
                                  null.ok = FALSE)
      private$.cluster_id <- value
      return(invisible(self))
    },
    #' @field catalog (`string`) Catalog
    catalog = function(value) {
      if (missing(value)) {
        return(private$.catalog)
      }
      checkmate::assert_character(x = value,
                                  null.ok = FALSE)
      private$.catalog <- value
      return(invisible(self))
    },
    #' @field schema (`string`) Schema
    schema = function(value) {
      if (missing(value)) {
        return(private$.schema)
      }
      checkmate::assert_character(x = value,
                                  null.ok = FALSE)
      private$.schema <- value
      return(invisible(self))
    },
    #' @field sc (`Spark connection`) Spark Connection
    sc = function(value) {
      if (missing(value)) {
        return(private$.sc)
      }
      cli::cli_abort("Can't set `$sc`")
    }
  ),
  private = list(
    .cluster_id = character(0),
    .catalog = character(0),
    .schema = character(0),
    .sc = NULL
  ),
  cloneable = FALSE
)
