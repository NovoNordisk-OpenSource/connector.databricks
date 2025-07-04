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

  future::plan(future.mirai::mirai_multisession)
  cli::cli_progress_bar(
    type = "iterator",
    format = paste0(msg, " {cli::pb_spin}"),
    total = NA
  )

  m <- mirai::mirai(
    func(),
    func = x,
    .globals = TRUE,
    .packages = (.packages())
  )

  while (mirai::unresolved(m)) {
    cli::cli_progress_update(force = TRUE)
    Sys.sleep(0.1)
  }

  future::plan(future::sequential)
  cli::cli_progress_done()

  if (inherits(m$data, "miraiError")) {
    stop(m$data)
  }
  m$data
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
#' with_spinner({Sys.sleep(2);Sys.sleep(1);Sys.sleep(1);Sys.sleep(1);Sys.sleep(1)}, "Waiting for 6 seconds")
#'
#' @noRd
with_spinner <- function(expr, msg = "Processing...") {
  spinner(
    function() {
      eval(substitute(expr), envir = parent.frame())
    },
    msg = msg
  )
}
