test_that("spinner works", {
  expect_null(
    with_spinner(
      x = function() Sys.sleep(4.54),
      msg = "testing: spinner works"
    ),
    info = "Should return NULL when process completes successfully"
  )
})

test_that("spinner fails", {
  expect_error(
    spinner(
      x = function() stop("Error"),
      msg = "testing: spinner fails"
    ),
    regexp = "Error",
    info = "Should propagate error from background process"
  )
})
