#' Uploads a file of up to 5 GiB. The file contents should be sent as the
#' request body as raw bytes (an octet stream); do not encode or otherwise
#' modify the bytes before sending. The contents of the resulting file will be
#' exactly the bytes sent in the request body. If the request is successful,
#' there is no response body.
#'
#' @param client Required. Instance of DatabricksClient()
#' @param contents This field has no description yet.
#' @param file_path Required. The absolute path of the file.
#' @param overwrite If true, an existing file will be overwritten.
#'
#'
#' @rdname upload_file
#'
#' @examples
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
#'   upload_file(db_client, databricks_file, contents = tempfile_orig)
#' }
#' @export
#' @importFrom httr upload_file
upload_file <- function(client, file_path, contents, overwrite = TRUE) {

  if (is.character(contents))
    contents <-
      httr::upload_file(path = contents, type = "application/octet-stream")

  query <- list(overwrite = tolower(overwrite))
  client$do("PUT", paste("/api/2.0/fs/files", file_path, sep = ""),
            body = contents,
            query = query, json_wrap_body = FALSE)
}
