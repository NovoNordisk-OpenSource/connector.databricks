#' Methods for the databricks class
#'
#' @param connector_object The databricks object
#' @param ... Additional parameters to pass to the delete method
#'
#' @rdname connector_methods
#' @export
cnt_list_content.Connector_databricks <- function(connector_object) {
  catalog <- connector_object$catalog
  schema <- connector_object$schema
  tables <- DBI::dbGetQuery(connector_object$sc, glue::glue("SHOW TABLES IN {catalog}.{schema}"))
  return(tables)
}

#' @rdname connector_methods
#' @param name The name of the file to read
#' @param ... Additional parameters to pass to the read_microsoft_file function
#'
#' @export
cnt_read.Connector_databricks <- function(connector_object, name, ...) {
  connector_object$sc %>%
    dplyr::tbl(name, ...) %>%
    dplyr::collect()
}

#' @rdname connector_methods
#' @param x The content to write
#' @param file The name of the file to write
#' @param ... Additional parameters to pass to the write_microsoft_file function
#' @export
cnt_write.Connector_databricks <- function(connector_object, x, file, ...) {
  connector_object$sc %>%
    dplyr::copy_to(x, file)
}
