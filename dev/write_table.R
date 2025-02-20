# Upload a new table
# install.packages("httr2", repos = "https://rspm.bifrost-prd.corp.aws.novonordisk.com/default-cran/latest")
pkgload::load_all()


big_iris <- as.data.frame(purrr::map_dfc(1:10, ~ iris))
big_iris <- as.data.frame(purrr::map_dfr(1:300000, ~ big_iris))
# Upload the table
con <- connector::connectors(
  tables = connector_databricks_dbi$new(
    http_path= Sys.getenv("DATABRICKS_HTTP_PATH"),
    catalog= Sys.getenv("DATABRICKS_CATALOG_NAME"),
    schema= Sys.getenv("DATABRICKS_SCHEMA_NAME")
  ),
  volumes= connector_databricks_volume(
    full_path = paste0(Sys.getenv("DATABRICKS_VOLUME"), "/test")
  )
)


con$volumes |>
  write_cnt(big_iris, "big_iris.csv", overwrite = TRUE)

write.csv(iris, "big_iris.csv", row.names = FALSE)

# con$tables |>
#   write_cnt(big_iris, "big_iris", overwrite = TRUE)

m_pmap <- memoise::memoize(purrr::pmap)
##### TEST one:
test1 <- m_pmap(expand.grid(c(5, 10 , 20), c(1, 10, 100, 1000)), ~{
  big_iris <- iris
  big_iris <- suppressMessages(purrr::map_dfr(1:.x, ~ iris))
  big_iris <- suppressMessages(purrr::map_dfc(1:.y, ~ big_iris))

  try({
    db$tables |>
      remove_cnt("big_iris")
  },
  silent = TRUE)

  tictoc::tic()

  con$volumes |>
    write_cnt(big_iris, "big_iris.csv", overwrite = TRUE)

  try({con$tables |>
    remove_cnt("test")},
    silent = TRUE)

  result <- try({
    query <- "/* Load data from a volume */
      CREATE OR REFRESH STREAMING TABLE amace_cdr_bronze_dev.nnxxxx_yyyy_adam.test AS
      SELECT * FROM STREAM read_files('/Volumes/amace_cdr_bronze_dev/nnxxxx_yyyy_adam/test/big_iris.csv')"
   ok <-  brickster::db_sql_exec_query(query, "6a933d28ce9ab959")
   test <- brickster::db_sql_exec_result(ok$statement_id, 0)
   while(test$status$state != "SUCCEEDED") try(  test <<- brickster::db_sql_exec_result(ok$statement_id, 0), silent = TRUE)
  },silent = TRUE)

  ok <- suppressMessages(tictoc::toc())
  Sys.sleep(5)

  try({con$tables |>
      remove_cnt("test")},silent = TRUE)
  list(
    time = ok$toc - ok$tic,
    error = ifelse(class(result) == "try-error", TRUE, FALSE),
    rows = nrow(big_iris),
    columns = ncol(big_iris)
  )
}
)



con$tables |>
  remove_cnt("test")

## Query 3


##### TEST trois:
test3 <- m_pmap(expand.grid(c(1, 10, 100, 1000), c(5, 10 , 20)), ~{
  big_iris <- iris
  big_iris <- suppressMessages(purrr::map_dfr(1:.x, ~ iris))
  big_iris <- suppressMessages(purrr::map_dfc(1:.y, ~ big_iris))


  tictoc::tic()

  con$volumes |>
    write_cnt(big_iris, "big_iris.csv", overwrite = TRUE)
  message('ok')
  result <- try({
    brickster::db_sql_exec_query("CREATE TABLE IF NOT EXISTS amace_cdr_bronze_dev.nnxxxx_yyyy_adam.test3 USING DELTA;", "6a933d28ce9ab959" )
    ok <- brickster::db_sql_exec_query(
      "COPY INTO amace_cdr_bronze_dev.nnxxxx_yyyy_adam.test3 FROM '/Volumes/amace_cdr_bronze_dev/nnxxxx_yyyy_adam/test/big_iris.csv' FILEFORMAT = CSV  FORMAT_OPTIONS ('header' = 'true') COPY_OPTIONS ('mergeSchema' = 'true');",
      "6a933d28ce9ab959" )
    test <- brickster::db_sql_exec_result(ok$statement_id, 0)
    while(test$status$state != "SUCCEEDED") try(  test <<- brickster::db_sql_exec_result(ok$statement_id, 0), silent = TRUE)

  },silent = TRUE)

  message("done")
  ok <- tictoc::toc()

  con$tables |>
    remove_cnt("test3")

  time <- ok$toc - ok$tic
  message(time)
  list(
    time = time,
    error = ifelse(class(result) == "try-error", TRUE, FALSE),
    rows = nrow(big_iris),
    columns = ncol(big_iris)
  )
  }
)

### External File

ok <- brickster::db_sql_exec_query("CREATE TABLE amace_cdr_bronze_dev.nnxxxx_yyyy_adam.test4 USING CSV LOCATION 'big_iris.csv';", "6a933d28ce9ab959")
while(ok$status$state != "SUCCEEDED") try(  ok <<- brickster::db_sql_exec_result(ok$statement_id, 0), silent = TRUE)

ok <- brickster::db_sql_exec_query("CREATE TABLE amace_cdr_bronze_dev.nnxxxx_yyyy_adam.test4 USING CSV LOCATION 'big_iris.csv';", "6a933d28ce9ab959")
for(x in 1:5){
  try(  ok <<- brickster::db_sql_exec_result(ok$statement_id, 0), silent = TRUE)
  message(ok$status$error$message)
}

test1 |>
  purrr::map_df(as.data.frame) |>
  mutate(method = "stream") |>
      bind_rows(
        test3 |>
          purrr::map_df(as.data.frame) |>
          mutate(method = "copy_into")
      ) |>
  arrange(columns, rows ) |>
  mutate(ok = row_number(),
         test = paste0(columns, "-", rows),
         test = forcats::fct_reorder(test, ok)) |>
  ggplot2::ggplot() +
  ggplot2::aes(x = time, y = test) +
  ggplot2::geom_point() +
  ggplot2::facet_grid(~method) +
  ggplot2::labs(title = "Writing to DataB using connector", x = "Time", y = "rows and cols")


con$tables |>
  remove_cnt("test")
con$tables |>
  remove_cnt("test2")
con$tables |>
  remove_cnt("test3")

rs <- con$tables$conn |>
  DBI::dbSendQuery(
    query3
  )

DBI::dbFetch(rs)
