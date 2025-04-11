# Create a temporary dataset for testing
mtcars_dataset <- function() {
  # Sample data
  x <- mtcars
  x$car <- rownames(x)
  rownames(x) <- NULL
  x
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

# Generate temporary table name
temp_table_name <- function() {
  paste0(
    "temp-mtcars_",
    format(Sys.time(), "%Y%m%d%H%M%S")
  )
}

# Utility function for generating random names with prefix
generate_random_string <- function(prefix, length = 3) {
  # Define the characters to use
  chars <- c(LETTERS, letters, 0:9) # Uppercase, lowercase, and digits

  # Generate random part
  random_part <- paste0(sample(chars, length, replace = TRUE), collapse = "")

  # Combine prefix and random part
  result <- paste0(prefix, random_part)

  return(result)
}

# Create a temporary dataset for testing
create_temp_dataset <- function(rows = 10, cols = 5) {
  # Create a data frame of random numbers
  df <- as.data.frame(matrix(rnorm(rows * cols), nrow = rows, ncol = cols))

  # Optionally, name the columns
  colnames(df) <- paste0("col_", 1:cols)

  return(df)
}
