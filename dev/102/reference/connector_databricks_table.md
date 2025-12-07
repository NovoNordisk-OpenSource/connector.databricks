# Create `ConnectorDatabricksTable` connector

Initializes the connector for table type of storage. See
[ConnectorDatabricksTable](https://novonordisk-opensource.github.io/connector.databricks/reference/ConnectorDatabricksTable.md)
for details.

## Usage

``` r
connector_databricks_table(
  sql_warehouse,
  http_path,
  catalog,
  schema,
  extra_class = NULL
)
```

## Arguments

- sql_warehouse:

  [character](https://rdrr.io/r/base/character.html) The canonical
  identifier of the SQL warehouse. This connection is using
  [`brickster::DatabricksSQL()`](https://rdrr.io/pkg/brickster/man/DatabricksSQL.html)
  driver.

- http_path:

  [character](https://rdrr.io/r/base/character.html) **\[deprecated\]**
  The path to the Databricks cluster or SQL warehouse you want to
  connect to. This connection is using
  [`odbc::databricks()`](https://odbc.r-dbi.org/reference/databricks.html)
  driver.

- catalog:

  [character](https://rdrr.io/r/base/character.html) The catalog to use

- schema:

  [character](https://rdrr.io/r/base/character.html) The schema to use

- extra_class:

  [character](https://rdrr.io/r/base/character.html) Extra class to
  assign to the new connector

## Value

A new
[ConnectorDatabricksTable](https://novonordisk-opensource.github.io/connector.databricks/reference/ConnectorDatabricksTable.md)
object

## Details

The `extra_class` parameter allows you to create a subclass of the
[ConnectorDatabricksTable](https://novonordisk-opensource.github.io/connector.databricks/reference/ConnectorDatabricksTable.md)
object. This can be useful if you want to create a custom connection
object for easier dispatch of new s3 methods, while still inheriting the
methods from the
[ConnectorDatabricksTable](https://novonordisk-opensource.github.io/connector.databricks/reference/ConnectorDatabricksTable.md)
object.

All methods for
[ConnectorDatabricksTable](https://novonordisk-opensource.github.io/connector.databricks/reference/ConnectorDatabricksTable.md)
object are working from the catalog and schema provided when
initializing the connection. This means you only need to provide the
table name when using the built in methods. If you want to access tables
outside of the chosen schema, you can either retrieve the connection
with `ConnectorDatabricksTable$conn` or create a new connector.

Authentication to Databricks is handed by drivers and supports general
use of personal access tokens and credentials through Posit Workbench.

## Examples

``` r
if (FALSE) { # \dontrun{
# Establish connection to your cluster

# Using sql warehouse (recommended)
con_databricks <- connector_databricks_table(
  sql_warehouse = "path-to-sql-warehouse",
  catalog = "my_catalog",
  schema = "my_schema"
)

# Using compute cluster
con_databricks <- connector_databricks_table(
  http_path = "path-to-cluster",
  catalog = "my_catalog",
  schema = "my_schema"
)

# List tables in my_schema

con_databricks$list_content_cnt()

# Read and write tables

con_databricks$write_cnt(mtcars, "my_mtcars_table")

con_databricks$read_cnt("my_mtcars_table")

# Use dplyr::tbl

con_databricks$tbl_cnt("my_mtcars_table")

# Remove table

con_databricks$remove_cnt("my_mtcars_table")

# Disconnect

con_databricks$disconnect_cnt()
} # }
```
