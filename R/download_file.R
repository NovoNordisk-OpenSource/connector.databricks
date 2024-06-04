#' Downloads a file of up to 5 GiB. The file contents are the response body.
#' This is a standard HTTP file download, not a JSON RPC.
#'
#' @param client Required. Instance of DatabricksClient()
#' @param file_path Required. The absolute path of the file.
#' @param local_path local path for the file.
#' if \code{NULL} the response from databricks is returned.
#'
#' @rdname download_file
#' @returns The repsonse from databricks.
#' If \code{!is.null(local_path)} the response is returned invisible.
download_file <- function(client, file_path, local_path = NULL) {

  response <- client$do("GET", paste("/api/2.0/fs/files", file_path, sep = ""))

  if (!is.null(local_path)) {
    writeBin(response, con = local_path)
    return(invisible(response))
  } else {
    return(response)
  }
}
