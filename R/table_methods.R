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
#' * [ConnectorDatabricksTable]: Reuses the [connector::read_cnt()] method for [connector::connector_dbi],
#' but always sets the `catalog` and `schema` as defined in when initializing the connector.
#'
#' @rdname write_cnt
#' @param method Which method to use for writing the table. `volume` is used for writing bigger amounts of data.
#' @export
write_cnt.ConnectorDatabricksTable <- function(
  connector_object,
  x,
  name,
  ...,
  method = "volume"
) {
  checkmate::assert_character(name)
  checkmate::assert_choice(method, c("volume"), null.ok = FALSE)
  if (method == "volume") {
    temporary_volume <- tmp_volume(connector_object)

    zephyr::msg_info("Writing to a table...")
    temporary_volume$write_cnt(
      x = x,
      name = paste0(name, ".parquet")
    )
    parquet_to_table(
      connector_object = connector_object,
      tmp_volume = temporary_volume,
      name = name
    )
    zephyr::msg_success("Table written successfully!")

    withr::defer(
      brickster::db_uc_volumes_delete(
        catalog = connector_object$catalog,
        schema = connector_object$schema,
        volume = temporary_volume$path
      )
    )
    zephyr::msg_info("Temporary volume deleted.")

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
