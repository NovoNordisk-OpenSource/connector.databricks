test_that("ConnectorDatabricksVolume creation fails", {
  # Invalid full path
  expect_error(ConnectorDatabricksVolume$new(full_path = 1))

  # Invalid catalog
  expect_error(ConnectorDatabricksVolume$new(catalog = 1))

  # Invalid schema
  expect_error(ConnectorDatabricksVolume$new(
    catalog = "DATABRICKS_CATALOG_NAME",
    schema = 1
  ))

  # Invalid path
  expect_error(ConnectorDatabricksVolume$new(
    catalog = "DATABRICKS_CATALOG_NAME",
    schema = "DATABRICKS_SCHEMA_NAME",
    path = 1
  ))

  # Invalid force
  expect_error(ConnectorDatabricksVolume$new(
    catalog = "DATABRICKS_CATALOG_NAME",
    schema = "DATABRICKS_SCHEMA_NAME",
    path = "path",
    force = 1
  ))

  # Invalid extra class
  expect_error(ConnectorDatabricksVolume$new(
    catalog = "DATABRICKS_CATALOG_NAME",
    schema = "DATABRICKS_SCHEMA_NAME",
    path = "path",
    extra_class = 1
  ))
})

test_that("connector_databricks_volume creation fails", {
  # Invalid full path
  expect_error(connector_databricks_volume(full_path = 1))

  # Invalid catalog
  expect_error(connector_databricks_volume(catalog = 1))

  # Invalid schema
  expect_error(connector_databricks_volume(
    catalog = "DATABRICKS_CATALOG_NAME",
    schema = 1
  ))

  # Invalid path
  expect_error(connector_databricks_volume(
    catalog = "DATABRICKS_CATALOG_NAME",
    schema = "DATABRICKS_SCHEMA_NAME",
    path = 1
  ))

  # Invalid force
  expect_error(connector_databricks_volume(
    catalog = "DATABRICKS_CATALOG_NAME",
    schema = "DATABRICKS_SCHEMA_NAME",
    path = "path",
    force = 1
  ))

  # Invalid extra class
  expect_error(connector_databricks_volume(
    catalog = "DATABRICKS_CATALOG_NAME",
    schema = "DATABRICKS_SCHEMA_NAME",
    path = "path",
    extra_class = 1
  ))
})

test_that("connector_databricks_volume creation fails", {
  # Invalid full path
  expect_error(connector_databricks_volume(full_path = 1))

  # Invalid catalog
  expect_error(connector_databricks_volume(catalog = 1))

  # Invalid schema
  expect_error(connector_databricks_volume(
    catalog = "DATABRICKS_CATALOG_NAME",
    schema = 1
  ))

  # Invalid path
  expect_error(connector_databricks_volume(
    catalog = "DATABRICKS_CATALOG_NAME",
    schema = "DATABRICKS_SCHEMA_NAME",
    path = 1
  ))

  # Invalid force
  expect_error(connector_databricks_volume(
    catalog = "DATABRICKS_CATALOG_NAME",
    schema = "DATABRICKS_SCHEMA_NAME",
    path = "path",
    force = 1
  ))

  # Invalid extra class
  expect_error(connector_databricks_volume(
    catalog = "DATABRICKS_CATALOG_NAME",
    schema = "DATABRICKS_SCHEMA_NAME",
    path = "path",
    extra_class = 1
  ))
})

test_that("ConnectorDatabricksVolume creation with full path works", {
  skip_on_cran()
  skip_on_ci()

  ### Using already existing volume
  # 1. Create new volume
  create_databricks_volume(
    name = "test_volume",
    catalog_name = Sys.getenv("DATABRICKS_CATALOG_NAME"),
    schema_name = Sys.getenv("DATABRICKS_SCHEMA_NAME")
  )

  # Create connector using valid full path
  con <- ConnectorDatabricksVolume$new(
    full_path = "amace_cdr_bronze_dev/nn1234_4321_adam"
  )
})
