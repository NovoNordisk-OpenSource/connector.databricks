#' @description
#' * [ConnectorDatabricksTable]: Reuses the [connector::read_cnt()]
#'  method for [connector.databricks::ConnectorDatabricksTable], but always
#' sets the `catalog` and `schema` as defined in when initializing the
#' connector.
#'
#' @rdname read_cnt
# nolint start
#' @param timepoint Timepoint in [Delta time travel syntax](https://docs.databricks.com/gcp/en/delta/history#delta-time-travel-syntax)
#' format.
# nolint end
#' @param version Table version generated by the operation.
#' @export
read_cnt.ConnectorDatabricksTable <- function(
  connector_object,
  name,
  ...,
  timepoint = NULL,
  version = NULL
) {
  read_table_timepoint(
    connector_object = connector_object,
    name = name,
    timepoint = timepoint,
    version = version
  )
}

#' @description
#' * [ConnectorDatabricksTable]: Reuses the [connector::write_cnt()]
#'  method for [connector.databricks::ConnectorDatabricksTable], but always
#' sets the `catalog` and `schema` as defined in when initializing the
#' connector. Creates temporary volume to write object as a
#' parquet file and then convert it to a table.
#'
#' @rdname write_cnt
#' @param method * [ConnectorDatabricksTable]: Which method to use for writing the
#'  table. Options:
#' \itemize{
#'   \item `volume` - using temporary volume to write data and then convert it
#'     to a table.
#' }
#' @param tags * [ConnectorDatabricksTable]: Named list containing tag names
#' and tag values, e.g.
#' `list("tag_name1" = "tag_value1", "tag_name2" = "tag_value2")`.
#' More info [here](https://docs.databricks.com/aws/en/database-objects/tags)
#' @export
write_cnt.ConnectorDatabricksTable <- function(
  connector_object,
  x,
  name,
  overwrite = zephyr::get_option("overwrite", "connector.databricks"),
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
#' * [ConnectorDatabricksTable]: Reuses the [connector::list_content_cnt()]
#'  method for [connector.databricks::ConnectorDatabricksTable], but always
#' sets the `catalog` and `schema` as defined in when initializing the
#' connector.
#'
#' @rdname list_content_cnt
#' @param ... [ConnectorDatabricksTable]: Additional parameters to pass to the
#'  [brickster::db_uc_tables_list()] method
#' @param tags Expression to be translated to SQL using
#' [dbplyr::translate_sql()] e.g.
#' `((tag_name == "name1" && tag_value == "value1") || (tag_name == "name2"))`.
#' It should contain `tag_name` and `tag_value` values to filter by.
#' @export
list_content_cnt.ConnectorDatabricksTable <- function(
  connector_object,
  ...,
  tags = NULL
) {
  tags <- dbplyr::translate_sql({{ tags }}, con = connector_object$conn)
  if (is.na(tags["sql"])) {
    tables <- brickster::db_uc_tables_list(
      catalog = connector_object$catalog,
      schema = connector_object$schema,
      ...
    )
    return(sapply(tables, "[[", "name"))
  }

  return(list_content_tags(connector_object, tags))
}

#' @description
#' * [ConnectorDatabricksTable]: Reuses the [connector::list_content_cnt()]
#'  method for [connector.databricks::ConnectorDatabricksTable], but always
#' sets the `catalog` and `schema` as defined in when initializing the
#' connector.
#'
#' @param ... [ConnectorDatabricksTable]: Additional parameters to pass to the
#'  [brickster::db_uc_tables_delete()] method
#'
#' @rdname remove_cnt
#' @export
remove_cnt.ConnectorDatabricksTable <- function(connector_object, name, ...) {
  brickster::db_uc_tables_delete(
    catalog = connector_object$catalog,
    schema = connector_object$schema,
    table = name,
    ...
  )
}

#' @description
#' * [ConnectorDatabricksTable]: Reuses the [connector::list_content_cnt()]
#'  method for [connector.databricks::ConnectorDatabricksTable], but always
#' sets the `catalog` and `schema` as defined in when initializing the
#' connector.
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
