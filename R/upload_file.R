#' Uploads a file of up to 5 GiB. The file contents should be sent as the
#' request body as raw bytes (an octet stream); do not encode or otherwise
#' modify the bytes before sending. The contents of the resulting file will be
#' exactly the bytes sent in the request body. If the request is successful,
#' there is no response body.
#' @param client Required. Instance of DatabricksClient()
#'
#' @param contents This field has no description yet.
#' @param file_path Required. The absolute path of the file.
#' @param overwrite If true, an existing file will be overwritten.
#'
#'
#' @rdname upload_file
#' @alias filesUpload
#' @export
upload_file <- function(client, file_path, contents, overwrite = TRUE) {

  if (is.character(contents))
    contents <-
      httr::upload_file(path = contents, type = "application/octet-stream")

  query <- list(overwrite = tolower(overwrite))
  client$do("PUT", paste("/api/2.0/fs/files", file_path, sep = ""),
            body = contents,
            query = query, json_wrap_body = FALSE)
}

#' @rdname upload_file
#' @export
filesUpload <- upload_file

