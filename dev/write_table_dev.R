# Steps
# 1. Check is user can create a temporary volume (maybe use withr)
# 2. Check if the table exists (should overwrite be TRUE?)
# 3. Check file name and format.
# 4. Create a temp volume for the file to be uploaded to.
# 5. Upload the file to the temp volume. Write the file to Databricks using connector_databricks_volume()
# 6. Convert the parquet file from volume to a table in Databricks.
# 7. Remove the temporary volume and file.
# 8. Return a message that the table has been created.

### Setup ###
library(connector)
library(arrow)
devtools::load_all()

## Define function parameters ###

connector_object <- connector_databricks_table(
  http_path = Sys.getenv("DATABRICKS_HTTP_PATH"),
  catalog = Sys.getenv("DATABRICKS_CATALOG_NAME"),
  schema = Sys.getenv("DATABRICKS_SCHEMA_NAME")
)

# Create big object to write to Databricks
big_iris <- as.data.frame(purrr::map_dfc(1:10, ~iris))
x <- as.data.frame(purrr::map_dfr(1:300000, ~big_iris))

name <- "test_iris_table"

overwrite <- TRUE

write_cnt(
  connector_object = connector_object,
  x = x,
  name = "test_iris_table"
)
### Steps ###
# 1. Check if user can create a temporary volume for the file to be uploaded to.
# Use withr to create a temporary volume and remove it after use
# local_create_tmp_dir <- function(volume_con, name) {
#   tmp_volume <- volume_con |> create_directory_cnt(name = name, open = TRUE)
#   withr::defer(
#     volume_con$remove_directory_cnt(name = name)
#   )
#   tmp_volume
# }

volume_name <- function(prefix = "test_", length = 10) {
  random_string <- paste0(
    sample(c(letters, 0:9), length, replace = TRUE),
    collapse = ""
  )
  result <- paste0(prefix, random_string)
  return(result)
}

tmp_volume_name <- volume_name()
catalog <- connector_object$catalog
schema <- connector_object$schema

tmp_volume <- connector_databricks_volume(
  catalog = catalog,
  schema = schema,
  path = tmp_volume_name,
  force = TRUE
)

# 2. Upload parquet file to Volumes
tmp_volume |>
  write_cnt(
    x = x,
    name = paste0(name, ".parquet"),
    overwrite = TRUE
  )

# 3. Convert file from parquet file in Volumes to a table
# Will leave it as this for now
id_of_cluster <- brickster::db_sql_warehouse_list()[[1]]$id

catalog <- connector_object$catalog
schema <- connector_object$schema

# Create table
query_create <- glue::glue(
  "CREATE TABLE IF NOT EXISTS {catalog}.{schema}.{name} USING DELTA;"
)
brickster::db_sql_exec_query(
  query_create,
  id_of_cluster
)

# Copy parquet file into table
query_copy <- glue::glue(
  "COPY INTO {catalog}.{schema}.{name} FROM '{tmp_volume$full_path}/{name}.parquet' FILEFORMAT = PARQUET  FORMAT_OPTIONS ('header' = 'true') COPY_OPTIONS ('mergeSchema' = 'true', 'force' = 'true');",
)
test <- brickster::db_sql_exec_query(
  query_copy,
  id_of_cluster
)

# 4. Remove tmp_volume
brickster::db_uc_volumes_delete(
  catalog = catalog,
  schema = schema,
  volume = tmp_volume_name
)
