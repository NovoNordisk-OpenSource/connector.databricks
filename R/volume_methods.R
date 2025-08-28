#' @rdname read_cnt
#'
#' @description
#' * [ConnectorDatabricksVolume]: Reuses the [connector::read_cnt()]
#'  method for [connector.databricks::ConnectorDatabricksVolume], but always
#' sets the `catalog`, `schema` and `path` as defined in when initializing the
#' connector.
#'
#' @param ... [ConnectorDatabricksVolume]: Additional parameters to pass to the
#' [brickster::db_volume_read()] method
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


#' @rdname write_cnt
#'
#' @description
#' * [ConnectorDatabricksVolume]: Reuses the [connector::write_cnt()]
#'  method for [connector.databricks::ConnectorDatabricksVolume], but always
#' sets the `catalog`, `schema` and `path` as defined in when initializing the
#' connector.
#' @param overwrite Overwrite existing content if it exists in the connector.
#' @param ... [ConnectorDatabricksVolume]: Additional parameters to pass to the
#'  [brickster::db_volume_write()] method
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

#' @rdname list_content_cnt
#'
#' @description
#' * [ConnectorDatabricksVolume]: Reuses the [connector::list_content_cnt()]
#'  method for [connector.databricks::ConnectorDatabricksVolume], but always
#' sets the `catalog`, `schema` and `path` as defined in when initializing the
#' connector.
#'
#' @param ... [ConnectorDatabricksVolume]: Additional parameters to pass to the
#' [brickster::db_volume_list()] method
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

#' @rdname remove_cnt
#'
#' @description
#' * [ConnectorDatabricksVolume]: Reuses the [connector::remove_cnt()]
#'  method for [connector.databricks::ConnectorDatabricksVolume], but always
#' sets the `catalog`, `schema` and `path` as defined in when initializing the
#' connector.
#'
#' @export
remove_cnt.ConnectorDatabricksVolume <- function(connector_object, name, ...) {
  file_path <- file.path(connector_object$full_path, name)
  brickster::db_volume_delete(path = file_path, ...)

  invisible(connector_object)
}

#' @rdname download_cnt
#'
#' @description
#' * [ConnectorDatabricksVolume]: Reuses the [connector::download_cnt()]
#'  method for [connector.databricks::ConnectorDatabricksVolume], but always
#' sets the `catalog`, `schema` and `path` as defined in when initializing the
#' connector.
#'
#' @param ... [ConnectorDatabricksVolume]: Additional parameters to pass to the
#'  [brickster::db_volume_read()] method
#'
#' @export
download_cnt.ConnectorDatabricksVolume <- function(
  connector_object,
  src,
  dest = basename(src),
  ...
) {
  file_path <- file.path(connector_object$full_path, src)
  brickster::db_volume_read(path = file_path, destination = dest, ...)

  invisible(connector_object)
}

#' @rdname upload_cnt
#'
#' @description
#' * [ConnectorDatabricksVolume]: Reuses the [connector::upload_cnt()]
#'  method for [connector.databricks::ConnectorDatabricksVolume], but always
#' sets the `catalog`, `schema` and `path` as defined in when initializing the
#' connector.
#'
#' @param ... [ConnectorDatabricksVolume]: Additional parameters to pass to the
#' [brickster::db_volume_write()] method
#' @param overwrite Overwrites existing content if it exists in the connector.
#' @export
upload_cnt.ConnectorDatabricksVolume <- function(
  connector_object,
  src,
  dest = basename(src),
  overwrite = zephyr::get_option("overwrite", "connector.databricks"),
  ...
) {
  file_path <- file.path(connector_object$full_path, dest)
  brickster::db_volume_write(
    path = file_path,
    file = src,
    overwrite = overwrite,
    ...
  )

  invisible(connector_object)
}

#' @rdname create_directory_cnt
#'
#' @description
#' * [ConnectorDatabricksVolume]: Reuses the [connector::create_directory_cnt()]
#'  method for [connector.databricks::ConnectorDatabricksVolume], but always
#' sets the `catalog`, `schema` and `path` as defined in when initializing the
#' connector.
#'
#' @param ... [ConnectorDatabricksVolume]: Additional parameters to pass to the
#' [brickster::db_volume_dir_create] method
#' @param open create a new connector object
#'
#'
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

#' @rdname remove_directory_cnt
#'
#' @description
#' * [ConnectorDatabricksVolume]: Reuses the [connector::remove_directory_cnt()]
#'  method for [connector.databricks::ConnectorDatabricksVolume], but always
#' sets the `catalog`, `schema` and `path` as defined in when initializing the
#' connector.
#'
#' @param ... [ConnectorDatabricksVolume]: Additional parameters to pass to
#' the [brickster::db_volume_dir_delete()] method
#' @export
remove_directory_cnt.ConnectorDatabricksVolume <- function(
  connector_object,
  name,
  ...
) {
  directory_path <- file.path(connector_object$full_path, name)
  remove_directory(dir_path = directory_path)

  invisible(connector_object)
}

#' @rdname tbl_cnt
#'
#' @description
#' * [ConnectorDatabricksVolume]: Reuses the [connector::remove_directory_cnt()]
#'  method for [connector.databricks::ConnectorDatabricksVolume], but always
#' sets the `catalog`, `schema` and `path` as defined in when initializing the
#' connector. Uses [read_cnt()] to allow redundancy between
#' Volumes and Tables.
#'
#' @export
tbl_cnt.ConnectorDatabricksVolume <- function(connector_object, name, ...) {
  read_cnt(connector_object = connector_object, name = name, ...)
}

#' @rdname upload_directory_cnt
#'
#' @description
#' * [ConnectorDatabricksVolume]: Reuses the [connector::upload_directory_cnt()]
#'  method for [connector.databricks::ConnectorDatabricksVolume], but always
#' sets the `catalog`, `schema` and `path` as defined in when initializing the
#' connector.
#'
#' @param ... [ConnectorDatabricksVolume]: Additional parameters to pass to
#' the [brickster::db_volume_dir_create()] method
#' @export
upload_directory_cnt.ConnectorDatabricksVolume <- function(
  connector_object,
  src,
  dest = basename(src),
  overwrite = zephyr::get_option("overwrite", "connector"),
  open = FALSE,
  ...
) {
  upload_directory(
    dir = src,
    name = dest,
    dir_path = connector_object$full_path,
    overwrite = overwrite,
    ...
  )

  # create a new connector object from the new path with persistent extra class
  if (open) {
    extra_class <- class(connector_object)
    extra_class <- utils::head(
      extra_class,
      which(extra_class == "ConnectorDatabricksVolume") - 1
    )
    connector_object <- connector_databricks_volume(paste0(
      connector_object$full_path,
      "/",
      dest
    ))
  }

  return(
    invisible(connector_object)
  )
}

#' @rdname download_directory_cnt
#'
#' @description
#' * [ConnectorDatabricksVolume]: Reuses the
#' [connector::download_directory_cnt()] method for
#' [connector.databricks::ConnectorDatabricksVolume], but always sets the
#' `catalog`, `schema` and `path` as defined in when initializing the connector.
#'
#' @param ... [ConnectorDatabricksVolume]: Additional parameters to pass to
#' the [brickster::db_volume_dir_create()] method
#' @export
download_directory_cnt.ConnectorDatabricksVolume <- function(
  connector_object,
  src,
  dest = basename(src),
  ...
) {
  dir_path <- file.path(connector_object$full_path, src)

  download_directory(
    dir_path = dir_path,
    name = dest,
    ...
  )

  return(
    invisible(connector_object)
  )
}
