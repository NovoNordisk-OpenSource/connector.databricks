working_databrick_client <- function(client) {
  # If no connection have been made
  if (client$debug_string() == "") {
    return(FALSE)
  }

  res <- client$do("GET", "/api/2.0/preview/scim/v2/Me")

  res$userName != ""
}
