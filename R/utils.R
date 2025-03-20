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
      cluster_id = id_of_cluster
    )
  }

  if (overwrite == FALSE) {
    # Create table
    execute_sql_query(
      glue::glue(
        "CREATE TABLE {catalog}.{schema}.`{name}`
      AS SELECT * FROM parquet.`{tmp_volume$full_path}/{name}.parquet`"
      ),
      cluster_id = id_of_cluster
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
    cluster_id = id_of_cluster
  )
}

#' Execute and check SQL query
#'
#' @param query SQL query to be run
#' @param cluster_id SQL Warehouse ID.
#' Get one here: https://docs.databricks.com/api/workspace/warehouses/get
#' @keywords internal
#' @noRd
execute_sql_query <- function(query_string, cluster_id) {
  result <- brickster::db_sql_exec_query(
    query_string,
    cluster_id
  )

  if (result$status$state == "FAILED") {
    cli::cli_abort(paste0(
      "Execution failed with error: ",
      result$status$error$message
    ))
  }
}


#' Write data to a table using Databricks Volume
#'
#' This function first writes parquet file to a temporary Databricks Volume and then
#' converts it to a table.
#'
#' @param connector_object A [ConnectorDatabricksTable] object for interacting with Databricks
#' @param x The data to be written to the table
#' @param name The name of the table
#' @param overwrite Logical indicating whether to overwrite the table if it already exists
#' @param tags Named list containing tag names and tag values, e.g.
#' list("tag_name1" = "tag_value1", "tag_name2" = "tag_value2").
#' More info [here](https://docs.databricks.com/aws/en/database-objects/tags)
#' @return None
#' @export
#' @examples
#' \dontrun{
#' write_table_volume(connector_object, data, "my_table", overwrite = TRUE, tags = list("tag_name1" = "tag_value1"))
#' }
write_table_volume <- function(
  connector_object,
  x,
  name,
  overwrite = TRUE,
  tags = NULL
) {
  checkmate::assert_r6(
    x = connector_object,
    classes = "ConnectorDatabricksTable",
    null.ok = FALSE
  )
  checkmate::assert_character(x = name, null.ok = FALSE)
  checkmate::assert_logical(x = overwrite, null.ok = FALSE)
  checkmate::assert_list(tags, null.ok = TRUE)

  volume_name <- tmp_volume_name()
  temporary_volume <- tryCatch(
    {
      tmp_volume(connector_object, volume_name)
    },
    error = function(e) {
      zephyr::msg_danger(paste0(
        "Temporary volume creation failed. Error message:",
        e
      ))
    }
  )

  zephyr::msg_info("Writing to a table...")

  temporary_volume$write_cnt(
    x = x,
    name = paste0(name, ".parquet")
  )

  parquet_to_table(
    connector_object = connector_object,
    tmp_volume = temporary_volume,
    name = name,
    overwrite = overwrite
  )

  if (!is.null(tags)) {
    add_table_tags(
      connector_object = connector_object,
      tags = tags,
      name = name
    )
  }
  zephyr::msg_success("Table written successfully!")

  withr::defer(
    delete_databricks_volume(
      catalog_name = temporary_volume$catalog,
      schema_name = temporary_volume$schema,
      name = volume_name
    )
  )
  zephyr::msg_info("Temporary volume deleted.")
}
