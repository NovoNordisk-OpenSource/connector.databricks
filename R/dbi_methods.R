#' @export

cnt_read.connector_databricks_dbi <- function(connector_object, name, ...) {
  name <- DBI::Id(
    catalog = connector_object$catalog,
    schema = connector_object$schema,
    table = name
  )
  NextMethod()
}

#' @export

cnt_write.connector_databricks_dbi <- function(connector_object, x, name, ...) {
  name <- DBI::Id(
    catalog = connector_object$catalog,
    schema = connector_object$schema,
    table = name
  )
  NextMethod()
}

#' @export
cnt_list_content.connector_databricks_dbi <- function(connector_object, ...) {
  DBI::dbListTables(
    conn = connector_object$conn,
    catalog_name = connector_object$catalog,
    schema_name = connector_object$schema
  )
}

#' @export
cnt_remove.connector_databricks_dbi <- function(connector_object, name, ...) {
  name <- DBI::Id(
    catalog = connector_object$catalog,
    schema = connector_object$schema,
    table = name
  )
  NextMethod()
}

#' @export
cnt_tbl.connector_databricks_dbi <- function(connector_object, name, ...) {
  name <- DBI::Id(
    catalog = connector_object$catalog,
    schema = connector_object$schema,
    table = name
  )
  NextMethod()
}
