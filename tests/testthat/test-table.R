test_that("connector_databricks_table passes ... to the odbc driver", {
  args <- capture_dbconnect_args(
    http_path = "path-to-cluster",
    catalog = "my_catalog",
    schema = "my_schema",
    workspace = "https://my-workspace.cloud.databricks.com",
    uid = "token"
  )

  expect_s4_class(args$drv, "DatabricksOdbcDriver")
  expect_equal(args$httpPath, "path-to-cluster")
  expect_equal(args$workspace, "https://my-workspace.cloud.databricks.com")
  expect_equal(args$uid, "token")
  expect_false(args$useNativeQuery)
  expect_null(args$extra_class)
})

test_that("connector_databricks_table allows overriding useNativeQuery", {
  args <- capture_dbconnect_args(
    http_path = "path-to-cluster",
    catalog = "my_catalog",
    schema = "my_schema",
    useNativeQuery = TRUE
  )

  expect_true(args$useNativeQuery)
  expect_length(args[names(args) == "useNativeQuery"], 1)
})

test_that("Table generics work for connector_databricks_table", {
  skip_offline_test()
  skip_on_cran()
  temp_table_name <- paste0(
    "temp-mtcars_",
    format(Sys.time(), "%Y%m%d%H%M%S")
  )

  expect_error(connector_databricks_table(http_path = 1))

  # initialized with appropriate values for catalog, schema, and conn
  cnt <- connector_databricks_table(
    http_path = setup_db_http_path,
    catalog = setup_db_catalog,
    schema = setup_db_schema
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
    expect_equal(cnt) |>
    expect_success()

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
    expect_equal(mtcars_dataset())

  cnt$remove_cnt(temp_table_name) |>
    expect_no_error()

  cnt$disconnect_cnt() |>
    expect_no_condition()
})
