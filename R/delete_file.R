#' Delete a file.
#'
#' Deletes a file. If the request is successful, there is no response body.
#' @param client Required. Instance of DatabricksClient()
#'
#' @param file_path Required. The absolute path of the file.
#'
#' @rdname delete_file
delete_file <- function(client, file_path) {
  client$do("DELETE", paste("/api/2.0/fs/files", file_path, sep = ""))
}

delete_volume_file <- function(file_path, client = DatabricksClient()) {
  delete_file(client = client, file_path)
}
