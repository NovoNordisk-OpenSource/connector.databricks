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
tmp_volume <- function(connector_object) {
  tmp_volume_name <- tmp_volume_name()
  catalog <- connector_object$catalog
  schema <- connector_object$schema

  tmp_volume <- connector_databricks_volume(
    catalog = catalog,
    schema = schema,
    path = tmp_volume_name,
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
parquet_to_table <- function(connector_object, tmp_volume, name) {
  id_of_cluster <- brickster::db_sql_warehouse_list()[[1]]$id

  catalog <- connector_object$catalog
  schema <- connector_object$schema

  # Create table
  query_create <- glue::glue(
    "CREATE TABLE IF NOT EXISTS {catalog}.{schema}.{name} USING DELTA;"
  )
  brickster::db_sql_exec_query(
    query_create,
    id_of_cluster
  )

  # Copy parquet file into table
  query_copy <- glue::glue(
    "COPY INTO {catalog}.{schema}.{name} FROM '{tmp_volume$full_path}/{name}.parquet' FILEFORMAT = PARQUET  FORMAT_OPTIONS ('header' = 'true') COPY_OPTIONS ('mergeSchema' = 'true', 'force' = 'true');",
  )
  test <- brickster::db_sql_exec_query(
    query_copy,
    id_of_cluster
  )
}
