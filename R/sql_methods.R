#' @description
#' * [ConnectorDatabricksSQL]: Reuses the [connector::remove_cnt()]
#'  method for [connector.databricks::ConnectorDatabricksSQL], but always
#' sets the `catalog` and `schema` as defined in when initializing the
#' connector.
#'
#' @rdname read_cnt
#' @export
remove_cnt.ConnectorDatabricksSQL <- function(
  connector_object,
  name,
  ...
) {
  brickster::db_uc_tables_delete(
    catalog = connector_object$catalog,
    schema = connector_object$schema,
    table = name,
    ...
  )

  invisible(connector_object)
}

#' @description
#' * [ConnectorDatabricksSQL]: Reuses the [connector::list_content_cnt()]
#'  method for [connector.databricks::ConnectorDatabricksSQL], but always
#' sets the `catalog` and `schema` as defined in when initializing the
#' connector.
#'
#' @rdname list_content_cnt
#' @export
list_content_cnt.ConnectorDatabricksSQL <- function(
  connector_object,
  ...
) {
  tables <- brickster::db_uc_tables_list(
    catalog = connector_object$catalog,
    schema = connector_object$schema,
    ...
  )

  sapply(tables, "[[", "name")
}

#' @description
#' * [ConnectorDatabricksSQL]: Reuses the [connector::write_cnt()]
#'  method for [connector.databricks::ConnectorDatabricksSQL], but always
#' sets the `catalog`, `schema` and `staging_volume` as defined in when
#' initializing the connector.
#'
#' @rdname write_cnt
#' @export
write_cnt.ConnectorDatabricksSQL <- function(
  connector_object,
  x,
  name,
  overwrite = zephyr::get_option("overwrite", "connector.databricks"),
  ...
) {
  connector_object$conn |>
    DBI::dbWriteTable(
      name = name,
      value = x,
      overwrite = overwrite,
      staging_volume = connector_object$staging_volume,
      ...
    )

  invisible(connector_object)
}
