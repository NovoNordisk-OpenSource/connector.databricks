test_that("upload file works", {
  skip_on_ci()
  skip_on_cran()

  # Create a test file
  test_file <- tempfile("test_file", fileext = ".csv", tmpdir = setup_db_volume)
  local_create_file(setup_db_client, test_file)

  # List items in root directory
  list_of_items <- list_file_dir_contents(path = setup_db_volume, client = setup_db_client)

  # Check if file exists
  testthat::expect_contains(list_of_items, basename(test_file))
})


test_that("upload file fails when needed", {
  # Test bad client fails
  testthat::expect_error(upload_file(client = 1))

  # Test bad file path fails
  testthat::expect_error(upload_file(client = setup_db_client, file_path = 1))

  # Test bad contents fails
  testthat::expect_error(upload_file(client = setup_db_client, contents = 1))

  # Test bad overwrite fails
  testthat::expect_error(upload_file(client = setup_db_client, overwrite = 1))
})
