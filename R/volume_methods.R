#' @description
#' * [cnt_read.ConnectorDatabricksVolume]: Reuses the [connector::cnt_read()]
#'  method for [connector.databricks::ConnectorDatabricksVolume].
#'
#' @rdname cnt_read
#' @export
cnt_read.ConnectorDatabricksVolume <- function(connector_object, name, ...) {
  file_path <- file.path(connector_object$full_path, name)
  read_fs_databricks(path = file_path, ...)
}

#' @description
#' * [ConnectorDatabricksVolume]: Reuses the [connector::cnt_write()] method for
#'  [connector.databricks::ConnectorDatabricksVolume], but always sets the `catalog` and
#'  `schema` as defined in when initializing the connector.
#'
#' @rdname cnt_write
#' @export
cnt_write.ConnectorDatabricksVolume <- function(connector_object, x, name, ...) {
  file_path <- file.path(connector_object$full_path, name)
  write_fs_databricks(x, file = file_path, ...)
}

#' @description
#' * [ConnectorDatabricksVolume]: Reuses the [connector::cnt_list_content()]
#' method for [connector.databricks::ConnectorDatabricksVolume], but always sets the
#' `catalog` and `schema` as defined in when initializing the connector.
#'
#' @rdname cnt_list_content
#' @export
cnt_list_content.ConnectorDatabricksVolume <- function(connector_object, ...) {
  files_list_directory_contents(directory_path = connector_object$full_path, ...)
}

#' @description
#' * [ConnectorDatabricksVolume]: Reuses the [connector::cnt_remove()] method
#' for [connector.databricks::ConnectorDatabricksVolume], but always sets the `catalog` and
#'  `schema` as defined in when initializing the connector.
#'
#' @rdname cnt_remove
#' @export
cnt_remove.ConnectorDatabricksVolume <- function(connector_object, name, ...) {
  file_path <- file.path(connector_object$full_path, name)
  files_delete_file(file_path = file_path, ...)
}
