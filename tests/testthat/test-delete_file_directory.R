test_that("delete file directory works", {
  skip_on_ci()
  skip_on_cran()

  # Create a test directory
  test_directory <- tempfile("test_directory", tmpdir = setup_db_volume)
  local_create_directory(setup_db_client, test_directory, del = FALSE)

  # Delete directory
  delete_file_directory(client = setup_db_client, directory_path = test_directory)

  # List items in root directory
  list_of_items <- list_file_dir_contents(path = setup_db_volume, client = setup_db_client)

  # Check if directory exists
  testthat::expect_false(basename(test_directory) %in% list_of_items)
})


test_that("delete file directory fails when needed", {
  # Test bad client fails
  testthat::expect_error(delete_file_directory(client = 1))

  # Test bad directory path fails
  testthat::expect_error(delete_file_directory(client = setup_db_client, directory_path = 1))
})
