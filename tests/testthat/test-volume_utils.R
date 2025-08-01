# Skip interactive tests on CI and CRAN
skip_on_ci()
skip_on_cran()

test_that("directory upload and removal fails when needed", {
  expect_error(remove_directory(dir_path = 1))
  expect_error(remove_directory(dir_path = "/Volumes/random_directory"))

  create_nested_directories("nested_structure", 3, 2)
  withr::defer(
    fs::dir_delete("nested_structure")
  )
  expect_error(upload_directory(dir = 1))
  expect_error(upload_directory(dir = "nested_structure", dir_path = 1))
  expect_error(upload_directory(
    dir = "nested_structure",
    dir_path = "/Volumes/random_directory",
    overwrite = 1
  ))
})

test_that("directory upload and removal works", {
  create_nested_directories("nested_structure", 3, 2)
  withr::defer(
    fs::dir_delete("nested_structure")
  )

  # Set up directory paths
  dir_path <- paste0("/Volumes/", setup_db_volume_path)
  dir_path_nested <- paste0(
    "/Volumes/",
    setup_db_volume_path,
    "/nested_structure"
  )

  # Upload directory
  expect_no_failure(upload_directory(
    dir = "nested_structure",
    dir_path = dir_path
  ))

  withr::defer({
    remove_directory(
      dir_path = dir_path_nested
    )
    expect_error(brickster::db_volume_dir_exists(paste0(
      "/Volumes/",
      setup_db_volume_path,
      "/nested_structure"
    )))
  })

  # Upload and overwrite directory TRUE
  expect_no_failure(upload_directory(
    dir = "nested_structure",
    dir_path = dir_path,
    overwrite = TRUE
  ))

  # Upload and overwrite directory FALSE
  expect_error(upload_directory(
    dir = "nested_structure",
    dir_path = dir_path,
    overwrite = FALSE
  ))

  expect_no_failure(upload_directory(
    dir = "nested_structure",
    dir_path = dir_path,
    name = "uploaded_directory"
  ))
  withr::defer(
    remove_directory(
      dir_path = paste0(
        "/Volumes/",
        setup_db_volume_path,
        "/uploaded_directory"
      )
    )
  )

  # Download and overwrite directory TRUE
  expect_no_failure(download_directory(
    dir_path = dir_path_nested,
    overwrite = TRUE
  ))

  # Download directory
  expect_no_failure(download_directory(
    dir_path = paste0("/Volumes/", setup_db_volume_path, "/uploaded_directory"),
    name = "downloaded_directory"
  ))
  withr::defer(
    fs::dir_delete("downloaded_directory")
  )
  expect_equal(
    list.files("nested_structure", recursive = TRUE),
    list.files("downloaded_directory", recursive = TRUE)
  )

  # Download and overwrite directory FALSE
  expect_error(download_directory(
    dir_path = dir_path_nested,
    overwrite = FALSE
  ))
})
