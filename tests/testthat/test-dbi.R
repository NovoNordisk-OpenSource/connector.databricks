test_that("connector_databricks_dbi", {

  skip_on_ci()
  skip_on_cran()

  # TODO: Is there a way to mask this information, or make it available in the CI?

  con_databricks <- connector_databricks_dbi$new(
    http_path = "sql/protocolv1/o/273240340063409/0216-121054-v8tdvp00",
    catalog = "amace_cdr_bronze_dev",
    schema = "my_adam"
  ) |>
    expect_no_condition()

  # Note: Below is almost the same code as in the example to make sure it runs

  # List tables in my_schema

  con_databricks$list_content() |>
    expect_type("character")

  # Read and write tables

  cars <- mtcars
  cars$name <- rownames(cars)
  rownames(cars) <- NULL

  con_databricks$write(cars, "my_mtcars_table", overwrite = TRUE) |>
    expect_no_condition()

  con_databricks$read("my_mtcars_table") |>
    expect_s3_class("data.frame") |>
    expect_equal(cars)

  # Use dplyr::tbl

  cars_tbl <- con_databricks$tbl("my_mtcars_table")
  expect_true(dplyr::is.tbl(cars_tbl))
  cars_tbl |>
    dplyr::collect() |>
    expect_no_condition() |>
    as.data.frame() |>
    expect_equal(cars)

  # Remove table

  con_databricks$remove("my_mtcars_table") |>
    expect_no_condition()

  # Disconnect

  con_databricks$disconnect() |>
    expect_no_condition()
})
