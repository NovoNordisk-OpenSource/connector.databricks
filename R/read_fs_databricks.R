#' Read files based on the extension
#'
#' The aim of this function is to identify the extension on the file to dispatch it.
#'
#' @param path Path to the file
#' @param ... Other parameters for read's functions
#' @param client a databricks client as returned from \code{DatabricksClient}
#'
#' @return the result of the reading function
#'
#'
#' @examples
#' temp_csv <- tempfile("iris", fileext = ".csv")
#' databrics_volume <- "/Volumes/my_adam/tester"
#' databricks_file_csv <- file.path(databrics_volume, basename(temp_csv))
#' write_fs_databricks(iris, databricks_file_csv)
#'
#' # Read the file from databricks
#' read_fs_databricks(databricks_file_csv)
#' @export
#' @importFrom connector read_file
read_fs_databricks <- function(path, ..., client = DatabricksClient()) {

  # Find extension of file
  find_ext <- tools::file_ext(path)

  # Create temporary file as a placeholder
  temp_file <- tempfile(fileext = paste0(".", find_ext))

  # Download file from databricks to local temp_file
  download_file(client, path, local_path = temp_file)

  # Read the downloaded file
  x <- connector::read_file(temp_file)

  # delete the temporary file
  unlink(temp_file)

  return(x)
}
