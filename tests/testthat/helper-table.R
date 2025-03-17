# Create a temporary dataset for testing
create_temp_dataset <- function() {
  # Sample data
  x <- mtcars
  x$car <- rownames(x)
  rownames(x) <- NULL
  return(x)
}

# in DBI::dbGetQuery the - characters in arguments are being interpreted as minus operators
# quoting it with back-quotes to mask the - character
# Custom paste function to add back quotes to individual strings
custom_paste_with_back_quotes <- function(..., sep = " ") {
  args <- list(...)
  quoted_args <- lapply(args, function(arg) {
    if (is.character(arg)) {
      paste0("`", arg, "`")
    } else {
      as.character(arg)
    }
  })
  paste(quoted_args, collapse = sep)
}
