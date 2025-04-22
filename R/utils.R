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

  connector_databricks_volume(
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
  overwrite = TRUE
) {
  catalog <- connector_object$catalog
  schema <- connector_object$schema

  id_of_cluster <- brickster::db_sql_warehouse_list()[[1]]$id

  if (overwrite == TRUE) {
    execute_sql_query(
      glue::glue(
        "CREATE OR REPLACE TABLE {catalog}.{schema}.`{name}`
      AS SELECT * FROM parquet.`{tmp_volume$full_path}/{name}.parquet`"
      ),
      warehouse_id = id_of_cluster
    )
  }

  if (overwrite == FALSE) {
    execute_sql_query(
      glue::glue(
        "CREATE TABLE {catalog}.{schema}.`{name}`
      AS SELECT * FROM parquet.`{tmp_volume$full_path}/{name}.parquet`"
      ),
      warehouse_id = id_of_cluster
    )
  }
}

#' Add tags to Databricks table
#'
#' @param connector_object Connector object
#' @param tags Tags to add to the table
#' @param name Table name
#' @keywords internal
#' @noRd
add_table_tags <- function(
  connector_object,
  tags,
  name
) {
  catalog <- connector_object$catalog
  schema <- connector_object$schema

  id_of_cluster <- brickster::db_sql_warehouse_list()[[1]]$id

  tags_glued <- paste0(
    "'",
    names(tags),
    "'='",
    unlist(tags),
    "'",
    collapse = ","
  )

  # Create table
  execute_sql_query(
    glue::glue(
      "ALTER TABLE {catalog}.{schema}.`{name}` SET TAGS ({tags_glued})"
    ),
    warehouse_id = id_of_cluster
  )
}

#' Execute and check SQL query
#'
#' @param query_string SQL query to be run
#' @param warehouse_id SQL Warehouse ID.
#' Get one here: https://docs.databricks.com/api/workspace/warehouses/get
#' @keywords internal
#' @noRd
execute_sql_query <- function(query_string, warehouse_id, ...) {
  result <- brickster::db_sql_exec_query(
    statement = query_string,
    warehouse_id = warehouse_id,
    ...
  )

  if (result$status$state == "FAILED") {
    cli::cli_abort(paste0(
      "Execution failed with error: ",
      result$status$error$message
    ))
  }

  time_ <- Sys.time()
  while (result$status$state != "SUCCEEDED" || time_ < 120) {
    try(
      {
        result <- brickster::db_sql_exec_status(result$statement_id)
        time_ <- Sys.time() - time_
      },
      silent = TRUE
    )
  }

  result
}
