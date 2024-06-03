test_that("write and read to/from data bricks works", {

  temp_rds <- tempfile("iris", fileext = ".rds")
  databrics_volume <- "/Volumes/amace_cdr_bronze_dev/nn9536_4373_adam/tester"
  databricks_file_rds <- file.path(databrics_volume, basename(temp_rds))
  write_fs_databricks(iris, databricks_file_rds)

  new_iris <- read_fs_databricks(databricks_file_rds)

  expect_equal(iris, new_iris)
})
