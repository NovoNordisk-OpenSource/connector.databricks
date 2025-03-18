#' Create temporary volume name
#'
#' @param prefix Prefix to use for newly created volume. Default: `tmp_`
#' @param length Character length to be used for random characters. Default: `10`
#' @keywords internal
#' @noRd
tmp_volume_name <- function(prefix = "tmp_", length = 10) {
  random_string <- paste0(
    sample(c(letters, 0:9), length, replace = TRUE),
    collapse = ""
  )
  result <- paste0(prefix, random_string)
  return(result)
}

#' Create temporary volume
#'
#' @param connector_object Connector object
#' @keywords internal
#' @noRd
tmp_volume <- function(connector_object, volume_name, envir = parent.frame()) {
  catalog <- connector_object$catalog
  schema <- connector_object$schema

  tmp_volume <- connector_databricks_volume(
    catalog = catalog,
    schema = schema,
    path = volume_name,
    force = TRUE
  )
}

#' Convert volume parquet file to table
#'
#' @param connector_object Connector object
#' @param tmp_volume Temporary Volume
#' @param name Table name
#' @keywords internal
#' @noRd
parquet_to_table <- function(
    connector_object,
    tmp_volume,
    name,
    overwrite = TRUE) {
  catalog <- connector_object$catalog
  schema <- connector_object$schema

  if (overwrite == TRUE) {
    execute_sql_query(glue::glue(
      "CREATE OR REPLACE TABLE {catalog}.{schema}.`{name}`
      AS SELECT * FROM parquet.`{tmp_volume$full_path}/{name}.parquet`"
    ))
  }

  if (overwrite == FALSE) {
    # Create table
    execute_sql_query(glue::glue(
      "CREATE TABLE {catalog}.{schema}.`{name}`
      AS SELECT * FROM parquet.`{tmp_volume$full_path}/{name}.parquet`"
    ))
  }
}

#' Execute and check SQL query
#'
#' @param query SQL query to be run
#' @keywords internal
#' @noRd
execute_sql_query <- function(query_string) {
  id_of_cluster <- brickster::db_sql_warehouse_list()[[1]]$id

  result <- brickster::db_sql_exec_query(
    query_string,
    id_of_cluster
  )

  if (result$status$state == "FAILED") {
    cli::cli_abort(paste0(
      "Execution failed with error: ",
      result$status$error$message
    ))
  }
}
