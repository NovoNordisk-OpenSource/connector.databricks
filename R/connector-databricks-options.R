#' @title Options for connector.databricks
#' @name connector-options-databricks
#' @description
#' Configuration options for the connector.databricks
#' `r zephyr::list_options(as = "markdown", .envir = "connector")`
NULL
#' @title Internal parameters for reuse in functions
#' @name connector-databricks-options-params
#' @eval zephyr::list_options(as = "params", .envir = "connector")
#' @details
#' See [connector-options-databricks] for more information.
#' @keywords internal
NULL
zephyr::create_option(
  name = "overwrite",
  default = zephyr::get_option("overwrite", "connector"),
  desc = "Overwrite existing content if it exists in the connector?"
)
