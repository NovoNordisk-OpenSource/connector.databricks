skip_offline_test()
skip_if_not_installed("whirl")

# Create a mock ConnectorDatabricksTable object with a temporary folder path
dbi_connector <- connector_databricks_table(
  http_path = setup_db_http_path,
  catalog = setup_db_catalog,
  schema = setup_db_schema,
  extra_class = "connector_logger"
)

driver_name <- dbi_connector$conn@info$drivername
driver_version <- dbi_connector$conn@info$driver.version
driver_dbversion <- dbi_connector$conn@info$db.version
driver_odbcdriverversion <- dbi_connector$conn@info$odbcdriver.version


test_that("log_read_connector.ConnectorDatabricksTable logs correct message", {
  # Create mock for whirl::log_read
  log_mock <- mockery::mock()
  mockery::stub(
    log_read_connector.ConnectorDatabricksTable,
    "whirl::log_read",
    log_mock
  )

  # Test the function
  log_read_connector.ConnectorDatabricksTable(dbi_connector, "test.csv")

  # Verify log_read was called with correct message
  expected_msg <- glue::glue(
    "test.csv @ dbname: hive_metastore, ",
    "dbms.name: Spark SQL, ",
    "db.version: {driver_dbversion}, ",
    "drivername: {driver_name}, ",
    "driver.version: {driver_version}, ",
    "odbcdriver.version: {driver_odbcdriverversion}, ",
    "catalog:{setup_db_catalog}, ",
    "schema:{setup_db_schema}"
  )
  mockery::expect_called(log_mock, 1)
  mockery::expect_args(log_mock, 1, expected_msg)
})

test_that("log_write_connector.ConnectorDatabricksTable logs correct message", {
  # Create mock for whirl::log_write
  log_mock <- mockery::mock()
  mockery::stub(
    log_write_connector.ConnectorDatabricksTable,
    "whirl::log_write",
    log_mock
  )

  # Test the function
  log_write_connector.ConnectorDatabricksTable(dbi_connector, "test.csv")

  # Verify log_write was called with correct message
  expected_msg <- glue::glue(
    "test.csv @ dbname: hive_metastore, ",
    "dbms.name: Spark SQL, ",
    "db.version: {driver_dbversion}, ",
    "drivername: {driver_name}, ",
    "driver.version: {driver_version}, ",
    "odbcdriver.version: {driver_odbcdriverversion}, ",
    "catalog:{setup_db_catalog}, ",
    "schema:{setup_db_schema}"
  )

  mockery::expect_called(log_mock, 1)
  mockery::expect_args(log_mock, 1, expected_msg)
})

test_that("log_remove_connector for tables logs correct message", {
  # Create mock for whirl::log_delete
  log_mock <- mockery::mock()
  mockery::stub(
    log_remove_connector.ConnectorDatabricksTable,
    "whirl::log_delete",
    log_mock
  )

  # Test the function
  log_remove_connector.ConnectorDatabricksTable(dbi_connector, "test.csv")

  # Verify log_delete was called with correct message
  expected_msg <- glue::glue(
    "test.csv @ dbname: hive_metastore, ",
    "dbms.name: Spark SQL, ",
    "db.version: {driver_dbversion}, ",
    "drivername: {driver_name}, ",
    "driver.version: {driver_version}, ",
    "odbcdriver.version: {driver_odbcdriverversion}, ",
    "catalog:{setup_db_catalog}, ",
    "schema:{setup_db_schema}"
  )

  mockery::expect_called(log_mock, 1)
  mockery::expect_args(log_mock, 1, expected_msg)
})

get_full_path <- paste0("/Volumes/", setup_db_volume_path)

db_vol_connector <- connector.databricks::ConnectorDatabricksVolume$new(
  full_path = get_full_path,
  extra_class = "connector_logger",
  force = TRUE
)

test_that("log_read_connector for volumes logs correct message", {
  # Create mock for whirl::log_read
  log_mock <- mockery::mock()
  mockery::stub(
    log_read_connector.ConnectorDatabricksVolume,
    "whirl::log_read",
    log_mock
  )

  # Test the function
  log_read_connector.ConnectorDatabricksVolume(db_vol_connector, "test.csv")

  # Verify log_read was called with correct message
  expected_msg <- glue::glue("test.csv @ {get_full_path}")
  mockery::expect_called(log_mock, 1)
  mockery::expect_args(log_mock, 1, expected_msg)
})

test_that("log_write_connector for volumes logs correct message", {
  # Create mock for whirl::log_write
  log_mock <- mockery::mock()
  mockery::stub(
    log_write_connector.ConnectorDatabricksVolume,
    "whirl::log_write",
    log_mock
  )

  # Test the function
  log_write_connector.ConnectorDatabricksVolume(
    db_vol_connector,
    "test.csv"
  )

  # Verify log_write was called with correct message
  expected_msg <- glue::glue("test.csv @ {get_full_path}")
  mockery::expect_called(log_mock, 1)
  mockery::expect_args(log_mock, 1, expected_msg)
})

test_that("log_remove_connector for volumes logs correct message", {
  # Create mock for whirl::log_delete
  log_mock <- mockery::mock()
  mockery::stub(
    log_remove_connector.ConnectorDatabricksVolume,
    "whirl::log_delete",
    log_mock
  )

  # Test the function
  log_remove_connector.ConnectorDatabricksVolume(
    db_vol_connector,
    "test.csv"
  )

  # Verify log_delete was called with correct message
  expected_msg <- glue::glue("test.csv @ {get_full_path}")
  mockery::expect_called(log_mock, 1)
  mockery::expect_args(log_mock, 1, expected_msg)
})
