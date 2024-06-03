#' Create a directory.
#'
#' Creates an empty directory. If necessary, also creates any parent directories
#' of the new, empty directory (like the shell command `mkdir -p`). If called on
#' an existing directory, returns a success response; this method is idempotent
#' (it will succeed if the directory already exists).
#' @param client Required. Instance of DatabricksClient()
#'
#' @param directory_path Required. The absolute path of a directory.
#'
#'
#' @rdname create_file_directory
#' @alias filesCreateDirectory
#' @export
create_file_directory <- function(client, directory_path) {

  client$do("PUT", paste("/api/2.0/fs/directories", directory_path, sep = ""))
}
