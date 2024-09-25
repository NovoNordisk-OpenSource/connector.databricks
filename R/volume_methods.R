#' @description
#' * [read_cnt.ConnectorDatabricksVolume]: Reuses the [connector::read_cnt()]
#'  method for [connector.databricks::ConnectorDatabricksVolume].
#'
#' @rdname read_cnt
#' @export
read_cnt.ConnectorDatabricksVolume <- function(connector_object, name, ...) {
  file_path <- file.path(connector_object$full_path, name)
  read_fs_databricks(path = file_path, ...)
}

#' @description
#' * [ConnectorDatabricksVolume]: Reuses the [connector::write_cnt()] method for
#'  [connector.databricks::ConnectorDatabricksVolume], but always sets the `catalog` and
#'  `schema` as defined in when initializing the connector.
#'
#' @rdname write_cnt
#' @export
write_cnt.ConnectorDatabricksVolume <- function(connector_object, x, name, ...) {
  file_path <- file.path(connector_object$full_path, name)
  write_fs_databricks(x, file = file_path, ...)
}

#' @description
#' * [ConnectorDatabricksVolume]: Reuses the [connector::list_content_cnt()]
#' method for [connector.databricks::ConnectorDatabricksVolume], but always sets the
#' `catalog` and `schema` as defined in when initializing the connector.
#'
#' @rdname list_content_cnt
#' @export
list_content_cnt.ConnectorDatabricksVolume <- function(connector_object, ...) {
  files_list_directory_contents(directory_path = connector_object$full_path, ...)
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
  files_delete_file(file_path = file_path, ...)
}
