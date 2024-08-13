test_that("get file directory metadata works", {
  skip_on_ci()
  skip_on_cran()

  # Create a test directory
  test_directory <- tempfile("test_directory", tmpdir = setup_db_volume)
  local_create_directory(setup_db_client, test_directory)

  # Check if call is successful
  ### This test needs rework
  testthat::expect_true(
    get_file_directory_metadata(directory_path = test_directory, client = setup_db_client)
  )
})


test_that("get file directory metadata fails when needed", {
  # Test bad client fails
  testthat::expect_error(get_file_directory_metadata(client = 1))

  # Test bad directory path fails
  testthat::expect_false(get_file_directory_metadata(client = setup_db_client, directory_path = 1))
})
