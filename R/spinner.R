#' Display a CLI spinner while running a function
#'
#' @param x function to execute in the background. Default: `NULL`
#' @param msg Message to display alongside spinner. Default: `"hello world"`
#' @keywords internal
#' @examples
#' f1 <- function(x) Sys.sleep(2); f1 |> spinner(msg ='hi')
#' @noRd
spinner <- function(x = NULL, msg = "Processing...") {
  # Ensure future plan is properly set for async execution
  future_plan <- future::plan()
  if (inherits(future_plan, "sequential")) {
    future::plan(future::multisession)
  }

  # Start the progress bar with spinner
  cli::cli_progress_bar(
    type = "iterator",
    format = paste0(msg, " {cli::pb_spin}"),
    total = NA
  )

  if (!is.function(x)) {
    cli::cli_progress_done()
    stop("Error: Please pass a function to spinner()")
  }

  # Use future to run the function asynchronously
  future_result <- future::future(
    x(),
    globals = TRUE,
    packages = (.packages()),
    seed = TRUE
  )

  # Check the status and update spinner until done
  while (!future::resolved(future_result)) {
    cli::cli_progress_update(force = TRUE)
    Sys.sleep(0.1) # A shorter sleep time for more responsive spinner
  }

  # Get the result
  tryCatch(
    {
      result <- future::value(future_result)
      cli::cli_progress_done()
      return(result)
    },
    error = function(e) {
      cli::cli_progress_done()
      stop("Error in background process: ", e$message)
    }
  )
}


#' `spinner` wrapper to avoid LHS piority eval imiltations with `|>`
#'
#' This function evaluates an expression while displaying a spinner animation
#' with a custom message.
#'
#' @param expr The expression to evaluate
#' @param msg The message to display alongside the spinner
#' @return The result of evaluating `expr`
#'
#' @examples
#' # Simple delay with spinner
#' with_spinner(Sys.sleep(2), "Waiting for 2 seconds")
#'
#' @noRd
with_spinner <- function(expr, msg = "Processing...") {
  expr_quo <- rlang::enquo(expr)
  expr_func <- function() {
    rlang::eval_tidy(expr_quo)
  }
  result <- spinner(expr_func, msg = msg)
  return(result)
}
