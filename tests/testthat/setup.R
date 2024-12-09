### Script for setting up tests
skip_on_ci()

testing_env_variables <- c(
  "DATABRICKS_VOLUME",
  "DATABRICKS_CATALOG_NAME",
  "DATABRICKS_SCHEMA_NAME"
)

if (!all(testing_env_variables %in% names(Sys.getenv()))) {
  cli::cli_abort("Not all testing parameters are set. Please set environment variables:
    DATABRICKS_VOLUME, DATABRICKS_CATALOG_NAME and DATABRICKS_SCHEMA_NAME in order to be
  able to test the package.")
}

# Dummy DatabricksClient object (used for failing tests)
dummy_db_client <- list(a = 1, b = 2)

# Databricks catalog used throughout tests
setup_db_catalog <- Sys.getenv("DATABRICKS_CATALOG_NAME")

# Databricks schema used throughout tests
setup_db_schema <- Sys.getenv("DATABRICKS_SCHEMA_NAME")

# Setup databricks volume path
setup_databricks_volume <- Sys.getenv("DATABRICKS_VOLUME")

# Databricks volume used throughout tests
setup_db_volume_path <- paste(setup_db_catalog, setup_db_schema, "local_test_volume", sep = "/")

# Connector object testing
setup_volume_connector <- connector_databricks_volume(
  catalog = setup_db_catalog,
  schema = setup_db_schema,
  path = "local_test_volume",
  force = TRUE
)

##  Run after all tests
# Placeholder for whatever needs to be removed in the end
withr::defer(
  delete_databricks_volume(
    name = "local_test_volume",
    catalog_name = setup_db_catalog,
    schema_name = setup_db_schema
  ),
  teardown_env()
)
