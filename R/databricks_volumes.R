#' Create databricks volumes connector
#'
#' @description Create a new databricks volumes connector object. See [Connector_databricks_volumes] for details.
#'
#' @param path Path to the file system
#' @param ... Additional arguments passed to [Connector_databricks_volumes]
#' @param extra_class [character] Extra class added to the object. See details.
#' @return A new [Connector_databricks_volumes] object
#'
#' @details
#' The `extra_class` parameter allows you to create a subclass of the `Connector_databricks_volumes` object.
#' This can be useful if you want to create a custom connection object for easier dispatch of new s3 methods,
#' while still inheriting the methods from the `Connector_databricks_volumes` object.
#'
#' @examples
#' # Connect to a file system
#'
#' databrics_volume <- "/Volumes/my_adam/tester"
#' db <- connector_databricks_volumes(databrics_volume)
#'
#' db
#'
#' # Create subclass connection
#'
#' db_subclass <- connector_databricks_volumes(databrics_volume, extra_class = "subclass")
#'
#' db_subclass
#' class(db_subclass)
#'
#' @export
connector_databricks_volumes <- function(path, ..., extra_class = NULL) {
  layer <- Connector_databricks_volumes$new(path = path, ...)
  if (!is.null(extra_class)) {
    extra_class <- paste(class(layer), extra_class, sep = "_")
    class(layer) <- c(extra_class, class(layer))
  }
  return(layer)
}

#' Class Connector_databricks_volumes
#' @description The connector_databricks_volumes class is a file system connector
#'   for accessing and manipulating files in a local file system.
#' @importFrom R6 R6Class
#'
#' @name Connector_databricks_volumes_object
#' @export
Connector_databricks_volumes <- R6::R6Class( # nolint
  "Connector_databricks_volumes",
  public = list(
    #' @description Initializes the connector_databricks_volumes class
    #' @param path Path to the file system
    initialize = function(path) {
      private$path <- assert_databicks_path(path)
    },
    #' @description Returns the list of files in the specified path
    #' @param ... Other parameters to pass to the list_file_dir_contents function
    list_content = function(...) {
      list_file_dir_contents(path = private$path, ...)
    },
    #' @description Constructs a complete path by combining the specified access path with the provided elements
    #' @param ... Elements to construct the path
    construct_path = function(...) {
      file.path(private$path, ...)
    },
    #' @description Reads the content of the specified file using the private access path and additional options
    #' @param name Name of the file to read
    #' @param ... Other parameters to pass to the read_file function (depends on the extension of a file)
    read = function(name, ...) {
      name |>
        find_file_databricks(root = private$path) |>
        read_fs_databricks(...)
    },
    #' @description Writes the specified content to the specified file using the
    #'   private access path and additional options
    #' @param x Content to write to the file
    #' @param file File name
    #' @param ... Other parameters to pass to the write_file function (depends on the extension of a file)
    write = function(x, file, ...) {
      write_fs_databricks(x, self$construct_path(file), ...)
    },
    #' @description Create directory on databricks
    #' @param dir directory name
    create_directory = function(dir) {
      create_file_directory(client = DatabricksClient(), self$construct_path(dir))
    },
    #' @description Remove the specified file by given name with extension
    #' @param file File name
    remove = function(file) {
      delete_file(client = DatabricksClient(), self$construct_path(file))
    },
    #' @description Remove the specified directory
    #' @param dir directory name
    remove_directory = function(dir) {
      delete_file_directory(client = DatabricksClient(), self$construct_path(dir))
    }
  ),
  private = list(
    path = character(0)
  ),
  cloneable = FALSE
)
