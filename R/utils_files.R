#' Read files based on the extension
#'
#' The aim of this function is to identify the extension on the file to dispatch it.
#'
#' @param path Path to the file
#' @param client a databricks client as returned from \code{DatabricksClient}
#'
#' @export
#' @rdname write_fs_databricks
#'
#' @importFrom connector read_file
#'
#' @examplesIf FALSE
#' temp_csv <- tempfile("iris", fileext = ".csv")
#' databrics_volume <- "/Volumes/amace_cdr_bronze_dev/nn9536_4373_adam/tester"
#' databricks_file_csv <- file.path(databrics_volume, basename(temp_csv))
#' try(write_fs_databricks(iris, databricks_file_csv))
#'
#' # Read the file from databricks
#' try(read_fs_databricks(databricks_file_csv))
#'
#' @return the result of the reading function
read_fs_databricks <- function(path, client = DatabricksClient()) {
  checkmate::assert_string(path, null.ok = FALSE)
  checkmate::assert_list(client, null.ok = FALSE)

  # Find extension of file
  find_ext <- tools::file_ext(path)

  # Create temporary file as a placeholder
  temp_file <- tempfile(fileext = paste0(".", find_ext))

  # Download file from databricks to local temp_file
  files_download_file(file_path = path, local_path = temp_file, client = client)

  # Read the downloaded file
  x <- connector::read_file(temp_file)

  # delete the temporary file
  unlink(temp_file)

  return(x)
}

#' Write a file based on this extension
#'
#' @param x Object to write
#' @param file Path to write the file
#' @param ... Other parameters for write functions
#' @param overwrite \code{logical} should the object be overwritten if it already exists
#' @param client a databricks client as returned from \code{DatabricksClient}
#'
#' @export
#' @rdname write_fs_databricks
#'
#' @importFrom connector write_file
#' @importFrom tools file_ext
#'
#' @examplesIf FALSE
#' temp_csv <- tempfile("iris", fileext = ".csv")
#' databrics_volume <- "/Volumes/amace_cdr_bronze_dev/nn9536_4373_adam/tester"
#' databricks_file_csv <- file.path(databrics_volume, basename(temp_csv))
#' try(write_fs_databricks(iris, databricks_file_csv))
#'
#' @return The object \code{x} is returned invisibly
write_fs_databricks <- function(x, file, ..., overwrite = TRUE,
                                client = DatabricksClient()) {
  checkmate::assert_string(file, null.ok = FALSE)
  checkmate::assert_logical(overwrite, null.ok = FALSE)
  checkmate::assert_list(client, null.ok = FALSE)


  # Find extension of file
  find_ext <- tools::file_ext(file)

  # Create temporary file as a placeholder
  temp_file <- tempfile(fileext = paste0(".", find_ext))

  # Write the file to a temporary file
  connector::write_file(x, temp_file, ...)

  # Upload the file to databricks
  res <- files_upload_file(file_path = file, contents = temp_file)

  # Clean up
  unlink(temp_file)

  # if the length of res is positive a mistake may have occurred
  # and the object is printed for debugging
  if (length(res) > 0) {
    print(res)
  }

  # Return the saved object invisible
  return(invisible(x))
}

#' Find File
#'
#' @param name Name of a file
#' @param root Path to the root folder
#' @param client DatabricksClient
#'
#' @examplesIf FALSE
#' iris_csv <- "iris.csv"
#' databrics_volume <- "/Volumes/amace_cdr_bronze_dev/nn9536_4373_adam/tester"
#' databricks_file_csv <- file.path(databrics_volume, iris_csv)
#' write_fs_databricks(iris, databricks_file_csv)
#' connector.databricks:::find_file_databricks("iris", root = databrics_volume)
#'
#' @return A full name path to the file or a error if multiples files or 0.
find_file_databricks <- function(name, root, client = DatabricksClient()) {
  checkmate::assert_string(name, null.ok = FALSE)
  checkmate::assert_string(root, null.ok = FALSE)
  checkmate::assert_list(client, null.ok = FALSE)

  all_files <- files_list_directory_contents(client = client, directory_path = root)

  files <- grep(pattern = paste0("^", name, "(\\.|$)"), all_files)

  if (length(files) == 1) {
    return(all_files[files])
  } else if (length(files) == 0) {
    stop("No file found")
  } else {
    stop("Multiple files found with the same name")
  }
}
