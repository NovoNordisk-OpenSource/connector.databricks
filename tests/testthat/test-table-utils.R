# Skip interactive tests on CI and CRAN
skip_on_ci()
skip_on_cran()

test_that("write_table_volume fails when needed", {
  temp_table_name <- paste0(
    "temp-mtcars_",
    format(Sys.time(), "%Y%m%d%H%M%S")
  )

  ## Write table using volume fails when needed
  write_table_volume(connector_object = "bad_volume") |>
    expect_error(regexp = "Assertion on 'connector_object' failed")

  write_table_volume(
    connector_object = setup_table_connector,
    x = iris,
    name = 1
  ) |>
    expect_error(
      regexp = "Assertion on 'name' failed: Must be of type 'character'"
    )

  write_table_volume(
    connector_object = setup_table_connector,
    x = iris,
    name = "iris",
    overwrite = 1
  ) |>
    expect_error(
      regexp = "Assertion on 'overwrite' failed: Must be of type 'logical'"
    )

  write_table_volume(
    connector_object = setup_table_connector,
    x = iris,
    name = "iris",
    overwrite = TRUE,
    tags = 1
  ) |>
    expect_error(
      regexp = "Assertion on 'tags' failed: Must be of type 'list'"
    )
})

test_that("list_content_tags fails when needed", {
  ## List tables using tags fails when needed
  list_content_tags(connector_object = "bad_connector") |>
    expect_error(regexp = "Assertion on 'connector_object' failed")

  list_content_tags(connector_object = setup_table_connector, tags = 1) |>
    expect_error(
      regexp = "Assertion on 'tags' failed: Must be of type 'character'"
    )
})

test_that("write_table_volume works", {
  table_name <- temp_table_name()

  # Custom tag to search for
  tag_value <- generate_random_string("value_")

  # Write a table using volume
  write_table_volume(
    connector_object = setup_table_connector,
    x = create_temp_dataset(),
    name = table_name,
    overwrite = FALSE,
    tags = list("test_tag" = tag_value)
  ) |>
    expect_no_failure()

  setup_table_connector |>
    list_content_tags(tags = glue::glue("tag_value = '{tag_value}'")) |>
    expect_contains(table_name)

  setup_table_connector$read_cnt(table_name) |>
    expect_equal(create_temp_dataset())

  setup_table_connector$tbl_cnt(table_name) |>
    dplyr::filter(car == "Mazda RX4") |>
    dplyr::select(car, mpg) |>
    dplyr::collect() |>
    expect_equal(dplyr::tibble(car = "Mazda RX4", mpg = 21))

  write_table_volume(
    connector_object = setup_table_connector,
    x = create_temp_dataset(),
    name = table_name,
    overwrite = TRUE
  ) |>
    expect_no_failure()

  setup_table_connector$conn |>
    DBI::dbGetQuery(paste(
      "SELECT * FROM ",
      custom_paste_with_back_quotes(
        setup_table_connector$catalog,
        setup_table_connector$schema,
        table_name,
        sep = "."
      )
    )) |>
    expect_equal(create_temp_dataset())

  setup_table_connector$remove_cnt(table_name) |>
    expect_no_condition()
})

test_that("list_content_tags works", {
  table_name <- temp_table_name()

  # Custom tag to search for
  tag_value <- generate_random_string("value_")

  # Write a table using volume
  write_table_volume(
    connector_object = setup_table_connector,
    x = create_temp_dataset(),
    name = table_name,
    overwrite = TRUE,
    tags = list("test_tag" = tag_value)
  ) |>
    expect_no_failure()

  # Check if the table can be found based on tags
  tables <- setup_table_connector |>
    list_content_tags(tags = glue::glue("tag_value = '{tag_value}'")) |>
    expect_no_failure()

  setup_table_connector |>
    list_content_tags(tags = glue::glue("tag_value = '{tag_value}'")) |>
    expect_contains(table_name)

  # Remove table
  setup_table_connector |> remove_cnt(name = table_name)
})
