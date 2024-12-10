test_that("delete file works", {
  skip_on_ci()
  skip_on_cran()

  # Create a test file
  # test_file <- tempfile("test_file1", fileext = ".csv", tmpdir = setup_databricks_volume)
  # write_fs_databricks(x = iris, file = test_file)

  setup_volume_connector$write_cnt(x = tibble::tibble(x = 1, y = 2), name = "test_file1.csv", overwrite = TRUE)
  
  # Delete file
  files_delete_file(file_path = paste0(setup_volume_connector$full_path, "/test_file1.csv"))

  # List items in root directory
  list_of_items <- setup_volume_connector$list_content_cnt()

  # Check if file does not exist
  testthat::expect_false("test_file1.csv" %in% list_of_items)
})


test_that("delete file fails when needed", {
  # Test bad file path fails
  testthat::expect_error(files_delete_file(file_path = 1))

  # Test bad client fails
  testthat::expect_error(files_delete_file(file_path = "dummy_path", client = 1))
})
