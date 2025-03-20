#' @description
#' * [ConnectorDatabricksTable]: Reuses the [connector::write_cnt()] method for [connector::connector_dbi],
#' but always sets the `catalog` and `schema` as defined in when initializing the connector.
#'
#' @rdname read_cnt
#' @export
read_cnt.ConnectorDatabricksTable <- function(connector_object, name, ...) {
  name <- DBI::Id(
    catalog = connector_object$catalog,
    schema = connector_object$schema,
    table = name
  )
  NextMethod()
}

#' @description
#' * [ConnectorDatabricksTable]: Creates temporary volume to write object as a parquet file and then
#' convert it to a table.
#'
#' @rdname write_cnt
#' @param method [ConnectorDatabricksTable]: Which method to use for writing the table. Options:
#' \itemize{
#'   \item `volume` - using temporary volume to write data and then convert it to a table.
#' }
#' @param tags Named list containing tag names and tag values, e.g.
#' list("tag_name1" = "tag_value1", "tag_name2" = "tag_value2")
#' More info [here](https://docs.databricks.com/aws/en/database-objects/tags)
#' @export
write_cnt.ConnectorDatabricksTable <- function(
  connector_object,
  x,
  name,
  overwrite = FALSE,
  ...,
  method = "volume",
  tags = NULL
) {
  checkmate::assert_character(name)
  checkmate::assert_choice(method, c("volume"), null.ok = FALSE)
  if (method == "volume") {
    write_table_volume(connector_object, x, name, overwrite, tags)
    return(invisible(connector_object))
  }
}

#' @description
#' * [ConnectorDatabricksTable]: Reuses the [connector::list_content_cnt()] method for [connector::connector_dbi],
#' but always sets the `catalog` and `schema` as defined in when initializing the connector.
#'
#' @rdname list_content_cnt
#' @export
list_content_cnt.ConnectorDatabricksTable <- function(connector_object, ...) {
  DBI::dbListTables(
    conn = connector_object$conn,
    catalog_name = connector_object$catalog,
    schema_name = connector_object$schema
  )
}

#' @description
#' * [ConnectorDatabricksTable]: Reuses the [connector::remove_cnt()] method for [connector::connector_dbi],
#' but always sets the `catalog` and `schema` as defined in when initializing the connector.
#'
#' @rdname remove_cnt
#' @export
remove_cnt.ConnectorDatabricksTable <- function(connector_object, name, ...) {
  name <- DBI::Id(
    catalog = connector_object$catalog,
    schema = connector_object$schema,
    table = name
  )
  NextMethod()
}

#' @description
#' * [ConnectorDatabricksTable]: Reuses the [connector::tbl_cnt()] method for [connector::connector_dbi],
#' but always sets the `catalog` and `schema` as defined in when initializing the connector.
#'
#' @rdname tbl_cnt
#' @export
tbl_cnt.ConnectorDatabricksTable <- function(connector_object, name, ...) {
  name <- DBI::Id(
    catalog = connector_object$catalog,
    schema = connector_object$schema,
    table = name
  )
  NextMethod()
}
