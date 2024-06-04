#' Find File
#'
#' @param name Name of a file
#' @param root Path to the root folder
#' @param client DatabricksClient
#'
#' @examples
#' iris_csv <- "iris.csv"
#' databrics_volume <- "/Volumes/my_adam/tester"
#' databricks_file_csv <- file.path(databrics_volume, iris_csv)
#' write_fs_databricks(iris, databricks_file_csv)
#' connector.databricks:::find_file_databricks("iris", root = databrics_volume)
#'
#' @return A full name path to the file or a error if multiples files or 0.
find_file_databricks <- function(name, root, client = DatabricksClient()) {

  all_files <- list_file_directory_contents(client = client, directory_path = root)

  files <- grep(pattern = paste0("^", name, "(\\.|$)"), all_files$name)

  if (length(files) == 1) {
    return(all_files$path[files])
  } else if (length(files) == 0) {
    stop("No file found")
  } else {
    stop("Multiple files found with the same name")
  }
}
