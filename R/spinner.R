#' Display a CLI spinner while running a function
#'
#' @param process_func Function to execute in the background. Default: `NULL`
#' @param msg Message to display alongside spinner. Default: `"hello world"`
#' @keywords internal
#' @examples
#' result <- spinner(function() Sys.sleep(4.54), "Running f1 (4 second sleep)")
#' @noRd
spinner <- function(process_func = NULL, msg = "hello world") {
  cli_progress_step(msg, spinner = TRUE)
  if (is.function(process_func)) {
    thread <- callr::r_bg(\() process_func())
    while (thread$is_alive()) {
      Sys.sleep(0.42)
      cli_progress_update()
    }
    cli_progress_done()
    return(thread$get_result())
  }
}
