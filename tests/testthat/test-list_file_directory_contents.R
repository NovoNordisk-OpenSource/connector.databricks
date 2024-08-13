test_that("create file directory works", {
  skip_on_ci()
  skip_on_cran()

  # Create a test directory
  test_directory <- tempfile("test_directory", tmpdir = setup_db_volume)
  local_create_directory(setup_db_client, test_directory)

  # Add files to a test directory
  test_file1 <- tempfile("test_file1", fileext = ".csv", tmpdir = test_directory)
  local_create_file(setup_db_client, test_file1)

  test_file2 <- tempfile("test_file2", fileext = ".csv", tmpdir = test_directory)
  local_create_file(setup_db_client, test_file2)

  # List contents of test directory
  list_of_items <- list_file_dir_contents(path = test_directory, client = setup_db_client)

  # Check if test_files exist in directory
  testthat::expect_contains(list_of_items, c(basename(test_file1), basename(test_file2)))
})


test_that("create file directory fails when needed", {
  # Test bad client fails
  testthat::expect_error(list_file_dir_contents(client = 1))

  # Test bad directory path fails
  testthat::expect_error(list_file_dir_contents(client = setup_db_client, path = 1))
})
