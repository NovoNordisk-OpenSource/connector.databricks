test_that("read file works", {
  skip_on_ci()
  skip_on_cran()

  # Create a test file
  test_file <- tempfile("test_file", fileext = ".csv", tmpdir = setup_databricks_volume)
  write_fs_databricks(x = tibble::tibble(x = 1, y = 2), file = test_file)

  # Read test file
  item <- read_fs_databricks(path = test_file)

  # Check if file exists
  testthat::expect_equal(item, tibble::tibble(x = 1, y = 2))

  # Delete file
  files_delete_file(file_path = test_file)
})


test_that("read file fails when needed", {
  # Test bad file path fails
  testthat::expect_error(read_fs_databricks(path = 1))

  # Test bad client fails
  testthat::expect_error(read_fs_databricks(path = "dummy_path", client = 1))
})

test_that("write file works", {
  skip_on_ci()
  skip_on_cran()

  # Create a test file
  test_file <- tempfile("test_file", fileext = ".csv", tmpdir = setup_databricks_volume)
  write_fs_databricks(x = tibble::tibble(x = 1, y = 2), file = test_file)

  # List items in root directory
  list_of_items <- files_list_directory_contents(directory_path = setup_databricks_volume)

  # Check if file exists
  testthat::expect_contains(list_of_items, basename(test_file))

  # Delete file
  files_delete_file(file_path = test_file)
})


test_that("write file fails when needed", {
  # Test bad file path fails
  testthat::expect_error(write_fs_databricks(file = 1))

  # Test bad overwrite fails
  testthat::expect_error(write_fs_databricks(file = "dummy_file", overwrite = 1))

  # Test bad client fails
  testthat::expect_error(write_fs_databricks(file = "dummy_file", client = 1))
})

test_that("find file works", {
  skip_on_ci()
  skip_on_cran()

  # Create a test file
  test_file <- tempfile("test_file", fileext = ".csv", tmpdir = setup_databricks_volume)
  write_fs_databricks(x = tibble::tibble(x = 1, y = 2), file = test_file)

  # File found
  file_found <- find_file_databricks(name = basename(test_file), root = setup_databricks_volume)

  # Expect paths to be equal
  testthat::expect_equal(basename(test_file), file_found)

  # Delete file
  files_delete_file(file_path = test_file)
})


test_that("find file fails when needed", {
  # Test bad file name fails
  testthat::expect_error(find_file_databricks(name = 1))

  # Test bad root fails
  testthat::expect_error(find_file_databricks(name = "dummy_name", root = 1))

  # Test bad client fails
  testthat::expect_error(find_file_databricks(name = "dummy_name", root = "dummy_root", client = 1))
})
