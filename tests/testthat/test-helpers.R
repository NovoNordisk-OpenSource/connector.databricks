local_create_directory <- function(db_client = NULL,
                                   dir = fs::file_temp(),
                                   del = TRUE,
                                   env = parent.frame()) {
  # create new test directory
  test_directory <- create_file_directory(client = db_client, directory_path = dir)
  withr::defer(if (del)
    delete_file_directory(client = db_client, directory_path = dir),
    envir = env)

  test_directory
}

local_create_file <- function(db_client = NULL,
                              file_name = fs::file_temp(),
                              del = TRUE,
                              env = parent.frame()) {
  # create new test file
  test_file <- withr::local_tempfile(lines = c("x,y", "1,2"))

  file <- upload_file(db_client, file_name, test_file)

  withr::defer(if (del)
    delete_file(client = db_client, file_path = file_name),
    envir = env)

  test_file
}

local_write_file <- function(db_client = NULL,
                             file_name = fs::file_temp(),
                             del = TRUE,
                             env = parent.frame()) {
  file <- write_fs_databricks(x = tibble::tibble(x = 1, y = 2),
                              file = file_name,
                              client = db_client)

  withr::defer(if (del)
    delete_file(client = db_client, file_path = file_name),
    envir = env)

  file
}

local_connector_create_directory <- function(connector = NULL,
                                             db_client = NULL,
                                             dir = fs::file_temp(),
                                             del = TRUE,
                                             env = parent.frame()) {
  # create new test directory
  test_directory <- connector$create_directory(client = db_client, dir = dir)
  withr::defer(if (del)
    connector$remove_directory(client = db_client, dir = dir),
    envir = env)

  test_directory
}

local_connector_write_file <- function(connector = NULL,
                                       db_client = NULL,
                                       file_name = fs::file_temp(),
                                       del = TRUE,
                                       env = parent.frame()) {
  file <- connector$write(x = tibble::tibble(x = 1, y = 2), file = file_name)

  withr::defer(if (del)
    connector$remove(file_name, client = db_client), envir = env)

  file
}
