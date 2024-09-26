test_that("ConnectorDatabricksVolume creation fails", {
  # Invalid full path
  expect_error(ConnectorDatabricksVolume$new(full_path = 1))

  # Invalid catalog
  expect_error(ConnectorDatabricksVolume$new(catalog = 1))

  # Invalid schema
  expect_error(ConnectorDatabricksVolume$new(catalog = "DATABRICKS_CATALOG_NAME", schema = 1))

  # Invalid path
  expect_error(
    ConnectorDatabricksVolume$new(
      catalog = "DATABRICKS_CATALOG_NAME",
      schema = "DATABRICKS_SCHEMA_NAME",
      path = 1
    )
  )

  # Invalid force
  expect_error(
    ConnectorDatabricksVolume$new(
      catalog = "DATABRICKS_CATALOG_NAME",
      schema = "DATABRICKS_SCHEMA_NAME",
      path = "path",
      force = 1
    )
  )

  # Invalid extra class
  expect_error(
    ConnectorDatabricksVolume$new(
      catalog = "DATABRICKS_CATALOG_NAME",
      schema = "DATABRICKS_SCHEMA_NAME",
      path = "path",
      extra_class = 1
    )
  )
})

test_that("ConnectorDatabricksVolume creation fails", {
  # Invalid full path
  expect_error(ConnectorDatabricksVolume(full_path = 1))

  # Invalid catalog
  expect_error(ConnectorDatabricksVolume(catalog = 1))

  # Invalid schema
  expect_error(ConnectorDatabricksVolume(catalog = "DATABRICKS_CATALOG_NAME", schema = 1))

  # Invalid path
  expect_error(
    ConnectorDatabricksVolume(
      catalog = "DATABRICKS_CATALOG_NAME",
      schema = "DATABRICKS_SCHEMA_NAME",
      path = 1
    )
  )

  # Invalid force
  expect_error(
    ConnectorDatabricksVolume(
      catalog = "DATABRICKS_CATALOG_NAME",
      schema = "DATABRICKS_SCHEMA_NAME",
      path = "path",
      force = 1
    )
  )

  # Invalid extra class
  expect_error(
    ConnectorDatabricksVolume(
      catalog = "DATABRICKS_CATALOG_NAME",
      schema = "DATABRICKS_SCHEMA_NAME",
      path = "path",
      extra_class = 1
    )
  )
})

test_that("ConnectorDatabricksVolume creation fails", {
  # Invalid full path
  expect_error(ConnectorDatabricksVolume(full_path = 1))

  # Invalid catalog
  expect_error(ConnectorDatabricksVolume(catalog = 1))

  # Invalid schema
  expect_error(ConnectorDatabricksVolume(catalog = "DATABRICKS_CATALOG_NAME", schema = 1))

  # Invalid path
  expect_error(
    ConnectorDatabricksVolume(
      catalog = "DATABRICKS_CATALOG_NAME",
      schema = "DATABRICKS_SCHEMA_NAME",
      path = 1
    )
  )

  # Invalid force
  expect_error(
    ConnectorDatabricksVolume(
      catalog = "DATABRICKS_CATALOG_NAME",
      schema = "DATABRICKS_SCHEMA_NAME",
      path = "path",
      force = 1
    )
  )

  # Invalid extra class
  expect_error(
    ConnectorDatabricksVolume(
      catalog = "DATABRICKS_CATALOG_NAME",
      schema = "DATABRICKS_SCHEMA_NAME",
      path = "path",
      extra_class = 1
    )
  )
})

test_that("ConnectorDatabricksVolume creation works", {
  skip_on_cran()
  skip_on_ci()

  ### Using already existing volume
  # Create connector using valid full path
  con <- ConnectorDatabricksVolume$new(full_path = setup_db_volume_path)

  checkmate::expect_r6(
    x = con,
    classes = c("connector", "ConnectorDatabricksVolume"),
    public = c(
      "list_content_cnt",
      "create_directory_cnt",
      "read_cnt",
      "write_cnt",
      "remove_cnt",
      "upload_cnt",
      "download_cnt",
      "remove_directory_cnt"
    ),
    private = c(".path", ".full_path", ".catalog", ".schema")
  )

  # Create connector using individual parameters
  con2 <- ConnectorDatabricksVolume$new(catalog = setup_db_catalog,
                                        schema = setup_db_schema,
                                        path = "local_test_volume")
  checkmate::expect_r6(
    x = con2,
    classes = c("connector", "ConnectorDatabricksVolume"),
    public = c(
      "list_content_cnt",
      "create_directory_cnt",
      "read_cnt",
      "write_cnt",
      "remove_cnt",
      "upload_cnt",
      "download_cnt",
      "remove_directory_cnt"
    ),
    private = c(".path", ".full_path", ".catalog", ".schema")
  )

  # Create connector using individual parameters and extra class
  con3 <- ConnectorDatabricksVolume$new(catalog = setup_db_catalog,
                                        schema = setup_db_schema,
                                        path = "local_test_volume",
                                        extra_class = "extra_class")
  checkmate::expect_r6(
    x = con3,
    classes = c("connector", "ConnectorDatabricksVolume", "extra_class"),
    public = c(
      "list_content_cnt",
      "create_directory_cnt",
      "read_cnt",
      "write_cnt",
      "remove_cnt",
      "upload_cnt",
      "download_cnt",
      "remove_directory_cnt"
    ),
    private = c(".path", ".full_path", ".catalog", ".schema")
  )

  # Create connector using individual parameters with force parameter
  con4 <- ConnectorDatabricksVolume$new(catalog = setup_db_catalog,
                                        schema = setup_db_schema,
                                        path = "local_test_volume/force",
                                        force = TRUE)
  checkmate::expect_r6(
    x = con4,
    classes = c("connector", "ConnectorDatabricksVolume"),
    public = c(
      "list_content_cnt",
      "create_directory_cnt",
      "read_cnt",
      "write_cnt",
      "remove_cnt",
      "upload_cnt",
      "download_cnt",
      "remove_directory_cnt"
    ),
    private = c(".path", ".full_path", ".catalog", ".schema")
  )
})

test_that("ConnectorDatabricksVolume creation using ConnectorDatabricksVolume works", {
  skip_on_cran()
  skip_on_ci()

  ### Using already existing volume
  # Create connector using valid full path
  con <- connector_databricks_volume(full_path = setup_db_volume_path)

  checkmate::expect_r6(
    x = con,
    classes = c("connector", "ConnectorDatabricksVolume"),
    public = c(
      "list_content_cnt",
      "create_directory_cnt",
      "read_cnt",
      "write_cnt",
      "remove_cnt",
      "upload_cnt",
      "download_cnt",
      "remove_directory_cnt"
    ),
    private = c(".path", ".full_path", ".catalog", ".schema")
  )

  # Create connector using individual parameters
  con2 <- connector_databricks_volume(catalog = setup_db_catalog,
                                        schema = setup_db_schema,
                                        path = "local_test_volume")
  checkmate::expect_r6(
    x = con2,
    classes = c("connector", "ConnectorDatabricksVolume"),
    public = c(
      "list_content_cnt",
      "create_directory_cnt",
      "read_cnt",
      "write_cnt",
      "remove_cnt",
      "upload_cnt",
      "download_cnt",
      "remove_directory_cnt"
    ),
    private = c(".path", ".full_path", ".catalog", ".schema")
  )

  # Create connector using individual parameters and extra class
  con3 <- connector_databricks_volume(catalog = setup_db_catalog,
                                        schema = setup_db_schema,
                                        path = "local_test_volume",
                                        extra_class = "extra_class")
  checkmate::expect_r6(
    x = con3,
    classes = c("connector", "ConnectorDatabricksVolume", "extra_class"),
    public = c(
      "list_content_cnt",
      "create_directory_cnt",
      "read_cnt",
      "write_cnt",
      "remove_cnt",
      "upload_cnt",
      "download_cnt",
      "remove_directory_cnt"
    ),
    private = c(".path", ".full_path", ".catalog", ".schema")
  )

  # Create connector using individual parameters with force parameter
  con4 <- connector_databricks_volume(catalog = setup_db_catalog,
                                        schema = setup_db_schema,
                                        path = "local_test_volume/force",
                                        force = TRUE)
  checkmate::expect_r6(
    x = con4,
    classes = c("connector", "ConnectorDatabricksVolume"),
    public = c(
      "list_content_cnt",
      "create_directory_cnt",
      "read_cnt",
      "write_cnt",
      "remove_cnt",
      "upload_cnt",
      "download_cnt",
      "remove_directory_cnt"
    ),
    private = c(".path", ".full_path", ".catalog", ".schema")
  )
})

test_that("ConnectorDatabricksVolume methods work", {
  skip_on_cran()
  skip_on_ci()

  ### Testing scenario

  ## 1. Test directory method works
  # Create connector using valid full path
  con <- ConnectorDatabricksVolume$new(full_path = setup_db_volume_path)

  # Create a test directory
  test_directory <- "test_directory"
  con$create_directory_cnt(test_directory)

  # List contents of root folder
  list_of_items <- con$list_content_cnt()

  # Check if directory exists
  expect_contains(list_of_items, basename(test_directory))

  # Delete test directory
  con$remove_directory_cnt(test_directory)

  # List contents of root folder
  list_of_items <- con$list_content_cnt()

  # Check if directory exists
  expect_false(basename(test_directory) %in% list_of_items)

  ## 2. Test file method works
  # Write a test file
  con$write_cnt(x = tibble::tibble(x = 1, y = 2), name = "test_file.csv")

  # List contents of root folder
  list_of_items <- con$list_content_cnt()

  # Check if file exists
  expect_contains(list_of_items, basename("test_file.csv"))

  # Download the file
  con$download_cnt("test_file.csv", "test_file.csv")

  # Check if file exists
  expect_true(file.exists("test_file.csv"))

  # Read the file
  file_content <- con$read_cnt("test_file.csv")

  # Check if file content is correct
  expect_equal(file_content, tibble::tibble(x = 1, y = 2))

  # Delete test file
  con$remove_cnt("test_file.csv")

  # List contents of root folder
  list_of_items <- con$list_content_cnt()

  # Check if file exists
  expect_false(basename("test_file.csv") %in% list_of_items)

  # Create a test file
  con$upload_cnt("test_file.csv", "test_file.csv")

  # List contents of root folder
  list_of_items <- con$list_content_cnt()

  # Check if file exists
  expect_contains(list_of_items, basename("test_file.csv"))

  # Delete test file
  con$remove_cnt("test_file.csv")

  # Delete local test file
  unlink("test_file.csv")
})
