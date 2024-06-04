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
#' @rdname get_file_directory_metadata
#' @examples
#' # In order to connect to databricks on environments where configurations are
#' # available via the environment variable DATABRICKS_CONFIG_FILE or located
#' # at ~/.databrickscfg - simply write
#' db_client <- DatabricksClient()
#' # To check if connection is established
#' open_connection <- db_client$debug_string() != ""
#'
#' if (open_connection) {
#'   databrics_volume <- "/Volumes/amace_cdr_bronze_dev/nn9536_4373_adam/tester"
#'   get_file_directory_metadata(db_client, databrics_volume)
#' }
#'
#' @export
get_file_directory_metadata <- function(client, directory_path) {


  response <- client$do("HEAD",
                        paste0("/api/2.0/fs/directories", directory_path),
                        return_response_raw = TRUE)

  if (httr::status_code(response) == 200) {
    return(TRUE) # The directory exists.
  }

  if (httr::status_code(response) == 404) {
    return(FALSE) # The directory does not exist.
  }

  FALSE
}


check_databricks_dir_exists <- function(x, client = DatabricksClient()) {
  # check functions must return TRUE on success
  # and a custom error message otherwise
  res <- get_file_directory_metadata(client = client, x)
  if (!isTRUE(res))
    return("Directory must exist on databricks")
  return(TRUE)
}

#' @importFrom checkmate makeAssertCollection
assert_databricks_dir_exists <-
  checkmate::makeAssertionFunction(check_databricks_dir_exists)

#' Validate the path
#'
#' @description The assert_path function validates the path for file system operations.
#'
#' @param path Path to be validated
#'
#' @return Invisible path
#'
#' @export
#'
#' @importFrom checkmate makeAssertCollection assert_character reportAssertions
assert_databicks_path <- function(path) {
  val <- checkmate::makeAssertCollection()

  checkmate::assert_character(
    x = path,
    len = 1,
    any.missing = FALSE,
    add = val
  )

  assert_databricks_dir_exists(
    x = path,
    add = val
  )

  checkmate::reportAssertions(
    val
  )

  return(
    invisible(path)
  )
}
