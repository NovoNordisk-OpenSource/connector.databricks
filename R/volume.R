#' Create databricks volume connector
#'
#' @description Create a new databricks volume connector object.
#' See [ConnectorDatabricksVolume] for details.
#'
#' @description
#' Initializes the connector for Databricks volume storage.
#'
#' @param full_path Full path to the file storage in format
#' `catalog/schema/path`. If NULL, `catalog`, `schema`, and `path` must be
#' provided.
#' @param catalog Databricks catalog
#' @param schema Databricks schema
#' @param path Path to the file storage
#' @param extra_class Extra class to assign to the new connector.
#' @param force If TRUE, the volume will be created without
#' asking if it does not exist.
#' @param ... Additional arguments passed to the [connector::connector]
#'
#' @return A new [ConnectorDatabricksVolume] object
#'
#' @details
#' The `extra_class` parameter allows you to create a subclass of the
#' `ConnectorDatabricksVolume` object. This can be useful if you want to create
#' a custom connection object for easier dispatch of new s3 methods, while still
#' inheriting the methods from the `ConnectorDatabricksVolume` object.
#'
#' @examplesIf FALSE
#'
#' # Connect to a file system
#' databricks_volume <- "catalog/schema/path"
#' db <- connector_databricks_volume(databricks_volume)
#'
#' db
#'
#' # Create subclass connection
#' db_subclass <- connector_databricks_volume(databricks_volume,
#'   extra_class = "subclass"
#' )
#'
#' db_subclass
#' class(db_subclass)
#'
#' @export
connector_databricks_volume <- function(
  full_path = NULL,
  catalog = NULL,
  schema = NULL,
  path = NULL,
  extra_class = NULL,
  force = FALSE,
  ...
) {
  connector <- ConnectorDatabricksVolume$new(
    full_path = full_path,
    catalog = catalog,
    schema = schema,
    path = path,
    force = force,
    extra_class = extra_class,
    ...
  )

  return(connector)
}

#' Connector for databricks volume storage
#'
#' @description
#' The ConnectorDatabricksVolume class, built on top of [connector::connector]
#' class. It is a file storage connector for accessing and manipulating files
#' inside Databricks volumes.
#'
#' @importFrom R6 R6Class
#'
#' @examplesIf FALSE
#' # Create file storage connector
#'
#' cnt <- ConnectorDatabricksVolume$new(full_path = "catalog/schema/path")
#'
#' cnt
#'
#' # List content
#' cnt$list_content_cnt()
#'
#' # Write to the connector
#' cnt$write_cnt(iris, "iris.rds")
#'
#' # Check it is there
#' cnt$list_content_cnt()
#'
#' # Read the result back
#' cnt$read_cnt("iris.rds") |>
#'   head()
#'
#' @export
# nolint start
ConnectorDatabricksVolume <- R6::R6Class(
  # nolint end
  classname = "ConnectorDatabricksVolume",
  inherit = connector::ConnectorFS,
  public = list(
    #' @description
    #' Initializes the connector for Databricks volume storage.
    #' @param full_path [character] Full path to the file storage in format
    #' `catalog/schema/path`. If NULL, `catalog`, `schema`, and `path` must be
    #' provided.
    #' @param catalog [character] Databricks catalog
    #' @param schema [character] Databricks schema
    #' @param path [character] Path to the file storage
    #' @param extra_class [character] Extra class to assign to the new
    #' connector.
    #' @param force [logical] If TRUE, the volume will be created without asking
    #' if it does not exist.
    #' @param ... Additional arguments passed to the initialize method of
    #' superclass
    #'
    #' @importFrom cli cli_abort
    #' @importFrom checkmate assert_string assert_logical
    #'
    #' @return A new [ConnectorDatabricksVolume] object
    initialize = function(
      full_path = NULL,
      catalog = NULL,
      schema = NULL,
      path = NULL,
      extra_class = NULL,
      force = FALSE,
      ...
    ) {
      if (is.null(full_path)) {
        checkmate::assert_string(x = path, null.ok = FALSE)
        checkmate::assert_string(x = catalog, null.ok = FALSE)
        checkmate::assert_string(x = schema, null.ok = FALSE)
        full_path <- file.path("/Volumes", catalog, schema, path)
      } else {
        checkmate::assert_string(x = full_path, null.ok = FALSE)
      }
      checkmate::assert_string(x = extra_class, null.ok = TRUE)
      checkmate::assert_logical(x = force, max.len = 1, null.ok = FALSE)

      if (!startsWith(full_path, "/Volumes/")) {
        full_path <- paste0("/Volumes/", full_path)
      }

      split_path <- unlist(strsplit(full_path, "/"))
      if (length(split_path) < 4) {
        cli::cli_abort("Full path must be in the format catalog/schema/path.")
      }
      catalog <- split_path[3]
      schema <- split_path[4]
      volume <- split_path[5]
      path <- paste(split_path[5:length(split_path)], collapse = "/")

      # Check if volume exists and create it if it does not
      private$.check_databricks_volume_exists(
        catalog = catalog,
        schema = schema,
        volume = volume,
        force = force
      )

      # Try and create a directory, if it already exists, it will be returned
      brickster::db_volume_dir_create(path = full_path, ...)

      private$.full_path <- full_path
      private$.path <- path
      private$.volume <- volume
      private$.catalog <- catalog
      private$.schema <- schema

      super$initialize(path = path, extra_class = extra_class, ...)
    }
  ),
  active = list(
    #' @field path [character] Path to the file storage on Volume
    path = function(value) {
      if (missing(value)) {
        private$.path
      } else {
        stop("`$path` is read only", call. = FALSE)
      }
    },
    #' @field catalog [character] Databricks catalog
    catalog = function(value) {
      if (missing(value)) {
        private$.catalog
      } else {
        stop("`$catalog` is read only", call. = FALSE)
      }
    },
    #' @field schema [character] Databricks schema
    schema = function(value) {
      if (missing(value)) {
        private$.schema
      } else {
        stop("`$schema` is read only", call. = FALSE)
      }
    },
    #' @field full_path [character] Full path to the file storage on Volume
    full_path = function(value) {
      if (missing(value)) {
        private$.full_path
      } else {
        stop("`$full_path` is read only", call. = FALSE)
      }
    }
  ),
  private = list(
    .path = character(0),
    .volume = character(0),
    .catalog = character(0),
    .schema = character(0),
    .full_path = character(0),
    # Check if volume does not exist and create it if user wants.
    # @param catalog [character] The name of the catalog
    # @param schema [character] The name of the schema
    # @param volume [character] The name of the volume to create
    # @param force [boolean] If TRUE, the volume will be created without asking
    #  the user
    .check_databricks_volume_exists = function(catalog, schema, volume, force) {
      check_databricks_volume_exists(catalog, schema, volume, force)
    }
  )
)
