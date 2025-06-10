#' @title Options for connector.databricks
#' @name connector-options-databricks
#' @description
#' Configuration options for the connector.databricks
#' `r zephyr::list_options(as = "markdown", .envir = "connector.databricks")`
NULL

#' @title Internal parameters for reuse in functions
#' @name connector-databricks-options-params
#' @eval zephyr::list_options(as = "params", .envir = "connector.databricks")
#' @details
#' See [connector-options-databricks] for more information.
#' @keywords internal
NULL

zephyr::create_option(
  name = "overwrite",
  default = zephyr::get_option("overwrite", "connector"),
  desc = "Overwrite existing content if it exists in the connector?"
)

zephyr::create_option(
  name = "verbosity_level",
  default = zephyr::get_option("overwrite", "connector"),
  desc = "Verbosity level for functions in connector. See [zephyr::verbosity_level] for details."
)
