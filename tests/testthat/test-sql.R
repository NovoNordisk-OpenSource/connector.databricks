skip_offline_test()

test_that("Table generics work for connector_databricks_sql", {
  skip_on_cran()
  temp_table_name <- paste0(
    "temp-mtcars_",
    format(Sys.time(), "%Y%m%d%H%M%S")
  )

  expect_error(connector_databricks_sql(warehouse_id = 1))

  # initialized with appropriate values for catalog, schema, and conn
  cnt <- connector_databricks_sql(
    warehouse_id = setup_db_warehouse_id,
    catalog = setup_db_catalog,
    schema = setup_db_schema
  )

  cnt |>
    expect_no_error()

  checkmate::assert_r6(
    cnt,
    classes = c("ConnectorDatabricksSQL"),
    private = c(".catalog", ".schema")
  )

  cnt$write_cnt(
    x = mtcars_dataset(),
    name = temp_table_name
  ) |>
    expect_equal(cnt) |>
    expect_success()

  cnt$list_content_cnt() |>
    expect_contains(temp_table_name)

  cnt$read_cnt(temp_table_name) |>
    expect_equal(mtcars_dataset(), ignore_attr = c("class"))

  cnt$tbl_cnt(temp_table_name) |>
    dplyr::filter(car == "Mazda RX4") |>
    dplyr::select(car, mpg) |>
    dplyr::collect() |>
    expect_equal(dplyr::tibble(car = "Mazda RX4", mpg = 21))

  cnt$write_cnt(mtcars_dataset(), temp_table_name, overwrite = TRUE) |>
    expect_equal(cnt) |>
    expect_success()

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
    expect_equal(mtcars_dataset(), ignore_attr = c("class"))

  cnt$remove_cnt(temp_table_name) |>
    expect_no_error() |>
    expect_equal(cnt)

  cnt$disconnect_cnt() |>
    expect_no_condition()
})

skip_offline_test()

test_that("Table generics work for connector_databricks_sql with staging", {
  skip_on_cran()
  temp_table_name <- paste0(
    "temp-mtcars_",
    format(Sys.time(), "%Y%m%d%H%M%S")
  )

  expect_error(connector_databricks_sql(warehouse_id = 1))

  # initialized with appropriate values for catalog, schema, and conn
  cnt <- connector_databricks_sql(
    warehouse_id = setup_db_warehouse_id,
    catalog = setup_db_catalog,
    schema = setup_db_schema,
    staging_volume = setup_databricks_volume
  )

  cnt |>
    expect_no_error()

  checkmate::assert_r6(
    cnt,
    classes = c("ConnectorDatabricksSQL"),
    private = c(".catalog", ".schema")
  )

  cnt$write_cnt(
    x = mtcars_dataset(),
    name = temp_table_name
  ) |>
    expect_equal(cnt) |>
    expect_success()

  cnt$list_content_cnt() |>
    expect_contains(temp_table_name)

  cnt$read_cnt(temp_table_name) |>
    expect_equal(mtcars_dataset(), ignore_attr = c("class"))

  cnt$tbl_cnt(temp_table_name) |>
    dplyr::filter(car == "Mazda RX4") |>
    dplyr::select(car, mpg) |>
    dplyr::collect() |>
    expect_equal(dplyr::tibble(car = "Mazda RX4", mpg = 21))

  cnt$write_cnt(mtcars_dataset(), temp_table_name, overwrite = TRUE) |>
    expect_equal(cnt) |>
    expect_success()

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
    expect_equal(mtcars_dataset(), ignore_attr = c("class"))

  cnt$remove_cnt(temp_table_name) |>
    expect_no_error() |>
    expect_equal(cnt)

  cnt$disconnect_cnt() |>
    expect_no_condition()
})
