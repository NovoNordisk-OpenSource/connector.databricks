local_create_directory <- function(dir = fs::file_temp(),
                                   del = TRUE,
                                   env = parent.frame()) {
  # create new test directory
  test_directory <- files_create_directory(directory_path = dir)
  withr::defer(if (del) {
    files_delete_directory(directory_path = dir)
  }, envir = env)

  test_directory
}

local_create_file <- function(file_name = fs::file_temp(),
                              del = TRUE,
                              env = parent.frame()) {
  # create new test file
  test_file <- withr::local_tempfile(lines = c("x,y", "1,2"))

  file <- files_upload_file(file_path = file_name, contents = test_file)

  withr::defer(if (del) {
    files_delete_file(file_path = file_name)
  }, envir = env)

  test_file
}

local_write_file <- function(file_name = fs::file_temp(),
                             del = TRUE,
                             env = parent.frame()) {
  file <- write_fs_databricks(x = tibble::tibble(x = 1, y = 2), file = file_name)

  withr::defer(if (del) {
    files_delete_file(file_path = file_name)
  }, envir = env)

  file
}

local_connector_create_directory <- function(connector = NULL,
                                             dir = fs::file_temp(),
                                             del = TRUE,
                                             env = parent.frame()) {
  # create new test directory
  test_directory <- connector$create_directory(dir = dir)
  withr::defer(if (del) {
    connector$remove_directory(dir = dir)
  }, envir = env)

  test_directory
}

local_connector_write_file <- function(connector = NULL,
                                       file_name = fs::file_temp(),
                                       del = TRUE,
                                       env = parent.frame()) {
  file <- connector$write(x = tibble::tibble(x = 1, y = 2), file = file_name)

  withr::defer(if (del) {
    connector$remove(file_name)
  }, envir = env)

  file
}
