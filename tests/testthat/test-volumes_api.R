test_that("create_databricks_volume and delete_databricks_volume works", {
  skip_on_cran()
  skip_on_ci()

  # Create volume
  create_databricks_volume(
    name = "test_volume",
    catalog_name = Sys.getenv("DATABRICKS_CATALOG_NAME"),
    schema_name = Sys.getenv("DATABRICKS_SCHEMA_NAME")
  )

  volumes <- list_databricks_volumes(
    catalog_name = Sys.getenv("DATABRICKS_CATALOG_NAME"),
    schema_name = Sys.getenv("DATABRICKS_SCHEMA_NAME")
  )

  # Check if volume exists
  testthat::expect_true("test_volume" %in% volumes$name)

  delete_databricks_volume(
    name = "test_volume",
    catalog_name = Sys.getenv("DATABRICKS_CATALOG_NAME"),
    schema_name = Sys.getenv("DATABRICKS_SCHEMA_NAME")
  )

  volumes <- list_databricks_volumes(
    catalog_name = Sys.getenv("DATABRICKS_CATALOG_NAME"),
    schema_name = Sys.getenv("DATABRICKS_SCHEMA_NAME")
  )

  # Check if volume exists
  testthat::expect_false("test_volume" %in% volumes$name)
})



test_that("create_databricks_volume fails with invalid inputs", {
  # Invalid client
  testthat::expect_error(create_databricks_volume(client = "invalid_client"))

  # Invalid name
  testthat::expect_error(create_databricks_volume(client = setup_db_client, name = 1))

  # Invalid catalog_name
  testthat::expect_error(create_databricks_volume(client = setup_db_client, name = "name", catalog_name = 1))

  # Invalid schema_name
  testthat::expect_error(
    create_databricks_volume(
      client = setup_db_client,
      name = "name",
      catalog_name = "catalog_name",
      schema_name = 1
    )
  )
})

test_that("list_databricks_volumes works", {
  skip_on_cran()
  skip_on_ci()

  volumes <- list_databricks_volumes(
    catalog_name = Sys.getenv("DATABRICKS_CATALOG_NAME"),
    schema_name = Sys.getenv("DATABRICKS_SCHEMA_NAME")
  )

  testthat::expect_true(is.list(volumes))
})

test_that("list_databricks_volumes fails with invalid inputs", {
  # Invalid client
  testthat::expect_error(list_databricks_volumes(client = "invalid_client"))

  # Invalid catalog_name
  testthat::expect_error(list_databricks_volumes(client = setup_db_client, catalog_name = 1))

  # Invalid schema_name
  testthat::expect_error(
    list_databricks_volumes(
      client = setup_db_client,
      catalog_name = "catalog_name",
      schema_name = 1
    )
  )

  # Invalid max_results
  testthat::expect_error(
    list_databricks_volumes(
      client = setup_db_client,
      catalog_name = "catalog_name",
      schema_name = "schema_name",
      max_results = "invalid_max_results"
    )
  )

  # Invalid page_token
  testthat::expect_error(
    list_databricks_volumes(
      client = setup_db_client,
      catalog_name = "catalog_name",
      schema_name = "schema_name",
      max_results = 100,
      page_token = 1
    )
  )

  # Invalid include_browse
  testthat::expect_error(
    list_databricks_volumes(
      client = setup_db_client,
      catalog_name = "catalog_name",
      schema_name = "schema_name",
      max_results = 100,
      include_browse = 1
    )
  )
})

test_that("delete_databricks_volume fails with invalid inputs", {
  # Invalid client
  testthat::expect_error(delete_databricks_volume(client = "invalid_client"))

  # Invalid name
  testthat::expect_error(delete_databricks_volume(client = setup_db_client, name = 1))

  # Invalid catalog_name
  testthat::expect_error(delete_databricks_volume(client = setup_db_client, name = "name", catalog_name = 1))

  # Invalid schema_name
  testthat::expect_error(
    delete_databricks_volume(
      client = setup_db_client,
      name = "name",
      catalog_name = "catalog_name",
      schema_name = 1
    )
  )
})

test_that("get_databricks_volume works", {
  skip_on_cran()
  skip_on_ci()

  # Create volume
  create_databricks_volume(
    name = "test_volume",
    catalog_name = Sys.getenv("DATABRICKS_CATALOG_NAME"),
    schema_name = Sys.getenv("DATABRICKS_SCHEMA_NAME")
  )

  volume <- get_databricks_volume(
    name = "test_volume",
    catalog_name = Sys.getenv("DATABRICKS_CATALOG_NAME"),
    schema_name = Sys.getenv("DATABRICKS_SCHEMA_NAME")
  )

  testthat::expect_true(is.list(volume))

  delete_databricks_volume(
    name = "test_volume",
    catalog_name = Sys.getenv("DATABRICKS_CATALOG_NAME"),
    schema_name = Sys.getenv("DATABRICKS_SCHEMA_NAME")
  )
})
