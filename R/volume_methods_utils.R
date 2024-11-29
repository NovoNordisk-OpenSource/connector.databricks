#' Download content from Databricks volume
#'
#' @description It use the [files_download_file()] method to download a file
#' from a Databricks volume
#'
#' @param connector_object The [ConnectorDatabricksVolume] object
#' @param name The name of the file to download
#' @param dest The destination of the file
#' @param ... Additional parameters to pass to the download method
#'
#' @return Response from the request
#' @export
#'
#' @examplesIf FALSE
#' # databricks_volume is a ConnectorDatabricksVolume object
#' databricks_volume %>%
#'   download_cnt("file.csv", "file.csv")
#'
#' # This function is used by the method download_content
#' databricks_volume$download_content("file.csv", "file.csv")
#'
download_cnt <- function(connector_object, name, dest, ...) {
  file_path <- file.path(connector_object$full_path, name)
  files_download_file(file_path = file_path, local_path = dest, ...)
}

#' Upload content to ConnectorDatabricksVolume
#'
#' @param connector_object The [ConnectorDatabricksVolume] object
#' @param src The source of the file to upload
#' @param dest The destination of the file
#' @param overwrite Overwrite file if already exists
#' @param ... Additional parameters to pass to the upload method
#'
#' @return Information about success of the request
#' @export
#'
#' @examplesIf FALSE
#' # databricks_volume is a ConnectorDatabricksVolume object
#' databricks_volume %>%
#'   upload_cnt("file.csv", "file.csv")
#'
#' # This function is used by the method upload_content
#' databricks_volume$upload_content("file.csv", "file.csv")
upload_cnt <- function(connector_object,
                       src,
                       dest,
                       overwrite,
                       ...) {
  file_path <- file.path(connector_object$full_path, dest)
  files_upload_file(file_path = file_path, contents = src, ...)
}

#' Create a directory
#'
#' @param connector_object The [ConnectorDatabricksVolume] object
#' @param name The name of the directory to create
#' @param ... Additional parameters to pass to the files_create_directory method
#'
#' @return New [ConnectorDatabricksVolume] object of a newly built directory
#' @export
#'
#' @examplesIf FALSE
#' # databricks_volume is a ConnectorDatabricksVolume object
#' new_connector <- databricks_volume %>%
#'   create_directory_cnt("folder")
#' # This function is used by the method create_directory
#' new_connector <- databricks_volume$create_directory("folder")
create_directory_cnt <- function(connector_object, name, ...) {
  directory_path <- file.path(connector_object$full_path, name)
  files_create_directory(directory_path = directory_path, ...)
  return(invisible(connector_databricks_volume(
    full_path = paste0(connector_object$full_path, name)
  )))
}

#' Remove a directory
#'
#' @param connector_object The [ConnectorDatabricksVolume] object
#' @param name The name of the directory to create
#' @param ... Additional parameters to pass to the files_create_directory method
#'
#' @export
#'
#' @examplesIf FALSE
#' # databricks_volume is a ConnectorDatabricksVolume object
#' databricks_volume %>%
#'   create_directory_cnt("folder")
#'
#' # This function is used by the method create_directory
#' databricks_volume$create_directory("folder")
remove_directory_cnt <- function(connector_object, name, ...) {
  directory_path <- file.path(connector_object$full_path, name)
  files_delete_directory(directory_path = directory_path, ...)
}
