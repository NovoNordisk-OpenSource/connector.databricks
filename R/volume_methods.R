#' @description
#' * [ConnectorDatabricksVolume]: Reuses the [connector::read_cnt()]
#'  method for [connector.databricks::ConnectorDatabricksVolume], but always sets the `catalog` and
#'  `schema` as defined in when initializing the connector.
#'
#' @rdname read_cnt
#' @param ... [ConnectorDatabricksVolume]: Additional parameters to pass to the [brickster::db_volume_read()] method
#' @export
read_cnt.ConnectorDatabricksVolume <- function(connector_object, name, ...) {
  file_path <- file.path(connector_object$full_path, name)
  brickster::db_volume_read(path = file_path, destination = name, ...)
  content <- connector::read_file(name)
  unlink(name)
  return(content)
}

#' @description
#' * [ConnectorDatabricksVolume]: Reuses the [connector::write_cnt()] method for
#'  [connector.databricks::ConnectorDatabricksVolume], but always sets the `catalog` and
#'  `schema` as defined in when initializing the connector.
#'
#' @rdname write_cnt
#' @param overwrite Overwrite a file if it already exists
#' @param ... [ConnectorDatabricksVolume]: Additional parameters to pass to the [brickster::db_volume_write()] method
#' @export
write_cnt.ConnectorDatabricksVolume <- function(connector_object, x, name, overwrite = FALSE, ...) {
  file_path <- file.path(connector_object$full_path, name)
  tmp_name <- tempfile(pattern = basename(name), fileext = paste0(".", tools::file_ext(name)))
  connector::write_file(x = x, file = tmp_name)
  brickster::db_volume_write(path = file_path, file = tmp_name, overwrite = overwrite)
  return(invisible(connector_object))
}

#' @description
#' * [ConnectorDatabricksVolume]: Reuses the [connector::list_content_cnt()]
#' method for [connector.databricks::ConnectorDatabricksVolume], but always sets the
#' `catalog` and `schema` as defined in when initializing the connector.
#'
#' @rdname list_content_cnt
#' @param ... [ConnectorDatabricksVolume]: Additional parameters to pass to the [brickster::db_volume_list()] method
#' @export
list_content_cnt.ConnectorDatabricksVolume <- function(connector_object, ...) {
  list_of_items <- brickster::db_volume_list(path = connector_object$full_path, ...)
  content_names <- unlist(purrr::map(list_of_items, ~ purrr::map(.x, "name")), use.names = FALSE)
  return(content_names)
}

#' @description
#' * [ConnectorDatabricksVolume]: Reuses the [connector::remove_cnt()] method
#' for [connector.databricks::ConnectorDatabricksVolume], but always sets the `catalog` and
#'  `schema` as defined in when initializing the connector.
#'
#' @rdname remove_cnt
#' @export
remove_cnt.ConnectorDatabricksVolume <- function(connector_object, name, ...) {
  file_path <- file.path(connector_object$full_path, name)
  brickster::db_volume_delete(path = file_path)
  return(invisible(connector_object))
}

#' @description
#' * [ConnectorDatabricksVolume]: Reuses the [connector::download_cnt()] method
#' for [connector.databricks::ConnectorDatabricksVolume], but always sets the `catalog` and
#'  `schema` as defined in when initializing the connector.
#'
#' @rdname download_cnt
#' @param ... [ConnectorDatabricksVolume]: Additional parameters to pass to the [brickster::db_volume_read()] method
#'
#' @return Response from the request
#' @export
download_cnt.ConnectorDatabricksVolume <- function(connector_object, name, file, ...) {
  file_path <- file.path(connector_object$full_path, name)
  brickster::db_volume_read(path = file_path, destination = file, ...)
}

#' @description
#' * [ConnectorDatabricksVolume]: Reuses the [connector::upload_cnt()] method
#' for [connector.databricks::ConnectorDatabricksVolume], but always sets the `catalog` and
#'  `schema` as defined in when initializing the connector.
#'
#' @rdname upload_cnt
#' @param overwrite Overwrite file if it already exists
#' @param ... [ConnectorDatabricksVolume]: Additional parameters to pass to the [brickster::db_volume_write()] method
#'
#' @return Information about success of the request
#' @export
upload_cnt.ConnectorDatabricksVolume <- function(connector_object,
                                                 file,
                                                 name,
                                                 overwrite = FALSE,
                                                 ...) {
  file_path <- file.path(connector_object$full_path, name)
  brickster::db_volume_write(path = file_path, file = file, overwrite = overwrite, ...)
}

#' Create a directory
#'
#' @rdname create_directory_cnt
#' @param ... [ConnectorDatabricksVolume]: Additional parameters to pass to the [brickster::db_volume_dir_create] method
#'
#' @return New [ConnectorDatabricksVolume] object of a newly built directory
#' @export
create_directory_cnt.ConnectorDatabricksVolume <- function(connector_object, name, ...) {
  directory_path <- file.path(connector_object$full_path, name)

  brickster::db_volume_dir_create(path = directory_path, ...)
  return(invisible(connector_databricks_volume(
    full_path = directory_path
  )))
}

#' Remove a directory
#'
#' @rdname remove_directory_cnt
#' @param ... [ConnectorDatabricksVolume]: Additional parameters to pass to the
#' [brickster::db_volume_dir_delete()] method
#'
#' @export
remove_directory_cnt.ConnectorDatabricksVolume <- function(connector_object, name, ...) {
  directory_path <- file.path(connector_object$full_path, name)
  brickster::db_volume_dir_delete(path = directory_path)
  return(invisible(connector_object))
}

#' Check if databricks volume exists
#'
#' Utility function used as a private function for [ConnectorDatabricksVolume] object
#' to check if volume already exists, if not it will promt user to create a new one.
#'
#' @param catalog [character] The name of the catalog
#' @param schema [character] The name of the schema
#' @param volume [character] The name of the volume to create
#' @param force [boolean] If TRUE, the volume will be created without asking
#'
#' @keywords internal
#' @noRd
check_databricks_volume_exists <- function(catalog, schema, volume, force = FALSE) {
  db_client <- DatabricksClient()
  volumes <- list_databricks_volumes(catalog_name = catalog, schema_name = schema)

  if (length(volumes) == 0 || !(volume %in% volumes$name)) {
    cli::cli_alert("Volume does not exist.")
    if (force) {
      cli::cli_alert("Creating volume...")
      create_databricks_volume(
        name = volume,
        catalog_name = catalog,
        schema_name = schema
      )
      cli::cli_alert("Volume created!")
      return(NULL)
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
