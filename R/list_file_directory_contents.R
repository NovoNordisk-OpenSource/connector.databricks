#' List directory contents.
#'
#' Returns the contents of a directory. If there is no directory at the
#' specified path, the API returns a HTTP 404 error.
#' @param client Required. Instance of DatabricksClient()
#'
#' @param directory_path Required. The absolute path of a directory.
#' @param page_size The maximum number of directory entries to return.
#' @param page_token An opaque page token which was the `next_page_token` in the response of the previous request to list the contents of this directory.
#'
#' @return `data.frame` with all of the response pages.
#'
#'
#' @rdname list_file_directory_contents
#' @examples
#' # In order to connect to databricks on environments where configurations are
#' # available via the environment variable DATABRICKS_CONFIG_FILE or located
#' # at ~/.databrickscfg - simply write
#' db_client <- DatabricksClient()
#' # To check if connection is established
#' system.time(a <- db_client$do("GET", "/api/2.0/preview/scim/v2/Me"))
#' open_connection <- db_client$debug_string() != ""
#'
#' if (open_connection) {
#'   databrics_volume <- "/Volumes/my_adam/tester"
#'   list_file_directory_contents(db_client, databrics_volume)
#' }
#'
#' @export
#' @importFrom dplyr bind_rows
list_file_directory_contents <- function(client, directory_path, page_size = NULL,
                                         page_token = NULL) {
  query <- list(page_size = page_size, page_token = page_token)

  results <- data.frame()
  while (TRUE) {
    json <- client$do("GET", paste("/api/2.0/fs/directories", directory_path,
                                   sep = ""), query = query)
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
  return(results)
}
