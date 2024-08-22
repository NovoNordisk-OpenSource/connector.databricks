#' @description
#' * [cnt_read.connector_databricks_volume]: Reuses the [connector::cnt_read()]
#'  method for [connector::connector_volume].
#'
#' @rdname connector::cnt_read
#' @export
cnt_read.connector_databricks_volume <- function(connector_object, name, ...) {
  file_path <- file.path(connector_object$path, name)
  read_fs_databricks(path = file_path, ...)
}

#' @description
#' * [connector_databricks_volume]: Reuses the [connector::cnt_write()] method for [connector::connector_databricks_volume],
#' but always sets the `catalog` and `schema` as defined in when initializing the connector.
#'
#' @rdname connector::cnt_write
#' @export
cnt_write.connector_databricks_volume <- function(connector_object, x, name, ...) {
  name <- DBI::Id(
    catalog = connector_object$catalog,
    schema = connector_object$schema,
    table = name
  )
  NextMethod()
}

#' @description
#' * [connector_databricks_volume]: Reuses the [connector::cnt_list_content()] method for [connector::connector_databricks_volume],
#' but always sets the `catalog` and `schema` as defined in when initializing the connector.
#'
#' @rdname connector::cnt_list_content
#' @export
cnt_list_content.connector_databricks_volume <- function(connector_object, ...) {
  DBI::dbListTables(
    conn = connector_object$conn,
    catalog_name = connector_object$catalog,
    schema_name = connector_object$schema
  )
}

#' @description
#' * [connector_databricks_volume]: Reuses the [connector::cnt_remove()] method for [connector::connector_databricks_volume],
#' but always sets the `catalog` and `schema` as defined in when initializing the connector.
#'
#' @rdname cnt_remove
#' @export
cnt_remove.connector_databricks_volume <- function(connector_object, name, ...) {
  name <- DBI::Id(
    catalog = connector_object$catalog,
    schema = connector_object$schema,
    table = name
  )
}

#' @description
#' * [connector_databricks_volume]: Reuses the [connector::cnt_tbl()] method for [connector::connector_volume],
#' but always sets the `catalog` and `schema` as defined in when initializing the connector.
#'
#' @rdname cnt_tbl
#' @export
cnt_tbl.connector_databricks_volume <- function(connector_object, name, ...) {
  name <- DBI::Id(
    catalog = connector_object$catalog,
    schema = connector_object$schema,
    table = name
  )
  NextMethod()
}
