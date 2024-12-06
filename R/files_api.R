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
