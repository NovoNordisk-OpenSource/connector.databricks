#' Log Read Operation for Databricks Table connector
#'
#' @description
#' * [ConnectorDatabricksTable]: Implementation of the `log_read_connector`
#' function for the ConnectorDatabricksTable class.
#'
#' @rdname log_read_connector
#'
#' @export
log_read_connector.ConnectorDatabricksTable <- function(
  connector_object,
  name,
  ...
) {
  msg <- log_connector_message(connector_object, name, ...)
  whirl::log_read(msg)
}

#' Log Write Operation for Databricks Table connector
#'
#' @description
#' * [ConnectorDatabricksTable]: Implementation of the `log_write_connector`
#' function for the ConnectorDatabricksTable class.
#'
#' @rdname log_write_connector
#'
#' @export
log_write_connector.ConnectorDatabricksTable <- function(
  connector_object,
  name,
  ...
) {
  msg <- log_connector_message(connector_object, name, ...)
  whirl::log_write(msg)
}

#' Log Remove Operation for Databricks Table connector
#'
#' @description
#' * [ConnectorDatabricksTable]: Implementation of the `log_remove_connector`
#' function for the ConnectorDatabricksTable class.
#'
#' @rdname log_remove_connector
#'
#' @export
log_remove_connector.ConnectorDatabricksTable <- function(
  connector_object,
  name,
  ...
) {
  msg <- log_connector_message(connector_object, name, ...)
  whirl::log_delete(msg)
}

#' Log Read Operation for Databricks Volume connector
#'
#' @description
#' * [ConnectorDatabricksVolume]: Implementation of the `log_read_connector`
#' function for the ConnectorDatabricksVolume class.
#'
#' @rdname log_read_connector
#'
#' @export
log_read_connector.ConnectorDatabricksVolume <- function(
  connector_object,
  name,
  ...
) {
  rlang::check_installed("whirl")
  msg <- paste0(name, " @ ", connector_object$full_path)
  whirl::log_read(msg)
}

#' Log Write Operation for Databricks Volume connector
#'
#' @description
#' * [ConnectorDatabricksVolume]: Implementation of the `log_write_connector`
#' function for the ConnectorDatabricksVolume class.
#'
#' @rdname log_write_connector
#'
#' @export
log_write_connector.ConnectorDatabricksVolume <- function(
  connector_object,
  name,
  ...
) {
  rlang::check_installed("whirl")
  msg <- paste0(name, " @ ", connector_object$full_path)
  whirl::log_write(msg)
}

#' Log Remove Operation for Databricks Volume connector
#'
#' @description
#' * [ConnectorDatabricksVolume]: Implementation of the `log_remove_connector`
#' function for the ConnectorDatabricksVolume class.
#'
#' @rdname log_remove_connector
#'
#' @export
log_remove_connector.ConnectorDatabricksVolume <- function(
  connector_object,
  name,
  ...
) {
  rlang::check_installed("whirl")
  msg <- paste0(name, " @ ", connector_object$full_path)
  whirl::log_delete(msg)
}


#' Log connector message
#'
#' Generate connector object log message with all the information
#' about the object.
#' @noRd
#' @keywords internal
log_connector_message <- function(connector_object, name) {
  rlang::check_installed("whirl")
  msg <- paste0(
    name,
    " @ ",
    "dbname: ",
    connector_object$conn@info$dbname,
    ", dbms.name: ",
    connector_object$conn@info$dbms.name,
    ", db.version: ",
    connector_object$conn@info$db.version,
    ", drivername: ",
    connector_object$conn@info$drivername,
    ", driver.version: ",
    connector_object$conn@info$driver.version,
    ", odbcdriver.version: ",
    connector_object$conn@info$odbcdriver.version,
    ", catalog:",
    connector_object$catalog,
    ", schema:",
    connector_object$schema
  )
}
