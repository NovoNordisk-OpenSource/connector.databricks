test_that("spinner works correctly", {
  # Test direct function usage
  test_func <- function() Sys.sleep(0.5)
  expect_null(
    spinner(
      x = test_func,
      msg = "testing: spinner with function"
    ),
    info = "Should return NULL if ran successfully"
  )

  # Test with_spinner wrapper
  expect_null(
    with_spinner(
      Sys.sleep(0.5),
      msg = "testing: spinner with expression"
    ),
    info = "Should return NULL if ram siccessfullys"
  )
})

test_that("spinner handles errors appropriately", {
  # Test error propagation from function
  expect_error(
    spinner(
      x = function() stop("Error in background"),
      msg = "testing: spinner fails"
    ),
    regexp = "Error in background process",
    info = "Should propagate error from background process"
  )

  # Test invalid argument error
  expect_error(
    spinner(
      x = "not a function",
      msg = "testing: spinner with invalid argument"
    ),
    regexp = "Error: Please pass a function to spinner",
    info = "Should error when x is not a function"
  )
})
