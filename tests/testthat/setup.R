### Script for setting up tests

# Databrick client used throught testing
setup_db_client <- DatabricksClient()

# Databricks volume used throughout tests
setup_db_volume <- Sys.getenv("DATABRICKS_VOLUME")

# Databricks Connector
setup_db_volume_connector <- connector_databricks_volumes(setup_db_volume)

##  Run after all tests
# Placeholder for whatever needs to be removed in the end
# withr::defer(rm(setup_db_volume), teardown_env())
