#' Utility function used as a private function for [ConnectorDatabricksVolume]
#' object to check if volume already exists, if not it will prompt user to
#' create a new one.
#'
#' @param catalog [character] The name of the catalog
#' @param schema [character] The name of the schema
#' @param volume [character] The name of the volume to create
#' @param force [boolean] If TRUE, the volume will be created without asking
#'
#' @keywords internal
#' @noRd
check_databricks_volume_exists <- function(
  catalog,
  schema,
  volume,
  force = FALSE
) {
  {
    #{
    tryCatch(
      {
        brickster::db_uc_volumes_get(
          volume = volume,
          catalog = catalog,
          schema = schema
        )

        return(NULL)
      },
      error = function(e) {
        if (force) {
          invisible(
            brickster::db_uc_volumes_create(
              volume = volume,
              catalog = catalog,
              schema = schema
            )
          )
          return(NULL)
        }
        menu <- menu(
          c("Create volume", "Exit"),
          title = "Volume does not exist. What would you like to do?"
        )
        if (menu == 1) {
          zephyr::msg_info("Creating volume {catalog}/{schema}/{volume}...")
          {
            invisible(brickster::db_uc_volumes_create(
              volume = volume,
              catalog = catalog,
              schema = schema
            ))
          } |>
            with_spinner("Creating  volume")
          zephyr::msg_info("Volume created!")
        } else {
          cli::cli_abort("Exiting...")
        }
      }
    )
    return(NULL)
  }
  #} |>
  #  with_spinner("Creating volume")
}

#' Utility function for recursive removal of directory
#' @param dir_path Full directory path in Volume
#' @noRd
remove_directory <- function(dir_path) {
  checkmate::assert_string(dir_path)

  if (!directory_exists(dir_path)) {
    cli::cli_abort("Directory does not exist at {.path {dir_path}}")
  }

  dir_content <- brickster::db_volume_list(path = dir_path)
  dir_content_names <- sapply(dir_content$contents, "[[", "name")
  for (content in dir_content_names) {
    item_path <- paste0(dir_path, "/", content)
    if (directory_exists(path = item_path)) {
      remove_directory(item_path)

      next
    }
    {
      brickster::db_volume_delete(path = item_path)
    } |>
      with_spinner("Remove directory for volume")
  }

  brickster::db_volume_dir_delete(dir_path)

  zephyr::msg_success("{.path {dir_path}} successfully deleted")
}

#' Utility function for recursive upload of directory
#' @param dir Directory to be uploaded
#' @param name Directory name. If not defined, `dir` will be taken.
#' @param dir_path Full directory path in Volume
#' @param overwrite Overwrite directory if it exists
#' @noRd
upload_directory <- function(
  dir,
  name = NULL,
  dir_path,
  overwrite = TRUE,
  ...
) {
  checkmate::assert_directory_exists(dir)
  checkmate::assert_string(name, null.ok = TRUE)
  checkmate::assert_string(dir_path)
  checkmate::assert_logical(overwrite, null.ok = FALSE)
  if (is.null(name)) {
    name <- basename(dir)
  }

  full_dir_path <- paste0(dir_path, "/", name)

  if (overwrite) {
    try(remove_directory(full_dir_path), silent = TRUE)
  }

  brickster::db_volume_dir_create(full_dir_path, ...)
  files_list <- fs::dir_ls(path = dir, recurse = FALSE, type = "file")
  dir_list <- fs::dir_ls(
    path = dir,
    recurse = FALSE,
    type = "directory"
  )

  lapply(files_list, \(file) {
    brickster::db_volume_write(
      path = paste0(full_dir_path, "/", basename(file)),
      file = file
    )
  })

  lapply(dir_list, \(dir_name) {
    upload_directory(
      dir = dir_name,
      dir_path = full_dir_path,
      overwrite = FALSE
    )
  })

  zephyr::msg_success("{.path {full_dir_path}} successfully uploaded.")
}

#' Utility function for recursive download of directory
#' @param dir_path Full directory path in Volume
#' @param name Directory name. If not defined, `basename(dir_path)` will be
#' taken.
#' @param overwrite Overwrite directory if it exists
#' @noRd
download_directory <- function(dir_path, name = NULL, overwrite = TRUE) {
  checkmate::assert_string(dir_path)
  checkmate::assert_string(name, null.ok = TRUE)
  checkmate::assert_logical(overwrite, null.ok = FALSE)

  if (!directory_exists(dir_path)) {
    cli::cli_abort(
      "Directory you're trying to download doesn't exist in
    {.path {dir_path}}"
    )
  }

  if (is.null(name)) {
    name <- basename(dir_path)
  }

  if (!overwrite && file.exists(name)) {
    cli::cli_abort(
      "Location you're trying to download to already exists in
    {.path {name}}. Set `overwrite` parameter to `TRUE` if you want to
    overwrite existing directory."
    )
  }

  try(fs::dir_delete(name), silent = TRUE)

  fs::dir_create(name)

  dir_content <- brickster::db_volume_list(path = dir_path)
  dir_content_names <- sapply(dir_content$contents, "[[", "name")
  for (content in dir_content_names) {
    item_path <- paste0(dir_path, "/", content)
    if (directory_exists(path = item_path)) {
      download_directory(
        dir_path = item_path,
        name = paste0(name, "/", content)
      )
      next
    }
    brickster::db_volume_read(
      path = item_path,
      destination = paste0(name, "/", content)
    )
  }

  zephyr::msg_success("{.path {dir_path}} successfully downloaded")
}

# Utility function for checking if a directory exists in the Volume
directory_exists <- function(path) {
  result <- tryCatch(
    {
      brickster::db_volume_dir_exists(path)
      TRUE
    },
    error = function(cond) {
      FALSE
    }
  )

  result
}
