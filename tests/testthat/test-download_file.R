test_that("download file works", {
  skip_on_ci()
  skip_on_cran()

  # Create a test file
  test_file <- tempfile("test_file", fileext = ".csv", tmpdir = setup_db_volume)
  local_create_file(setup_db_client, file_name = test_file, del = TRUE)

  # Delete file
  download_file(client = setup_db_client, file_path = test_file, local_path = "temp")

  # Check if file  exist
  testthat::expect_true(file.exists("temp"))

  # Remove file
  unlink("temp")
})


test_that("download file fails when needed", {
  # Test bad client fails
  testthat::expect_error(download_file(client = 1))

  # Test bad file path fails
  testthat::expect_error(download_file(client = setup_db_client, file_path = 1))

  # Test bad local file path fails
  testthat::expect_error(download_file(client = setup_db_client, local_path = 1))
})
