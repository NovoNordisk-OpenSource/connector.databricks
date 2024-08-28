#' List directory contents.
#'
#' Returns the contents of a directory. If there is no directory at the
#' specified path, the API returns a HTTP 404 error.
#' @param client Required. Instance of DatabricksClient()
#'
#' @param directory_path Required. The absolute path of a directory.
#' @param page_size The maximum number of directory entries to return.
#' @param page_token An opaque page token which was the `next_page_token` in the
#'   response of the previous request to list the contents of this directory.
#' @param full.names If `TRUE`, return the full path of the files, otherwise
#' just the file names.
#'
#' @return `data.frame` with all of the response pages.
#'
#' @rdname files_list_directory_contents
#'
#' @examplesIf FALSE
#' # In order to connect to databricks on environments where configurations are
#' # available via the environment variable DATABRICKS_CONFIG_FILE or located
#' # at ~/.databrickscfg - simply write
#' db_client <- DatabricksClient()
#' # To check if connection is established
#' open_connection <- db_client$debug_string() != ""
#'
#' if (open_connection) {
#'   databrics_volume <- "/Volumes/amace_cdr_bronze_dev/nn9536_4373_adam/tester"
#'   connector.databricks:::list_file_directory_contents(db_client, databrics_volume)
#' }
#' @importFrom dplyr bind_rows
files_list_directory_contents <- function(directory_path,
                                          page_size = NULL,
                                          page_token = NULL,
                                          full.names = FALSE,
                                          client = DatabricksClient()) {
  checkmate::assert_string(directory_path, null.ok = FALSE)
  checkmate::assert_integer(page_size, null.ok = TRUE)
  checkmate::assert_string(page_token, null.ok = TRUE)
  checkmate::assert_logical(full.names, null.ok = FALSE)
  checkmate::assert_list(client, null.ok = FALSE)

  query <- list(page_size = page_size, page_token = page_token)

  results <- data.frame()
  while (TRUE) {
    json <- client$do("GET",
      paste("/api/2.0/fs/directories", directory_path, sep = ""),
      query = query
    )
    if (is.null(nrow(json$contents))) {
      break
    }
    # append this page of results to one results data.frame
    results <- dplyr::bind_rows(results, json$contents)
    if (is.null(json$next_page_token)) {
      break
    }
    query$page_token <- json$next_page_token
  }

  if (full.names) {
    return(results$path)
  }

  return(results$name)
}

#' Create a directory.
#'
#' Creates an empty directory. If necessary, also creates any parent directories
#' of the new, empty directory (like the shell command `mkdir -p`). If called on
#' an existing directory, returns a success response; this method is idempotent
#' (it will succeed if the directory already exists).
#'
#' @param directory_path The absolute path of a directory.
#' @param client Instance of DatabricksClient()
#'
#' @rdname files_create_directory
files_create_directory <- function(directory_path, client = DatabricksClient()) {
  checkmate::assert_string(directory_path, null.ok = FALSE)
  checkmate::assert_list(client, null.ok = FALSE)

  res <- client$do(
    "PUT",
    paste("/api/2.0/fs/directories", directory_path, sep = "")
  )
  cli::cli_alert_success("Directory created successfully.")
  return(invisible(res))
}

#' Delete a directory.
#'
#' Deletes an empty directory.
#'
#' To delete a non-empty directory, first delete all of its contents. This can
#' be done by listing the directory contents and deleting each file and
#' subdirectory recursively.
#'
#' @param directory_path Required. The absolute path of a directory.
#' @param client Required. Instance of DatabricksClient()
#'
#' @rdname files_delete_directory
files_delete_directory <- function(directory_path, client = DatabricksClient()) {
  checkmate::assert_string(directory_path, null.ok = FALSE)
  checkmate::assert_list(client, null.ok = FALSE)

  res <- client$do(
    "DELETE",
    paste("/api/2.0/fs/directories", directory_path, sep = "")
  )
  cli::cli_alert_success("Directory deleted successfully.")
  return(invisible(res))
}

#' Get directory metadata.
#'
#' Get the metadata of a directory. The response HTTP headers contain the
#' metadata. There is no response body.
#'
#' This method is useful to check if a directory exists and the caller has
#' access to it.
#'
#' If you wish to ensure the directory exists, you can instead use `PUT`, which
#' will create the directory if it does not exist, and is idempotent (it will
#' succeed if the directory already exists).
#' @param client Required. Instance of DatabricksClient()
#'
#' @param directory_path Required. The absolute path of a directory.
#'
#'
#' @rdname files_check_databricks_dir_exists
#' @examplesIf FALSE
#' # In order to connect to databricks on environments where configurations are
#' # available via the environment variable DATABRICKS_CONFIG_FILE or located
#' # at ~/.databrickscfg - simply write
#' db_client <- DatabricksClient()
#' # To check if connection is established
#' open_connection <- db_client$debug_string() != ""
#'
#' if (open_connection) {
#'   databrics_volume <- "/Volumes/amace_cdr_bronze_dev/nn9536_4373_adam/tester"
#'   connector.databricks:::get_file_directory_metadata(db_client, databrics_volume)
#' }
files_check_databricks_dir_exists <- function(directory_path, client = DatabricksClient()) {
  checkmate::assert_string(directory_path, null.ok = FALSE)
  checkmate::assert_list(client, null.ok = FALSE)

  response <- client$do("HEAD",
    paste0("/api/2.0/fs/directories", directory_path),
    return_response_raw = TRUE
  )

  if (httr::status_code(response) == 200) {
    cli::cli_alert_info("Directory exist on databricks")
    return(TRUE)
  }

  if (httr::status_code(response) == 404) {
    return(FALSE) # The directory does not exist.
  }

  FALSE
}

#' Downloads a file of up to 5 GiB. The file contents are the response body.
#' This is a standard HTTP file download, not a JSON RPC.
#'
#' @param file_path Required. The absolute path of the file.
#' @param local_path local path for the file.
#' @param client Required. Instance of DatabricksClient()
#' if \code{NULL} the response from databricks is returned.
#'
#' @rdname files_download_file
#' @returns The repsonse from databricks.
#' If \code{!is.null(local_path)} the response is returned invisible.
files_download_file <- function(file_path,
                                local_path = NULL,
                                client = DatabricksClient()) {
  checkmate::assert_string(file_path, null.ok = FALSE)
  checkmate::assert_string(local_path, null.ok = TRUE)
  checkmate::assert_list(client, null.ok = FALSE)

  response <- client$do("GET", paste("/api/2.0/fs/files", file_path, sep = ""))

  if (!is.null(local_path)) {
    cli::cli_alert_success("File downloaded successfully.")
    writeBin(response, con = local_path)
    return(invisible(response))
  } else {
    return(response)
  }
}

#' Uploads a file of up to 5 GiB. The file contents should be sent as the
#' request body as raw bytes (an octet stream); do not encode or otherwise
#' modify the bytes before sending. The contents of the resulting file will be
#' exactly the bytes sent in the request body. If the request is successful,
#' there is no response body.
#'
#' @param contents File content
#' @param file_path The absolute path of the file.
#' @param overwrite If true, an existing file will be overwritten.
#' @param client Instance of DatabricksClient()
#'
#'
#' @rdname files_upload_file
#'
#' @examplesIf FALSE
#' # In order to connect to databricks on environments where configurations are
#' # available via the environment variable DATABRICKS_CONFIG_FILE or located
#' # at ~/.databrickscfg - simply write
#' db_client <- DatabricksClient()
#'
#' # To check if connection is established
#' open_connection <- db_client$debug_string() != ""
#'
#' if (open_connection) {
#'   tempfile_orig <- tempfile(fileext = ".txt")
#'   writeLines(letters, tempfile_orig)
#'
#'   databrics_volume <- "/Volumes/amace_cdr_bronze_dev/nn9536_4373_adam/tester"
#'   databricks_file <- file.path(databrics_volume, basename(tempfile_orig))
#'
#'   connector.databricks:::upload_file(db_client, databricks_file, contents = tempfile_orig)
#' }
#' @importFrom httr upload_file
files_upload_file <- function(file_path,
                              contents,
                              overwrite = TRUE,
                              client = DatabricksClient()) {
  checkmate::assert_string(file_path, null.ok = FALSE)
  checkmate::assert_logical(overwrite, null.ok = FALSE)
  checkmate::assert_list(client, null.ok = FALSE)
  checkmate::assert_string(contents, null.ok = FALSE)
  checkmate::assert_file_exists(contents)

  contents <- httr::upload_file(path = contents, type = "application/octet-stream")

  query <- list(overwrite = tolower(overwrite))
  req <- client$do(
    "PUT",
    paste("/api/2.0/fs/files", file_path, sep = ""),
    body = contents,
    query = query,
    json_wrap_body = FALSE
  )
  cli::cli_alert_success("File uploaded successfully.")
  return(invisible(req))
}

#' Delete a file.
#'
#' Deletes a file. If the request is successful, there is no response body.
#' @param client Required. Instance of DatabricksClient()
#'
#' @param file_path Required. The absolute path of the file.
#'
#' @rdname files_delete_file
files_delete_file <- function(file_path, client = DatabricksClient()) {
  checkmate::assert_string(file_path, null.ok = FALSE)
  checkmate::assert_list(client, null.ok = FALSE)

  res <- client$do("DELETE", paste("/api/2.0/fs/files", file_path, sep = ""))
  cli::cli_alert_success("File deleted successfully.")
  return(invisible(res))
}
