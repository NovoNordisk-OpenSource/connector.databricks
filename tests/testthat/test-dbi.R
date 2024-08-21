# Create a temporary dataset for testing
create_temp_dataset <- function() {
  # Sample data
  x <- mtcars
  x$car <- rownames(x)
  rownames(x) <- NULL
  return(x)
}

test_that(paste("DBI generics work for connector_databricks_dbi"), {

  if (!is.null(Sys.getenv("http_path_local")) &
      !is.null(Sys.getenv("catalog_local")) &
      !is.null(Sys.getenv("schema_local"))) {

    skip_on_ci()
    skip_on_cran()

    # Retrieve the stored values
    http_path_local <- Sys.getenv("http_path_local")
    catalog_local <- Sys.getenv("catalog_local")
    schema_local <- Sys.getenv("schema_local")

    temp_table_name <- paste0("temp_mtcars_", format(Sys.time(), "%Y%m%d%H%M%S"))

    expect_error(connector_databricks_dbi$new(http_path = 1))

    # initialized with appropriate values for catalog, schema, and conn
    cnt <- connector_databricks_dbi$new(
      http_path = http_path_local,
      catalog = catalog_local,
      schema = schema_local)

    cnt |>
      expect_no_error()

    checkmate::assert_r6(
      cnt,
      classes = c("connector_databricks_dbi"),
      private = c(".catalog", ".schema")
    )

    cnt$cnt_write(create_temp_dataset(), temp_table_name) |>
      expect_no_condition()

    cnt$cnt_list_content() |>
      expect_contains(temp_table_name)

    cnt$cnt_write(create_temp_dataset(), temp_table_name) |>
      expect_error()

    cnt$cnt_read(temp_table_name) |>
      expect_equal(create_temp_dataset())

    cnt$cnt_write(create_temp_dataset(), temp_table_name, overwrite = TRUE) |>
      expect_no_condition()

    cnt$cnt_tbl(temp_table_name) |>
      dplyr::filter(car == "Mazda RX4") |>
      dplyr::select(car, mpg) |>
      dplyr::collect() |>
      expect_equal(dplyr::tibble(car = "Mazda RX4", mpg = 21))

    # cnt$conn |>
    #   DBI::dbGetQuery("SELECT * FROM temp_table_name") |>
    #   expect_equal(create_temp_dataset())

    cnt$cnt_remove(temp_table_name) |>
      expect_no_condition()

    cnt$cnt_disconnect() |>
      expect_no_condition()

    tryCatch(
      cnt$cnt_read(temp_table_name),
      error = function(e) {
        return("Error occurred")
      }
    ) |>
      expect_equal("Error occurred")
  } else {
    skip("Skipping test as http_path_local, catalog_local, or schema_local is NULL")
  }
})
