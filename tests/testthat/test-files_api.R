test_that("files_list_directory_contents works", {
  skip_on_ci()
  skip_on_cran()

  # Create a test directory
  test_directory <- tempfile("test_directory_", tmpdir = setup_databricks_volume)
  files_create_directory(directory_path = test_directory)

  # Add files to a test directory
  test_file1 <- tempfile("test_file1", fileext = ".csv", tmpdir = test_directory)
  write_fs_databricks(x = iris, file = test_file1)

  test_file2 <- tempfile("test_file2", fileext = ".csv", tmpdir = test_directory)
  write_fs_databricks(x = iris, file = test_file2)

  # List contents of test directory
  list_of_items <- files_list_directory_contents(directory_path = test_directory)

  # Check if test_files exist in directory
  testthat::expect_contains(list_of_items, c(basename(test_file1), basename(test_file2)))
})


test_that("files_list_directory_contents when needed", {
  # Test bad directory path fails
  testthat::expect_error(files_list_directory_contents(directory_path = 1))

  # Test bad page size fails
  testthat::expect_error(files_list_directory_contents(directory_path = "dummy_path", page_size = "bad_size"))

  # Test bad page token fails
  testthat::expect_error(files_list_directory_contents(directory_path = "dummy_path", page_token = 1))

  # Test bad recursive fails
  testthat::expect_error(files_list_directory_contents(directory_path = "dummy_path", recursive = 1))

  # Test bad client fails
  testthat::expect_error(files_list_directory_contents(directory_path = "dummy_path", client = 1))
})


test_that("create file directory works", {
  skip_on_ci()
  skip_on_cran()

  # Create a test directory
  test_directory <- tempfile("test_directory_", tmpdir = setup_databricks_volume)
  files_create_directory(directory_path = test_directory)

  # List contents of root folder
  list_of_items <- files_list_directory_contents(directory_path = setup_databricks_volume)

  # Check if directory exists
  testthat::expect_contains(list_of_items, basename(test_directory))
})


test_that("create file directory fails when needed", {
  # Test bad directory path fails
  testthat::expect_error(files_create_directory(directory_path = 1))

  # Test bad client fails
  testthat::expect_error(files_create_directory(client = 1))
})

test_that("delete file directory works", {
  skip_on_ci()
  skip_on_cran()

  # Create a test directory
  test_directory <- tempfile("test_directory_", tmpdir = setup_databricks_volume)
  files_create_directory(directory_path = test_directory)

  # Delete directory
  files_delete_directory(directory_path = test_directory)

  # List items in root directory
  list_of_items <- files_list_directory_contents(directory_path = setup_databricks_volume)

  # Check if directory exists
  testthat::expect_false(basename(test_directory) %in% list_of_items)
})


test_that("delete file directory fails when needed", {
  # Test bad directory path fails
  testthat::expect_error(files_delete_directory(directory_path = 1))

  # Test bad client fails
  testthat::expect_error(files_delete_directory(directory_path = "dummy_path", client = 1))
})

test_that("check file directory exists works", {
  skip_on_ci()
  skip_on_cran()

  # Create a test directory
  test_directory <- tempfile("test_directory_", tmpdir = setup_databricks_volume)
  files_create_directory(directory_path = test_directory)

  # Check if call is successful
  ### This test needs rework
  testthat::expect_true(
    files_check_databricks_dir_exists(directory_path = test_directory)
  )
})


test_that("check file directory exists fails when needed", {
  # Test bad directory fails
  testthat::expect_error(files_check_databricks_dir_exists(directory_path = 1))

  # Test bad client path fails
  testthat::expect_error(files_check_databricks_dir_exists(directory_path = "dummy_path", client = 1))
})


test_that("download file works", {
  skip_on_ci()
  skip_on_cran()

  # Create a test file
  test_file <- tempfile("test_file", fileext = ".csv", tmpdir = setup_databricks_volume)
  write_fs_databricks(x = iris, file = test_file)

  # Download file
  files_download_file(file_path = test_file, local_path = "temp.csv")

  # Check if file  exist
  testthat::expect_true(file.exists("temp.csv"))

  # Delete file on volume
  files_delete_file(file_path = test_file)

  # Remove file
  unlink("temp.csv")
})


test_that("download file fails when needed", {
  # Test bad file path fails
  testthat::expect_error(files_download_file(file_path = 1))

  # Test bad local file path fails
  testthat::expect_error(files_download_file(file_path = "dummy_path", local_path = 1))

  # Test bad client fails
  testthat::expect_error(files_download_file(file_path = "dummy_path", local_path = "dummy_path", client = 1))
})

test_that("upload file works", {
  skip_on_ci()
  skip_on_cran()

  # Create a test file
  test_file <- tempfile("test_file", fileext = ".csv", tmpdir = setup_databricks_volume)
  tempfile_orig <- tempfile(fileext = ".txt")
  writeLines(letters, tempfile_orig)

  files_upload_file(file_path = test_file, contents = tempfile_orig)

  # List items in root directory
  list_of_items <- files_list_directory_contents(directory_path = setup_databricks_volume)

  # Check if file exists
  testthat::expect_contains(list_of_items, basename(test_file))

  # Delete file
  unlink(tempfile_orig)

  # Delete file on volume
  files_delete_file(file_path = test_file)
})


test_that("upload file fails when needed", {
  # Test bad file path fails
  testthat::expect_error(files_upload_file(file_path = 1))

  # Test bad contents fails
  testthat::expect_error(files_upload_file(file_path = "dummy_path", contents = 1))

  # Test bad overwrite fails
  testthat::expect_error(files_upload_file(file_path = "dummy_path", contents = "dummy_contents", overwrite = 1))

  # Test bad client fails
  testthat::expect_error(files_upload_file(file_path = "dummy_path", contents = "dummy_contents", client = 1))
})


test_that("delete file works", {
  skip_on_ci()
  skip_on_cran()

  # Create a test file
  test_file <- tempfile("test_file1", fileext = ".csv", tmpdir = setup_databricks_volume)
  write_fs_databricks(x = iris, file = test_file)

  # Delete file
  files_delete_file(file_path = test_file)

  # List items in root directory
  list_of_items <- files_list_directory_contents(directory_path = setup_databricks_volume)

  # Check if file does not exist
  testthat::expect_false(basename(test_file) %in% list_of_items)
})


test_that("delete file fails when needed", {
  # Test bad file path fails
  testthat::expect_error(files_delete_file(file_path = 1))

  # Test bad client fails
  testthat::expect_error(files_delete_file(file_path = "dummy_path", client = 1))
})


