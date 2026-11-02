# Reading and Writing Databricks Tables

## Introduction

This vignette demonstrates how to **read from** and **write to**
Databricks tables using the custom functions. These functions provide a
convenient interface for interacting with Databricks tables, including
features like [time
travel](https://docs.databricks.com/aws/en/delta/history) and
[tagging](https://docs.databricks.com/aws/en/database-objects/tags).

The package has two table connectors:

- `ConnectorDatabricksSQL`, created with
  [`connector_databricks_sql()`](https://novonordisk-opensource.github.io/connector.databricks/reference/connector_databricks_sql.md),
  which connects to a SQL warehouse through
  [`brickster::DatabricksSQL()`](https://rdrr.io/pkg/brickster/man/DatabricksSQL.html).
  This is the preferred connector.
- `ConnectorDatabricksTable`, created with
  [`connector_databricks_table()`](https://novonordisk-opensource.github.io/connector.databricks/reference/connector_databricks_table.md),
  which connects to a cluster through
  [`odbc::databricks()`](https://odbc.r-dbi.org/reference/databricks.html).

Both are covered below. See
[`vignette("articles/table-vs-sql")`](https://novonordisk-opensource.github.io/connector.databricks/articles/table-vs-sql.md)
for a side by side comparison.

## ConnectorDatabricksSQL

### Setup

``` r

library(connector.databricks)
library(dplyr)

# Create a ConnectorDatabricksSQL object
connector_object <- connector_databricks_sql(
  warehouse_id = "your-warehouse-id",
  catalog = "my_catalog",
  schema = "my_schema"
)
```

### Writing to a Databricks Table

``` r

# Create sample data
data <- data.frame(
  id = 1:5,
  name = c("Alice", "Bob", "Charlie", "David", "Eve"),
  age = c(25, 30, 35, 40, 45)
)

# Write data to a table
connector_object |>
  write_cnt(x = data, name = "my_table", overwrite = TRUE)

# Append rows to an existing table
connector_object |>
  write_cnt(x = data, name = "my_table", append = TRUE)
```

[`write_cnt()`](https://novonordisk-opensource.github.io/connector.databricks/reference/write_cnt.md)
is passed on to `brickster::dbWriteTable()`, which can write the data in
two ways:

- **Without a staging volume**, the data is sent as `VALUES` inside the
  SQL statement. This is fine for small tables, but slow for larger
  ones. It warns from 20,000 rows and refuses to write more than 50,000
  rows.
- **With a staging volume**, the data is written locally to a
  [**Parquet**](https://www.databricks.com/glossary/what-is-parquet)
  file, uploaded to the volume and loaded into the table. The staging
  files are removed afterwards. This is the recommended way for anything
  but small tables.

The staging volume is set once, when creating the connector, and is used
for every write:

``` r

connector_object <- connector_databricks_sql(
  warehouse_id = "your-warehouse-id",
  catalog = "my_catalog",
  schema = "my_schema",
  staging_volume = "/Volumes/my_catalog/my_schema/my_volume"
)
```

Writing an empty data frame is not supported, and `overwrite` and
`append` cannot both be `TRUE`.

### Reading from a Databricks Table

``` r

table_data <- connector_object |>
  read_cnt("my_table")
```

[`read_cnt()`](https://novonordisk-opensource.github.io/connector.databricks/reference/read_cnt.md)
uses
[`DBI::dbReadTable()`](https://dbi.r-dbi.org/reference/dbReadTable.html)
and reads the current version of the table. Older versions can be read
with Delta time travel syntax through the connection object:

``` r

# Read a specific version of the table
version_data <- DBI::dbGetQuery(
  connector_object$conn,
  "SELECT * FROM my_catalog.my_schema.my_table VERSION AS OF 2"
)

# Read the table at a specific timepoint
historical_data <- DBI::dbGetQuery(
  connector_object$conn,
  "SELECT * FROM my_catalog.my_schema.my_table TIMESTAMP AS OF '2023-06-01'"
)
```

### Tags

`ConnectorDatabricksSQL` has no `tags` argument, but tags can be set
with SQL through the connection object:

``` r

DBI::dbExecute(
  connector_object$conn,
  "ALTER TABLE my_catalog.my_schema.my_table SET TAGS ('source' = 'example')"
)
```

### Listing and Removing Tables

``` r

connector_object |>
  list_content_cnt()

connector_object |>
  remove_cnt("my_table")
```

### Working with Table References

``` r

filtered_data <- connector_object |>
  tbl_cnt("my_table") |>
  filter(age > 30) |>
  collect()
```

The
[`tbl_cnt()`](https://novonordisk-opensource.github.io/connector.databricks/reference/tbl_cnt.md)
method creates a reference to the table that can be used with dplyr
operations. These operations are translated to SQL and executed on the
SQL warehouse.

## ConnectorDatabricksTable

### Setup

``` r

library(connector.databricks)
library(dplyr)

# Create a ConnectorDatabricksTable object
connector_object <- connector_databricks_table(
  http_path = "path-to-cluster",
  catalog = "my_catalog",
  schema = "my_schema"
)
```

### Writing to a Databricks Table

To write data to a Databricks table, we use the
[`write_cnt()`](https://novonordisk-opensource.github.io/connector.databricks/reference/write_cnt.md)
method:

``` r

# Create sample data
data <- data.frame(
  id = 1:5,
  name = c("Alice", "Bob", "Charlie", "David", "Eve"),
  age = c(25, 30, 35, 40, 45)
)

# Write data to a table
connector_object |>
  write_cnt(
    x = data,
    name = "my_table",
    overwrite = TRUE,
    tags = list(source = "example", date = Sys.Date())
  )
```

#### Mechanism for Writing

The
[`write_cnt()`](https://novonordisk-opensource.github.io/connector.databricks/reference/write_cnt.md)
method for `ConnectorDatabricksTable` objects uses a **temporary volume
approach** to write data. Here’s how it works:

1.  A **temporary volume** is created in the Databricks file system.
2.  The data is written to this temporary volume as a
    [**Parquet**](https://www.databricks.com/glossary/what-is-parquet)
    file.
3.  The Parquet file is then converted to a Databricks table using SQL
    commands.
4.  If specified, **tags** are added to the table.
5.  Finally, the temporary volume is deleted.

This approach allows for **efficient writing of large datasets** and
provides a way to add metadata (tags) to the table. The use of Parquet
as an intermediate format ensures good performance and compatibility
with [Databricks’ Delta Lake
architecture](https://docs.databricks.com/aws/en/delta/).

### Reading from a Databricks Table

To read data from a Databricks table, we use the
[`read_cnt()`](https://novonordisk-opensource.github.io/connector.databricks/reference/read_cnt.md)
method:

``` r

# Read the entire table
table_data <- connector_object |>
  read_cnt("my_table")

# Read the table at a specific timepoint
historical_data <- connector_object |>
  read_cnt("my_table", timepoint = "2023-06-01 12:00:00 UTC")

# Read a specific version of the table
version_data <- connector_object |>
  read_cnt("my_table", version = 2)
```

#### Mechanism for Reading

The `read_cnt` method for `ConnectorDatabricksTable` objects leverages
Databricks’ SQL interface and [Delta Lake time travel
capabilities](https://docs.databricks.com/aws/en/delta/history). Here’s
how it works:

1.  A SQL query is constructed based on the table name and any time
    travel parameters (timepoint or version).
2.  The query is executed on a Databricks SQL warehouse.
3.  The result is streamed back in
    [Arrow](https://arrow.apache.org/overview/) format for efficient
    data transfer.
4.  The Arrow stream is converted to an R data frame.

This method supports time travel, allowing you to read historical
versions of the table. The use of Arrow for data transfer provides good
performance, especially for large datasets.

Note that writing, reading and tagging run on the first SQL warehouse
returned by
[`brickster::db_sql_warehouse_list()`](https://rdrr.io/pkg/brickster/man/db_sql_warehouse_list.html),
not on the cluster given in `http_path`.

### Listing Tables

To list tables in the Databricks catalog, use the
[`list_content_cnt()`](https://novonordisk-opensource.github.io/connector.databricks/reference/list_content_cnt.md)
method:

``` r

# List all tables
all_tables <- connector_object |>
  list_content_cnt()

# List tables with specific tags
tagged_tables <- connector_object |>
  list_content_cnt(tags = (tag_name == "source" && tag_value == "example"))
```

The `list_content_cnt` method can filter tables based on their tags. It
translates the tag filtering expression into SQL and queries the
Databricks system tables to find matching tables.

### Working with Table References

You can create a reference to a Databricks table using the
[`tbl_cnt()`](https://novonordisk-opensource.github.io/connector.databricks/reference/tbl_cnt.md)
method:

``` r

table_ref <- connector_object |>
  tbl_cnt("my_table")

# Use dplyr operations on the table reference
filtered_data <- table_ref |>
  filter(age > 30) |>
  collect()
```

The
[`tbl_cnt()`](https://novonordisk-opensource.github.io/connector.databricks/reference/tbl_cnt.md)
method creates a reference to the table that can be used with dplyr
operations. These operations are translated to SQL and executed on the
Databricks cluster, allowing for efficient processing of large datasets.

## Conclusion

This vignette demonstrated how to read from and write to Databricks
tables with both table connectors.

`ConnectorDatabricksSQL` relies on the standard DBI methods of the
`brickster` driver, with an optional staging volume for efficient
writes. Time travel and tags are available through SQL on the connection
object.

`ConnectorDatabricksTable` uses temporary volumes and Parquet files for
writing, and SQL queries with Arrow streaming for reading, with built-in
arguments for time travel and tags.

Remember to refer to the documentation of individual functions for more
detailed information on their usage and parameters.
