#' Display a CLI spinner while running a function
#'
#' @param x function to execute in the background. Default: `NULL`
#' @param msg Message to display alongside spinner. Default: `"Processing..."`
#' @keywords internal
#' @examples
#' f1 <- function(x) {Sys.sleep(2);return(1)} ; f1 |> spinner(msg ='hi')
#' @noRd
spinner <- function(x = NULL, msg = "Processing...") {
  if (!is.function(x)) {
    stop("Error: Please pass a function to spinner()")
  }
  plan(mirai_multisession)
  cli::cli_progress_bar(
    type = "iterator",
    format = paste0(msg, " {cli::pb_spin}"),
    total = NA
  )
  m <- mirai::mirai(
    func(),
    func = x,
    .packages = (.packages())
  )
  while (mirai::unresolved(m)) {
    cli::cli_progress_update(force = TRUE)
    Sys.sleep(0.1)
  }
  plan(sequential)
  cli::cli_progress_done()

  if (inherits(m$data, "miraiError")) {
    stop(m$data)
  }
  return(m$data)
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
