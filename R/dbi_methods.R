#' @description
#' * [connector_databricks_dbi]: Reuses the [connector::write_cnt()] method for [connector::connector_dbi],
#' but always sets the `catalog` and `schema` as defined in when initializing the connector.
#'
#' @rdname read_cnt
#' @export
read_cnt.connector_databricks_dbi <- function(connector_object, name, ...) {
  name <- DBI::Id(
    catalog = connector_object$catalog,
    schema = connector_object$schema,
    table = name
  )
  NextMethod()
}

#' @description
#' * [connector_databricks_dbi]: Reuses the [connector::read_cnt()] method for [connector::connector_dbi],
#' but always sets the `catalog` and `schema` as defined in when initializing the connector.
#'
#' @rdname write_cnt
#' @export
write_cnt.connector_databricks_dbi <- function(connector_object, x, name, ...) {
  name <- DBI::Id(
    catalog = connector_object$catalog,
    schema = connector_object$schema,
    table = name
  )
  NextMethod()
}

#' @description
#' * [connector_databricks_dbi]: Reuses the [connector::list_content_cnt()] method for [connector::connector_dbi],
#' but always sets the `catalog` and `schema` as defined in when initializing the connector.
#'
#' @rdname list_content_cnt
#' @export
list_content_cnt.connector_databricks_dbi <- function(connector_object, ...) {
  DBI::dbListTables(
    conn = connector_object$conn,
    catalog_name = connector_object$catalog,
    schema_name = connector_object$schema
  )
}

#' @description
#' * [connector_databricks_dbi]: Reuses the [connector::remove_cnt()] method for [connector::connector_dbi],
#' but always sets the `catalog` and `schema` as defined in when initializing the connector.
#'
#' @rdname remove_cnt
#' @export
remove_cnt.connector_databricks_dbi <- function(connector_object, name, ...) {
  name <- DBI::Id(
    catalog = connector_object$catalog,
    schema = connector_object$schema,
    table = name
  )
  NextMethod()
}

#' @description
#' * [connector_databricks_dbi]: Reuses the [connector::tbl_cnt()] method for [connector::connector_dbi],
#' but always sets the `catalog` and `schema` as defined in when initializing the connector.
#'
#' @rdname tbl_cnt
#' @export
tbl_cnt.connector_databricks_dbi <- function(connector_object, name, ...) {
  name <- DBI::Id(
    catalog = connector_object$catalog,
    schema = connector_object$schema,
    table = name
  )
  NextMethod()
}
