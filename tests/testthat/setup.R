### Script for setting up tests
testing_env_variables <- c(
  "DATABRICKS_VOLUME",
  "DATABRICKS_CATALOG_NAME",
  "DATABRICKS_SCHEMA_NAME"
)

rlang::check_installed("glue")

if (isFALSE(as.logical(Sys.getenv("CI", "false")))) {
  if (!all(testing_env_variables %in% names(Sys.getenv()))) {
    cli::cli_abort(
      "Not all testing parameters are set. Please set environment variables:
      DATABRICKS_VOLUME, DATABRICKS_CATALOG_NAME and DATABRICKS_SCHEMA_NAME in
      order to be able to test the package."
    )
  } else {
    # Databricks catalog used throughout tests
    setup_db_catalog <- Sys.getenv("DATABRICKS_CATALOG_NAME")

    # Databricks schema used throughout tests
    setup_db_schema <- Sys.getenv("DATABRICKS_SCHEMA_NAME")

    # Setup databricks volume path
    setup_databricks_volume <- Sys.getenv("DATABRICKS_VOLUME")

    # Setup Databricks table http path
    setup_db_http_path <- Sys.getenv("DATABRICKS_HTTP_PATH")

    # Databricks volume used throughout tests
    setup_db_volume_path <- paste(
      setup_db_catalog,
      setup_db_schema,
      "local_test_volume",
      sep = "/"
    )

    # Connector Volume object testing
    setup_volume_connector <- connector_databricks_volume(
      catalog = setup_db_catalog,
      schema = setup_db_schema,
      path = "local_test_volume",
      force = TRUE
    )

    # Connector Table object testing
    setup_table_connector <- connector_databricks_table(
      catalog = setup_db_catalog,
      schema = setup_db_schema,
      http_path = setup_db_http_path
    )

    ##  Run after all tests
    # Placeholder for whatever needs to be removed in the end
    withr::defer(
      brickster::db_uc_volumes_delete(
        volume = "local_test_volume",
        catalog = setup_db_catalog,
        schema = setup_db_schema
      ),
      teardown_env()
    )
  }
}
