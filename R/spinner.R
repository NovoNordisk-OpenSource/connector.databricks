#' Display a CLI spinner while running a function
#'
#' @param x function to execute in the background. Default: `NULL`
#' @param msg Message to display alongside spinner. Default: `"hello world"`
#' @keywords internal
#' @examples
#' f1 <- function(x) Sys.sleep(2); f1 |> spinner(msg ='hi')
#' @noRd
spinner <- function(x = NULL, msg = "hello world") {
  cli::cli_progress_step(msg, spinner = TRUE)

  if (is.function(x)) {
    thread <- callr::r_bg(
      function(func) func(),
      args = list(func = x)
    )

    while (thread$is_alive()) {
      Sys.sleep(0.42)
      cli::cli_progress_update()
    }

    cli::cli_progress_done()
    return(thread$get_result())
  } else {
    errorCondition("pass a named function x")
  }
  cli::cli_progress_done()
  return(x)
}
