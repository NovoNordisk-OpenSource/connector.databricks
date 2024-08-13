test_that("create file directory works", {
  skip_on_ci()
  skip_on_cran()

  # Create a test directory
  test_directory <- tempfile("test_directory", tmpdir = setup_db_volume)
  local_create_directory(setup_db_client, test_directory)

  # List contents of root folder
  list_of_items <- list_file_dir_contents(path = setup_db_volume, client = setup_db_client)

  # Check if directory exists
  testthat::expect_contains(list_of_items, basename(test_directory))
})


test_that("create file directory fails when needed", {
  # Test bad client fails
  testthat::expect_error(create_file_directory(client = 1))

  # Test bad directory path fails
  testthat::expect_error(create_file_directory(client = setup_db_client, directory_path = 1))
})
