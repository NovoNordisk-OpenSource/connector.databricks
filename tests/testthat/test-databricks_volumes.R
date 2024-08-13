test_that("databricks volume initialization works", {
  skip_on_ci()
  skip_on_cran()

  testthat::expect_error(Connector_databricks_volumes$new(path = 1))

  testthat::expect_no_error(Connector_databricks_volumes$new(path = setup_db_volume))

  checkmate::assert_r6(
    Connector_databricks_volumes$new(path = setup_db_volume),
    classes = c("Connector_databricks_volumes"),
    public = c(
      "list_content",
      "construct_path",
      "read",
      "write",
      "remove",
      "remove_directory"
    ),
    cloneable = FALSE,
    private = c("path")
  )
})
