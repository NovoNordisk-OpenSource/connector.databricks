#' List Databricks volumes
#'
#' Returns list of Databricks volume.
#'
#' @details
#' More details can be found here:
#' https://docs.databricks.com/api/workspace/volumes/list
#'
#' @param catalog_name The name of the catalog where the schema and the volume
#' are.
#' @param schema_name The name of the schema where the volume will be created.
#' @param max_results Maximum number of volumes to return (page length).
#' More info on the parameter can be found here:
#' https://docs.databricks.com/api/workspace/volumes/list#max_results
#' @param page_token Opaque token returned by a previous request. It must be
#' included in the request to retrieve the next page of results (pagination).
#' @param include_browse Whether to include volumes in the response for which
#' the principal can only access selective metadata for
#' @param client Instance of DatabricksClient().
#'
#' @return Data.frame with information about available volumes.
#'
#' @examplesIf FALSE
#' # In order to connect to databricks on environments where configurations are
#' # available via the environment variable DATABRICKS_CONFIG_FILE or located
#' # at ~/.databrickscfg - simply write
#' db_client <- DatabricksClient()
#' # To check if connection is established
#' open_connection <- db_client$debug_string() != ""
#'
#' if (open_connection) {
#'   connector.databricks::list_databricks_volumes(db_client,
#'     catalog_name = "amace_cdr_bronze_dev",
#'     schema_name = "nn9536_4373_adam1"
#'   )
#' }
#'
#' @importFrom checkmate assert_list assert_string assert_numeric assert_logical
#' @importFrom dplyr bind_rows
#' @importFrom cli cli_abort
#'
#' @export
list_databricks_volumes <- function(catalog_name,
                                    schema_name,
                                    max_results = 100,
                                    page_token = NULL,
                                    include_browse = FALSE,
                                    client = DatabricksClient()) {
  checkmate::assert_list(client, null.ok = FALSE)
  checkmate::assert_string(x = catalog_name, null.ok = FALSE)
  checkmate::assert_string(x = schema_name, null.ok = FALSE)
  checkmate::assert_numeric(x = max_results, null.ok = FALSE)
  checkmate::assert_string(x = page_token, null.ok = TRUE)
  checkmate::assert_logical(x = include_browse, null.ok = TRUE)

  query <- list(
    catalog_name = catalog_name,
    schema_name = schema_name,
    max_results = max_results,
    page_token = page_token,
    include_browse = include_browse
  )

  results <- data.frame()
  while (TRUE) {
    result <- client$do("GET", path = "/api/2.1/unity-catalog/volumes", query = query)
    if (is.null(nrow(result$volumes))) {
      cli::cli_abort("No volumes found!")
    }
    # append this page of results to one results data.frame
    results <- dplyr::bind_rows(results, result$volumes)
    if (is.null(result$next_page_token)) {
      break
    }
    query$page_token <- result$next_page_token
  }
  return(results)
}

#' Create Databricks volume
#'
#' Returns the newly built Databricks volume.
#'
#' @details
#' More details can be found here:
#' https://docs.databricks.com/api/workspace/volumes/create
#'
#' @param name Required. Name of a new volume
#' @param catalog_name The name of the catalog where the schema and the volume
#' are.
#' @param schema_name The name of the schema where the volume will be created.
#' @param client Instance of DatabricksClient().
#'
#' @examplesIf FALSE
#' # In order to connect to databricks on environments where configurations are
#' # available via the environment variable DATABRICKS_CONFIG_FILE or located
#' # at ~/.databrickscfg - simply write
#' db_client <- DatabricksClient()
#' # To check if connection is established
#' open_connection <- db_client$debug_string() != ""
#'
#' if (open_connection) {
#'   connector.databricks::get_databricks_volume(
#'     name = "new_volume",
#'     catalog_name = "amace_cdr_bronze_dev",
#'     schema_name = "nn9536_4373_adam"
#'   )
#' }
#' @importFrom checkmate assert_string assert_list
#' @importFrom cli cli_alert_success
#'
#' @export
create_databricks_volume <- function(name,
                                     catalog_name = NULL,
                                     schema_name = NULL,
                                     volume_type = c("MANAGED", "EXTERNAL)"),
                                     storage_location = NULL,
                                     comment = NULL,
                                     client = DatabricksClient()) {
  checkmate::assert_list(client, null.ok = FALSE)
  checkmate::assert_string(x = name, null.ok = FALSE)
  checkmate::assert_string(x = catalog_name, null.ok = TRUE)
  checkmate::assert_string(x = schema_name, null.ok = TRUE)
  volume_type <- match.arg(volume_type)
  checkmate::assert_string(x = storage_location, null.ok = TRUE)
  checkmate::assert_string(x = comment, null.ok = TRUE)

  query <- list(
    name = name,
    catalog_name = catalog_name,
    schema_name = schema_name,
    volume_type = volume_type,
    storage_location = storage_location,
    comment = comment
  )

  result <- client$do("POST", path = "/api/2.0/unity-catalog/volumes", query = query)

  cli::cli_alert_success("Volume successfully created!")

  return(invisible(result))
}

#' Delete Databricks volume
#'
#' Deletes a volume from the specified parent catalog and schema.
#'
#' @details
#' More details can be found here:
#' https://docs.databricks.com/api/workspace/volumes/delete
#'
#' @param name Name of a new volume
#' @param catalog_name The name of the catalog where the schema and the volume
#' are.
#' @param schema_name The name of the schema where the volume will be created.
#' @param client Instance of DatabricksClient().
#'
#' @examplesIf FALSE
#' # In order to connect to databricks on environments where configurations are
#' # available via the environment variable DATABRICKS_CONFIG_FILE or located
#' # at ~/.databrickscfg - simply write
#' db_client <- DatabricksClient()
#' # To check if connection is established
#' open_connection <- db_client$debug_string() != ""
#'
#' if (open_connection) {
#'   connector.databricks::delete_databricks_volume(
#'     client = db_client,
#'     name = "new_volume",
#'     catalog_name = "amace_cdr_bronze_dev",
#'     schema_name = "nn9536_4373_adam"
#'   )
#' }
#'
#' @importFrom checkmate assert_list assert_string
#' @importFrom cli cli_alert_success
#'
#' @export
delete_databricks_volume <- function(name,
                                     catalog_name = NULL,
                                     schema_name = NULL,
                                     client = DatabricksClient()) {
  checkmate::assert_list(client, null.ok = FALSE)
  checkmate::assert_string(x = name, null.ok = FALSE)
  checkmate::assert_string(x = catalog_name, null.ok = TRUE)
  checkmate::assert_string(x = schema_name, null.ok = TRUE)

  volume_path <- paste(c(catalog_name, schema_name, name), collapse = ".")
  result <- client$do("DELETE",
                      path = paste0("/api/2.0/unity-catalog/volumes/", volume_path))

  cli::cli_alert_success("Volume successfully deleted!")
  return(invisible(NULL))
}

#' Get Databricks volume
#'
#' Gets a volume from the specified parent catalog and schema.
#'
#' @details
#' More details can be found here:
#' https://docs.databricks.com/api/workspace/volumes/get
#'
#' @param name Name of a new volume
#' @param catalog_name The name of the catalog where the schema and the volume
#' are.
#' @param schema_name The name of the schema where the volume will be created.
#' @param client Instance of DatabricksClient().
#'
#' @examplesIf FALSE
#' # In order to connect to databricks on environments where configurations are
#' # available via the environment variable DATABRICKS_CONFIG_FILE or located
#' # at ~/.databrickscfg - simply write
#' db_client <- DatabricksClient()
#' # To check if connection is established
#' open_connection <- db_client$debug_string() != ""
#'
#' if (open_connection) {
#'   connector.databricks::get_databricks_volume(
#'     client = db_client,
#'     name = "new_volume",
#'     catalog_name = "amace_cdr_bronze_dev",
#'     schema_name = "nn9536_4373_adam"
#'   )
#' }
#'
#' @importFrom checkmate assert_list assert_string
#'
#' @export
get_databricks_volume <- function(name,
                                  catalog_name,
                                  schema_name,
                                  client = DatabricksClient()) {
  checkmate::assert_list(client, null.ok = FALSE)
  checkmate::assert_string(x = name, null.ok = FALSE)
  checkmate::assert_string(x = catalog_name, null.ok = FALSE)
  checkmate::assert_string(x = schema_name, null.ok = FALSE)

  volume_path <- paste(c(catalog_name, schema_name, name), collapse = ".")
  result <- client$do("GET",
                      path = paste0("/api/2.0/unity-catalog/volumes/", volume_path))

  return(result)
}
