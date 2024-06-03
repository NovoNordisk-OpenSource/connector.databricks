#' Delete a directory.
#'
#' Deletes an empty directory.
#'
#' To delete a non-empty directory, first delete all of its contents. This can
#' be done by listing the directory contents and deleting each file and
#' subdirectory recursively.
#' @param client Required. Instance of DatabricksClient()
#'
#' @param directory_path Required. The absolute path of a directory.
#'
#'
#' @rdname delete_file_directory
#' @export
delete_file_directory <- function(client, directory_path) {

  client$do("DELETE", paste("/api/2.0/fs/directories", directory_path, sep = ""))
}
