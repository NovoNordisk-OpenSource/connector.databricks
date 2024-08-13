test_that("read file works", {
  skip_on_ci()
  skip_on_cran()

  # Create a test file
  test_file <- tempfile("test_file", fileext = ".csv", tmpdir = test_directory)
  local_create_file(setup_db_client, test_file)

  # List items in root directory
  item <- read_fs_databricks(setup_db_client, path = test_file)

  # Check if file exists
  testthat::expect_equal(item, tibble::tibble(x = 1, y = 2))
})


test_that("read file fails when needed", {
  # Test bad client fails
  testthat::expect_error(read_fs_databricks(client = 1))

  # Test bad file path fails
  testthat::expect_error(read_fs_databricks(client = setup_db_client, path = 1))
})
