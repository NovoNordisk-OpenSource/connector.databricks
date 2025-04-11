test_that("Table generics work for connector_databricks_table", {
  if (
    all(
      c(
        "DATABRICKS_HTTP_PATH",
        "DATABRICKS_CATALOG_NAME",
        "DATABRICKS_SCHEMA_NAME"
      ) %in%
        names(Sys.getenv())
    )
  ) {
    skip_on_ci()
    skip_on_cran()

    # Retrieve the stored values
    http_path_local <- Sys.getenv("DATABRICKS_HTTP_PATH")
    catalog_local <- Sys.getenv("DATABRICKS_CATALOG_NAME")
    schema_local <- Sys.getenv("DATABRICKS_SCHEMA_NAME")

    temp_table_name <- paste0(
      "temp-mtcars_",
      format(Sys.time(), "%Y%m%d%H%M%S")
    )

    expect_error(connector_databricks_table(http_path = 1))

    # initialized with appropriate values for catalog, schema, and conn
    cnt <- connector_databricks_table(
      http_path = http_path_local,
      catalog = catalog_local,
      schema = schema_local
    )

    cnt |>
      expect_no_error()

    checkmate::assert_r6(
      cnt,
      classes = c("ConnectorDatabricksTable"),
      private = c(".catalog", ".schema")
    )

    # Custom tag to search for
    tag_value <- generate_random_string("value_")

    cnt$write_cnt(
      x = mtcars_dataset(),
      name = temp_table_name,
      method = "volume",
      tags = list("tag_name" = tag_value)
    ) |>
      expect_no_failure()

    cnt$list_content_cnt(tags = tag_name == tag_value) |>
      expect_contains(temp_table_name)

    cnt$read_cnt(temp_table_name) |>
      expect_equal(mtcars_dataset())

    cnt$tbl_cnt(temp_table_name) |>
      dplyr::filter(car == "Mazda RX4") |>
      dplyr::select(car, mpg) |>
      dplyr::collect() |>
      expect_equal(dplyr::tibble(car = "Mazda RX4", mpg = 21))

    cnt$write_cnt(mtcars_dataset(), temp_table_name, overwrite = TRUE) |>
      expect_no_failure()

    cnt$list_content_cnt() |>
      expect_contains(temp_table_name)

    cnt$conn |>
      DBI::dbGetQuery(paste(
        "SELECT * FROM ",
        custom_paste_with_back_quotes(
          cnt$catalog,
          cnt$schema,
          temp_table_name,
          sep = "."
        )
      )) |>
      expect_equal(mtcars_dataset())

    cnt$remove_cnt(temp_table_name) |>
      expect_no_condition()

    cnt$disconnect_cnt() |>
      expect_no_condition()

    tryCatch(
      cnt$read_cnt(temp_table_name),
      error = function(e) {
        "Error occurred"
      }
    ) |>
      expect_equal("Error occurred")
  } else {
    skip(
      "Skipping test as http_path_local, catalog_local, or schema_local is NULL"
    )
  }
})
