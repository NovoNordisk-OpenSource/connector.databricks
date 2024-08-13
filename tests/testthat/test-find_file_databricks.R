test_that("find file works", {
  skip_on_ci()
  skip_on_cran()

  # Create a test file
  test_file <- tempfile("test_file", fileext = ".csv", tmpdir = setup_db_volume)
  local_create_file(setup_db_client, file_name = test_file)

  # File found
  file_found <- find_file_databricks(name = basename(test_file), root = setup_db_volume, client = setup_db_client)

  # Expect paths to be equal
  testthat::expect_equal(test_file, file_found)
})


test_that("find file fails when needed", {
  # Test bad client fails
  testthat::expect_error(find_file_databricks(client = 1))

  # Test bad file path fails
  testthat::expect_error(find_file_databricks(client = setup_db_client, name = 1))

  # Test bad contents fails
  testthat::expect_error(find_file_databricks(client = setup_db_client, root = 1))
})
