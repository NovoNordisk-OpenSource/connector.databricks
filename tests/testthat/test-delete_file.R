test_that("delete file works", {
  skip_on_ci()
  skip_on_cran()

  # Create a test file
  test_file <- tempfile("test_file", fileext = ".csv", tmpdir = setup_db_volume)
  local_create_file(setup_db_client, file_name = test_file, del = FALSE)

  # Delete file
  delete_file(client = setup_db_client, file_path = test_file)

  # List items in root directory
  list_of_items <- list_file_dir_contents(path = setup_db_volume, client = setup_db_client)

  # Check if file does not exist
  testthat::expect_false(basename(test_file) %in% list_of_items)
})


test_that("delete file fails when needed", {
  # Test bad client fails
  testthat::expect_error(delete_file(client = 1))

  # Test bad file path fails
  testthat::expect_error(delete_file(client = setup_db_client, file_path = 1))
})
