test_that("databricks volume initialization works", {
  skip_on_ci()
  skip_on_cran()

  testthat::expect_error(Connector_databricks_volumes$new(path = 1))

  testthat::expect_no_error(Connector_databricks_volumes$new(path = setup_db_volume))

  checkmate::assert_r6(
    Connector_databricks_volumes$new(path = setup_db_volume),
    classes = c("Connector_databricks_volumes"),
    public = c(
      "list_content",
      "construct_path",
      "read",
      "write",
      "remove",
      "remove_directory"
    ),
    cloneable = FALSE,
    private = c("path")
  )
})

test_that("databricks volume create file directory works", {
  # Test bad client fails
  testthat::expect_error(setup_db_volume_connector$create_directory(client = 1))

  # Test bad directory path fails
  testthat::expect_error(setup_db_volume_connector$create_directory(client = setup_db_client, path = 1))

  skip_on_ci()
  skip_on_cran()

  # Create a test directory
  local_connector_create_directory(setup_db_volume_connector, setup_db_client, "test_directory")

  # List contents of root folder
  list_of_items <- list_file_dir_contents(path = setup_db_volume, client = setup_db_client)

  # Check if directory exists
  testthat::expect_contains(list_of_items, basename("test_directory"))
})

test_that("databricks volume delete file directory works", {
  # Test bad client fails
  testthat::expect_error(setup_db_volume_connector$remove_directory(client = 1))

  # Test bad directory path fails
  testthat::expect_error(setup_db_volume_connector$remove_directory(client = setup_db_client, directory_path = 1))

  skip_on_ci()
  skip_on_cran()

  # Create a test directory
  local_connector_create_directory(setup_db_volume_connector, setup_db_client, "test_delete_directory", del = FALSE)

  # Delete test directory
  setup_db_volume_connector$remove_directory(dir = "test_delete_directory", client = setup_db_client)

  # List contents of root folder
  list_of_items <- list_file_dir_contents(path = setup_db_volume, client = setup_db_client)

  # Check if directory exists
  testthat::expect_false("test_delete_directory" %in% list_of_items)
})

test_that("databricks volume remove file works", {
  # Test bad client fails
  testthat::expect_error(setup_db_volume_connector$remove(client = 1))

  # Test bad file path fails
  testthat::expect_error(setup_db_volume_connector$remove(client = setup_db_client, file = 1))

  skip_on_ci()
  skip_on_cran()

  # Create a test file
  test_file <- tempfile("test_file", fileext = ".csv", tmpdir = setup_db_volume)
  local_create_file(setup_db_client, file_name = test_file, del = FALSE)

  # Delete file
  setup_db_volume_connector$remove(client = setup_db_client, file = basename(test_file))

  # List items in root directory
  list_of_items <- list_file_dir_contents(path = setup_db_volume, client = setup_db_client)

  # Check if file does not exist
  testthat::expect_false(basename(test_file) %in% list_of_items)
})

test_that("list file directory works", {
  # Test bad client fails
  testthat::expect_error(setup_db_volume_connector$list_content(client = 1))

  skip_on_ci()
  skip_on_cran()

  # Add files to a root directory
  test_file1 <- tempfile("test_file1", fileext = ".csv", tmpdir = setup_db_volume)
  local_create_file(setup_db_client, test_file1)

  test_file2 <- tempfile("test_file2", fileext = ".csv", tmpdir = setup_db_volume)
  local_create_file(setup_db_client, test_file2)

  # List contents of test directory
  list_of_items <- setup_db_volume_connector$list_content()

  # Check if test_files exist in directory
  testthat::expect_contains(list_of_items, c(basename(test_file1), basename(test_file2)))
})

test_that("read file works", {
  # Test bad client fails
  testthat::expect_error(setup_db_volume_connector$read(name = 1))

  skip_on_ci()
  skip_on_cran()

  # Create a test file
  test_file <- tempfile("test_file", fileext = ".csv", tmpdir = setup_db_volume)
  local_create_file(setup_db_client, test_file)

  # List items in root directory
  item <- setup_db_volume_connector$read(name = basename(test_file))

  # Check if file exists
  testthat::expect_equal(item, tibble::tibble(x = 1, y = 2))
})

test_that("write file works", {
  # Test bad content fails
  testthat::expect_error(setup_db_volume_connector$write(x = 1))

  # Test bad file name fails
  testthat::expect_error(setup_db_volume_connector$write(x = tibble::tibble(x = 1, y = 2), file = 1))

  skip_on_ci()
  skip_on_cran()

  # Create a test file
  test_file <- tempfile("test_file", fileext = ".csv", tmpdir = setup_db_volume)
  local_connector_write_file(connector = setup_db_volume_connector, file_name = basename(test_file), db_client = setup_db_client)

  # List items in root directory
  list_of_items <- list_file_dir_contents(path = setup_db_volume, client = setup_db_client)

  # Check if file exists
  testthat::expect_contains(list_of_items, basename(test_file))
})
