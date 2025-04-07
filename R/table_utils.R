#' Write data to a table using Databricks Volume
#'
#' This function first writes parquet file to a temporary Databricks Volume and then
#' converts it to a table.
#'
#' @param connector_object A [ConnectorDatabricksTable] object for interacting with Databricks
#' @param x The data to be written to the table
#' @param name The name of the table
#' @param overwrite Boolean indicating whether to overwrite the table if it already exists
#' @param tags Named list containing tag names and tag values, e.g.
#' list("tag_name1" = "tag_value1", "tag_name2" = "tag_value2").
#' More info [here](https://docs.databricks.com/aws/en/database-objects/tags)
#' @return None
#' @export
#' @examples
#' \dontrun{
#'  write_table_volume(connector_object,
#'     data,
#'     "my_table",
#'     overwrite = TRUE,
#'     tags = list("tag_name1" = "tag_value1")
#'  )
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

#' List Databricks tables in a catalog based on tag values
#'
#' This function is used to list tables in a Databricks catalog based on a tag.
#'
#' @param connector_object [ConnectorDatabricksTable] object for interacting
#' with Databricks
#' @param tags String containing tag names and tag values in SQL query format,
#' e.g. `(tag_name1 = 'tag_value1' OR tag_name2 = 'tag_value2')`.
#' More info [here](https://docs.databricks.com/aws/en/database-objects/tags)
#' @return None
#' @export
#' @examples
#' \dontrun{
#' connector_object |>
#'     list_content_tags(tags = ("tag_value = 'value1'")))
#' }
list_content_tags <- function(
  connector_object,
  tags
) {
  checkmate::assert_r6(
    x = connector_object,
    classes = "ConnectorDatabricksTable",
    null.ok = FALSE
  )
  checkmate::assert_character(tags, null.ok = FALSE)

  id_of_cluster <- brickster::db_sql_warehouse_list()[[1]]$id

  results <- execute_sql_query(
    glue::glue(
      "SELECT DISTINCT table_name
       FROM system.information_schema.table_tags
       WHERE
          catalog_name = '{connector_object$catalog}'
          AND schema_name = '{connector_object$schema}'
          AND {tags}
      "
    ),
    cluster_id = id_of_cluster
  )

  unique(unlist(results$result$data_array))
}
