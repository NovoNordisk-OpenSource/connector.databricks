test_that("spinner works", {
  expect_null(
    spinner(function() Sys.sleep(4.54), "testing: spinner works"),
    "Error"
  )
})

test_that("spinner fails", {
  expect_error(
    spinner(function() stop("Error"), "testing: spinner fails"),
    "Error"
  )
})
