test_that("write_table_volume works", {
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

    # initialized with appropriate values for catalog, schema, and conn
    cnt <- connector_databricks_table(
      http_path = http_path_local,
      catalog = catalog_local,
      schema = schema_local
    )

    write_table_volume(
      connector_object = cnt,
      x = create_temp_dataset(),
      name = temp_table_name,
      overwrite = FALSE,
      tags = list("tag1" = "test1", "tag2" = "test2")
    ) |>
      expect_no_failure()

    Sys.sleep(3)

    cnt$list_content_cnt() |>
      expect_contains(temp_table_name)

    cnt$read_cnt(temp_table_name) |>
      expect_equal(create_temp_dataset())

    cnt$tbl_cnt(temp_table_name) |>
      dplyr::filter(car == "Mazda RX4") |>
      dplyr::select(car, mpg) |>
      dplyr::collect() |>
      expect_equal(dplyr::tibble(car = "Mazda RX4", mpg = 21))

    write_table_volume(
      connector_object = cnt,
      x = create_temp_dataset(),
      name = temp_table_name,
      overwrite = TRUE
    ) |>
      expect_no_failure()

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
      expect_equal(create_temp_dataset())

    cnt$remove_cnt(temp_table_name) |>
      expect_no_condition()
  } else {
    skip(
      "Skipping test as http_path_local, catalog_local, or schema_local is NULL"
    )
  }
})
