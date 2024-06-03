#' Write a file based on this extension
#'
#' @param x Object to write
#' @param file Path to write the file
#' @param ... Other parameters for write functions
#' @param overwrite \code{logical} should the object be overwritten if it already exists
#' @param client a databricks client as returned from \code{DatabricksClient}
#'
#' @return
#' The object \code{x} is returned invisibly
#' @export
#'
#' @examples
#' temp_csv <- tempfile("iris", fileext = ".csv")
#' databrics_volume <- "/Volumes/my_adam/tester"
#' databricks_file_csv <- file.path(databrics_volume, basename(temp_csv))
#' write_fs_databricks(iris, databricks_file_csv)
#'
#' @export
#' @importFrom connector write_file
write_fs_databricks <- function(x, file, ..., overwrite = TRUE,
                                client = DatabricksClient()) {

  # Find extension of file
  find_ext <- tools::file_ext(file)

  # Create temporary file as a placeholder
  temp_file <- tempfile(fileext = paste0(".", find_ext))

  # Write the file to a temporary file
  connector::write_file(x, temp_file, ...)

  # Upload the file to databricks
  res <- upload_file(client, file, contents = temp_file)

  # Clean up
  unlink(temp_file)

  # Return the saved object invisible
  return(invisible(x))
}
