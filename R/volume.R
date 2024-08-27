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
#' databricks_volume <- "my_adam/tester"
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
connector_databricks_volume <- function(full_path = NULL,
                                        catalog = NULL,
                                        schema = NULL,
                                        path = NULL,
                                        extra_class = NULL,
                                        force = FALSE,
                                        ...) {
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
#' cnt <- ConnectorDatabricksVolume$new(full_path = "my_adam/tester")
#'
#' cnt
#'
#' # List content
#' cnt$cnt_list_content()
#'
#' # Write to the connector
#' cnt$cnt_write(iris, "iris.rds")
#'
#' # Check it is there
#' cnt$cnt_list_content()
#'
#' # Read the result back
#' cnt$cnt_read("iris.rds") |>
#'   head()
#'
#' @export
ConnectorDatabricksVolume <- R6::R6Class(
  classname = "ConnectorDatabricksVolume",
  inherit = connector::connector,
  public = list(
    #' @description
    #' Initializes the connector for Databricks volume storage.
    #' @param full_path [character] Full path to the file storage in format
    #' `catalog/schema/path`. If NULL, `catalog`, `schema`, and `path` must be
    #' provided.
    #' @param catalog [character] Databricks catalog
    #' @param schema [character] Databricks schema
    #' @param path [character] Path to the file storage
    #' @param extra_class [character] Extra class to assign to the new connector.
    #' @param force [logical] If TRUE, the volume will be created without
    #' asking if it does not exist.
    #' @param ... Additional arguments passed to the [connector::connector]
    #'
    #' @inheritParams files_list_directory_contents
    #'
    #' @importFrom cli cli_abort
    #' @importFrom checkmate assert_string assert_logical
    #'
    #' @return A new [ConnectorDatabricksVolume] object
    initialize = function(full_path = NULL,
                          catalog = NULL,
                          schema = NULL,
                          path = NULL,
                          extra_class = NULL,
                          force = FALSE,
                          ...) {
      if (is.null(full_path)) {
        checkmate::assert_string(x = path, null.ok = FALSE)
        checkmate::assert_string(x = catalog, null.ok = FALSE)
        checkmate::assert_string(x = schema, null.ok = FALSE)
        full_path <- file.path(catalog, schema, path)
      } else {
        checkmate::assert_string(x = full_path, null.ok = FALSE)
      }
      checkmate::assert_string(x = extra_class, null.ok = TRUE)
      checkmate::assert_logical(x = force, max.len = 1, null.ok = FALSE)

      split_path <- unlist(strsplit(full_path, "/"))
      if (length(split_path) < 3) {
        cli::cli_abort("Full path must be in the format catalog/schema/path.")
      }
      catalog <- split_path[1]
      schema <- split_path[2]
      volume <- split_path[3]
      path <- paste(split_path[3:length(split_path)], collapse = "/")

      # Check if volume exists and create it if it does not
      private$.check_databricks_volume_exists(
        catalog = catalog,
        schema = schema,
        volume = volume,
        force = force
      )

      # Try and create a directory, if it already exists, it will be returned
      full_path <- paste0("/Volumes/", full_path)
      files_create_directory(directory_path = full_path)

      private$.full_path <- full_path
      private$.path <- path
      private$.volume <- volume
      private$.catalog <- catalog
      private$.schema <- schema

      super$initialize(extra_class = extra_class, ...)
    },

    #' @description Download a file
    #' @param file_path Required. The absolute path of the file.
    #' @param local_path local path for the file.
    #' @param ... Additional parameters to pass to the [cnt_download_content] method
    #' @return The file downloaded
    cnt_download = function(file_path, local_path = basename(name), ...) {
      self %>%
        cnt_download_content(name = file_path, dest = local_path, ...)
    },

    #' @description Upload a file
    #' @param file_path The absolute path of the file.
    #' @param contents File content
    #' @param overwrite If true, an existing file will be overwritten.
    #' @param ... Additional parameters to pass to the [cnt_upload_content] method
    #' @return The file uploaded
    cnt_upload = function(file_path, contents, overwrite, ...) {
      self %>%
        cnt_upload_content(src = contents, dest = file_path, overwrite, ...)
    },

    #' @description Create a directory
    #' @param name The name of the directory to create
    #' @param ... Additional parameters to pass to the [cnt_create_directory] method
    #' @return The directory created
    cnt_create_directory = function(name, ...) {
      self %>%
        cnt_create_directory(name = name, ...)
    },

    #' @description
    #' Remove a directory from the file storage.
    #' See also [cnt_remove_directory].
    #' @param name [character] The name of the directory to remove
    cnt_remove_directory = function(name, ...) {
      self %>%
        cnt_remove_directory(name, ...)
    }
  ),
  active = list(
    #' @field path [character] Path to the file storage on Volume
    path = function() {
      private$.path
    },
    #' @field catalog [character] Databricks catalog
    catalog = function() {
      private$.catalog
    },
    #' @field schema [character] Databricks schema
    schema = function() {
      private$.schema
    },
    #' @field full_path [character] Full path to the file storage on Volume
    full_path = function() {
      private$.full_path
    }
  ),
  private = list(
    .path = character(0),
    .volume = character(0),
    .catalog = character(0),
    .schema = character(0),
    .full_path = character(0),
    #' @description
    #' Check if volume does not exist and create it if user wants.
    #' @param catalog [character] The name of the catalog
    #' @param schema [character] The name of the schema
    #' @param volume [character] The name of the volume to create
    #' @param force [boolean] If TRUE, the volume will be created without asking
    #'  the user
    #' @importFrom cli cli_alert cli_abort
    .check_databricks_volume_exists = function(catalog, schema, volume, force = FALSE) {
      db_client <- DatabricksClient()
      volumes <- list_databricks_volumes(catalog_name = catalog, schema_name = schema)
      if (!(volume %in% volumes$name)) {
        cli::cli_alert("Volume does not exist.")
        if (force) {
          cli::cli_alert("Creating volume...")
          create_databricks_volume(
            name = volume,
            catalog_name = catalog,
            schema_name = schema
          )
          cli::cli_alert("Volume created!")
        }
        menu <- menu(c("Create volume", "Exit"), title = "What would you like to do?")
        if (menu == 1) {
          cli::cli_alert("Creating volume...")
          create_databricks_volume(
            name = volume,
            catalog_name = catalog,
            schema_name = schema
          )
          cli::cli_alert("Volume created!")
        } else {
          cli::cli_abort("Exiting...")
        }
      }
      return(NULL)
    }
  )
)
