#' @description
#' * [ConnectorDatabricksSQL]: Reuses the [connector::read_cnt()]
#' method for [connector.databricks::ConnectorDatabricksSQL], but always
#' sets the `catalog` and `schema` as defined in when initializing the
#' connector.
#'
#' @rdname read_cnt
#' @export
read_cnt.ConnectorDatabricksSQL <- function(
  connector_object,
  name,
  ...
) {
  name <- DBI::Id(connector_object$catalog, connector_object$schema, name)
  NextMethod()
}

#' @description
#' * [ConnectorDatabricksSQL]: Reuses the [connector::write_cnt()]
#' method for [connector.databricks::ConnectorDatabricksSQL], but always
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
  brickster::dbWriteTable(
    conn = connector_object$conn,
    name = DBI::Id(connector_object$catalog, connector_object$schema, name),
    value = x,
    overwrite = overwrite,
    staging_volume = connector_object$staging_volume,
    ...
  )

  connector_object
}

#' @description
#' * [ConnectorDatabricksSQL]: Reuses the [connector::list_content_cnt()]
#' method for [connector.databricks::ConnectorDatabricksSQL], but always
#' sets the `catalog` and `schema` as defined in when initializing the
#' connector.
#'
#' @rdname list_content_cnt
#' @export
list_content_cnt.ConnectorDatabricksSQL <- function(
  connector_object,
  ...
) {
  NextMethod()
}

#' @description
#' * [ConnectorDatabricksSQL]: Reuses the [connector::remove_cnt()]
#' method for [connector.databricks::ConnectorDatabricksSQL], but always
#' sets the `catalog` and `schema` as defined in when initializing the
#' connector.
#'
#' @rdname remove_cnt
#' @export
remove_cnt.ConnectorDatabricksSQL <- function(
  connector_object,
  name,
  ...
) {
  name <- DBI::Id(connector_object$catalog, connector_object$schema, name)
  NextMethod()
}

#' @description
#' * [ConnectorDatabricksSQL]: Reuses the [connector::tbl_cnt()]
#'  method for [connector.databricks::ConnectorDatabricksTable], but always
#' sets the `catalog` and `schema` as defined in when initializing the
#' connector.
#'
#' @rdname tbl_cnt
#' @export
tbl_cnt.ConnectorDatabricksSQL <- function(connector_object, name, ...) {
  name <- DBI::Id(connector_object$catalog, connector_object$schema, name)
  NextMethod()
}
