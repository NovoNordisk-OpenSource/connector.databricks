test_that("write_table_volume fails when needed", {
  write_table_volume(connector_object = "bad_volume") |>
    expect_error(regexp = "Assertion on 'connector_object' failed")

  write_table_volume(
    connector_object = dummy_table_connector,
    x = iris,
    name = 1
  ) |>
    expect_error(
      regexp = "Assertion on 'name' failed: Must be of type 'character'"
    )

  write_table_volume(
    connector_object = dummy_table_connector,
    x = iris,
    name = "iris",
    overwrite = 1
  ) |>
    expect_error(
      regexp = "Assertion on 'overwrite' failed: Must be of type 'logical'"
    )

  write_table_volume(
    connector_object = dummy_table_connector,
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
  list_content_tags(connector_object = "bad_connector") |>
    expect_error(regexp = "Assertion on 'connector_object' failed")

  list_content_tags(connector_object = dummy_table_connector, tags = 1) |>
    expect_error(
      regexp = "Assertion on 'tags' failed: Must be of type 'character'"
    )
})

test_that("read_table_timepoint fails when needed", {
  read_table_timepoint(connector_object = "bad_volume") |>
    expect_error(regexp = "Assertion on 'connector_object' failed")

  read_table_timepoint(
    connector_object = dummy_table_connector,
    name = 1
  ) |>
    expect_error(
      regexp = "Assertion on 'name' failed: Must be of type 'character'"
    )

  read_table_timepoint(
    connector_object = dummy_table_connector,
    name = "iris",
    timepoint = "2019-01-01T00:00:00.000Z",
    version = "bad_version"
  ) |>
    expect_error(
      regexp = "Assertion on 'version' failed: Must be of type 'numeric'"
    )
})

skip_offline_test()

test_that("write_table_volume works", {
  table_name <- temp_table_name()

  # Custom tag to search for
  tag_value <- generate_random_string("value_")

  # Write a table using volume
  write_table_volume(
    connector_object = setup_table_connector,
    x = mtcars_dataset(),
    name = table_name,
    overwrite = FALSE,
    tags = list("test_tag" = tag_value)
  ) |>
    expect_no_failure()

  setup_table_connector |>
    list_content_tags(tags = glue::glue("tag_value = '{tag_value}'")) |>
    expect_contains(table_name)

  setup_table_connector$read_cnt(table_name) |>
    expect_equal(mtcars_dataset())

  setup_table_connector$tbl_cnt(table_name) |>
    dplyr::filter(car == "Mazda RX4") |>
    dplyr::select(car, mpg) |>
    dplyr::collect() |>
    expect_equal(dplyr::tibble(car = "Mazda RX4", mpg = 21))

  write_table_volume(
    connector_object = setup_table_connector,
    x = mtcars_dataset(),
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
    expect_equal(mtcars_dataset())

  setup_table_connector$remove_cnt(table_name) |>
    expect_no_error()
})

test_that("list_content_tags works", {
  table_name <- temp_table_name()

  # Custom tag to search for
  tag_value <- generate_random_string("value_")

  # Write a table using volume
  write_table_volume(
    connector_object = setup_table_connector,
    x = mtcars_dataset(),
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

test_that("read_table_timepoint works", {
  table_name <- temp_table_name()

  # First timepoint test - mtcars

  data1 <- create_temp_dataset()
  write_table_volume(
    connector_object = setup_table_connector,
    x = data1,
    name = table_name,
    overwrite = TRUE
  )

  read_data <- read_table_timepoint(
    connector_object = setup_table_connector,
    name = table_name
  )
  timepoint1 <- Sys.time()

  expect_equal(data1, read_data)

  # Second timepoint test
  data2 <- create_temp_dataset()
  write_table_volume(
    connector_object = setup_table_connector,
    x = data2,
    name = table_name,
    overwrite = TRUE
  )

  read_data <- read_table_timepoint(
    connector_object = setup_table_connector,
    name = table_name
  )

  expect_equal(data2, read_data)

  # Check timepoint
  read_data <- read_table_timepoint(
    connector_object = setup_table_connector,
    name = table_name,
    timepoint = .POSIXct(timepoint1, "UTC")
  )

  expect_equal(data1, read_data)

  # Check versions
  read_data <- read_table_timepoint(
    connector_object = setup_table_connector,
    name = table_name,
    version = 0
  )

  expect_equal(data1, read_data)

  read_data <- read_table_timepoint(
    connector_object = setup_table_connector,
    name = table_name,
    version = 1
  )

  expect_equal(data2, read_data)
})

test_that("read and write empty table works", {
  empty_table <- data.frame(
    Date = as.Date(character()),
    File = character(),
    User = character(),
    stringsAsFactors = FALSE
  )

  expect_no_failure(write_table_volume(
    connector_object = setup_table_connector,
    empty_table,
    "empty_table",
    overwrite = TRUE
  ))

  expect_no_failure(
    empty_result <- read_table_timepoint(
      connector_object = setup_table_connector,
      name = "empty_table"
    )
  )

  expect_equal(empty_table, empty_result)
})

test_that("tmp volume removal works", {
  # Bad data input to break the test
  x <- list("1", "2", "3")

  expect_error(write_table_volume(
    connector_object = setup_table_connector,
    x,
    "empty_table",
    overwrite = TRUE
  ))

  list_of_volumes <- brickster::db_uc_volumes_list(
    catalog = setup_db_catalog,
    schema = setup_db_schema
  )

  expect_no_error(
    for (volume in list_of_volumes) {
      if (startsWith(volume[["name"]], "tmp_")) {
        stop("tmp volume exists")
      }
    }
  )
})
