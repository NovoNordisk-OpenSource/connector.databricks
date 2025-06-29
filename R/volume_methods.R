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
  withr::with_tempdir({
    brickster::db_volume_read(path = file_path, destination = name, ...)
    content <- connector::read_file(name)
    unlink(name)
  })

  content
}

#' @description
#' * [ConnectorDatabricksVolume]: Reuses the [connector::write_cnt()] method for
#'  [connector.databricks::ConnectorDatabricksVolume], but always sets the `catalog` and
#'  `schema` as defined in when initializing the connector.
#'
#' @rdname write_cnt
#' @param overwrite Overwrite existing content if it exists in the connector.
#' @param ... [ConnectorDatabricksVolume]: Additional parameters to pass to the [brickster::db_volume_write()] method
#' @return [ConnectorDatabricksVolume] object
#' @export
write_cnt.ConnectorDatabricksVolume <- function(
  connector_object,
  x,
  name,
  overwrite = zephyr::get_option("overwrite", "connector.databricks"),
  ...
) {
  file_path <- file.path(connector_object$full_path, name)
  tmp_name <- tempfile(
    pattern = basename(name),
    fileext = paste0(".", tools::file_ext(name))
  )
  connector::write_file(x = x, file = tmp_name)
  brickster::db_volume_write(
    path = file_path,
    file = tmp_name,
    overwrite = overwrite
  )

  invisible(connector_object)
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
  list_of_items <- brickster::db_volume_list(
    path = connector_object$full_path,
    ...
  )
  content_names <- unlist(
    purrr::map(list_of_items, ~ purrr::map(.x, "name")),
    use.names = FALSE
  )

  content_names
}

#' @description
#' * [ConnectorDatabricksVolume]: Reuses the [connector::remove_cnt()] method
#' for [connector.databricks::ConnectorDatabricksVolume], but always sets the `catalog` and
#'  `schema` as defined in when initializing the connector.
#'
#' @rdname remove_cnt
#' @return [ConnectorDatabricksVolume] object
#' @export
remove_cnt.ConnectorDatabricksVolume <- function(connector_object, name, ...) {
  file_path <- file.path(connector_object$full_path, name)
  brickster::db_volume_delete(path = file_path)

  invisible(connector_object)
}

#' @description
#' * [ConnectorDatabricksVolume]: Reuses the [connector::download_cnt()] method
#' for [connector.databricks::ConnectorDatabricksVolume], but always sets the `catalog` and
#'  `schema` as defined in when initializing the connector.
#'
#' @rdname download_cnt
#' @param ... [ConnectorDatabricksVolume]: Additional parameters to pass to the [brickster::db_volume_read()] method
#'
#' @return [ConnectorDatabricksVolume] object
#' @export
download_cnt.ConnectorDatabricksVolume <- function(
  connector_object,
  name,
  file = basename(name),
  ...
) {
  file_path <- file.path(connector_object$full_path, name)
  brickster::db_volume_read(path = file_path, destination = file, ...)

  invisible(connector_object)
}

#' @description
#' * [ConnectorDatabricksVolume]: Reuses the [connector::upload_cnt()] method
#' for [connector.databricks::ConnectorDatabricksVolume], but always sets the `catalog` and
#'  `schema` as defined in when initializing the connector.
#'
#' @rdname upload_cnt
#' @param ... [ConnectorDatabricksVolume]: Additional parameters to pass to the [brickster::db_volume_write()] method
#' @param overwrite Overwrites existing content if it exists in the connector.
#' @return [ConnectorDatabricksVolume] object
#' @export
upload_cnt.ConnectorDatabricksVolume <- function(
  connector_object,
  file,
  name = basename(file),
  overwrite = zephyr::get_option("overwrite", "connector.databricks"),
  ...
) {
  file_path <- file.path(connector_object$full_path, name)
  brickster::db_volume_write(
    path = file_path,
    file = file,
    overwrite = overwrite,
    ...
  )

  invisible(connector_object)
}

#' Create a directory
#'
#' @rdname create_directory_cnt
#' @param ... [ConnectorDatabricksVolume]: Additional parameters to pass to the [brickster::db_volume_dir_create] method
#' @param open create a new connector object
#'
#' @return [ConnectorDatabricksVolume] object or [ConnectorDatabricksVolume] object of a newly built directory
#' @export
create_directory_cnt.ConnectorDatabricksVolume <- function(
  connector_object,
  name,
  open = TRUE,
  ...
) {
  directory_path <- file.path(connector_object$full_path, name)

  brickster::db_volume_dir_create(path = directory_path, ...)
  if (open) {
    connector_object <- connector_databricks_volume(full_path = directory_path)
  }

  invisible(connector_object)
}

#' Remove a directory
#'
#' @rdname remove_directory_cnt
#' @param ... [ConnectorDatabricksVolume]: Additional parameters to pass to
#' the [brickster::db_volume_dir_delete()] method
#' @return [ConnectorDatabricksVolume] object
#' @export
remove_directory_cnt.ConnectorDatabricksVolume <- function(
  connector_object,
  name,
  ...
) {
  directory_path <- file.path(connector_object$full_path, name)
  brickster::db_volume_dir_delete(path = directory_path)

  invisible(connector_object)
}

#' @description
#' * [ConnectorDatabricksVolume]: Uses [read_cnt()] to allow redundancy between Volumes and DBI.
#'
#' @rdname tbl_cnt
#' @export
tbl_cnt.ConnectorDatabricksVolume <- function(connector_object, name, ...) {
  read_cnt(connector_object = connector_object, name = name, ...)
}

#' Check if databricks volume exists
#'
#'
#' Utility function used as a private function for [ConnectorDatabricksVolume]
#' object to check if volume already exists, if not it will prompt user to
#' create a new one.
#'
#'
#' @param catalog [character] The name of the catalog
#' @param schema [character] The name of the schema
#' @param volume [character] The name of the volume to create
#' @param force [boolean] If TRUE, the volume will be created without asking
#'
#'
#' @keywords internal
#' @noRd
check_databricks_volume_exists <- function(
  catalog,
  schema,
  volume,
  force = FALSE
) {
  tryCatch(
    {
      brickster::db_uc_volumes_get(
        volume = volume,
        catalog = catalog,
        schema = schema
      )
      return(NULL)
    },
    error = function(e) {
      if (force) {
        invisible(brickster::db_uc_volumes_create(
          volume = volume,
          catalog = catalog,
          schema = schema
        ))
        return(NULL)
      }
      menu <- menu(
        c("Create volume", "Exit"),
        title = "Volume does not exist. What would you like to do?"
      )
      if (menu == 1) {
        zephyr::msg_info("Creating volume {catalog}/{schema}/{volume}...")
        invisible(brickster::db_uc_volumes_create(
          volume = volume,
          catalog = catalog,
          schema = schema
        ))
        zephyr::msg_info("Volume created!")
      } else {
        cli::cli_abort("Exiting...")
      }
    }
  )
  return(NULL)
}
