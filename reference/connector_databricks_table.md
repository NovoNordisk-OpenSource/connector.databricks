# Create `ConnectorDatabricksTable` connector

Initializes the connector for table type of storage. See
[ConnectorDatabricksTable](https://novonordisk-opensource.github.io/connector.databricks/reference/ConnectorDatabricksTable.md)
for details.

## Usage

``` r
connector_databricks_table(http_path, catalog, schema, extra_class = NULL)
```

## Arguments

- http_path:

  [character](https://rdrr.io/r/base/character.html) The path to the
  Databricks cluster or SQL warehouse you want to connect to

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
`ConnectorDatabricksTable` object. This can be useful if you want to
create a custom connection object for easier dispatch of new s3 methods,
while still inheriting the methods from the `ConnectorDatabricksTable`
object.

## Examples

``` r
if (FALSE) { # \dontrun{
# Establish connection to your cluster

con_databricks <- connector_databricks_table(
  http_path = "path-to-cluster",
  catalog = "my_catalog",
  schema = "my_schema"
)

# List tables in my_schema

con_databricks$list_content()

# Read and write tables

con_databricks$write(mtcars, "my_mtcars_table")

con_databricks$read("my_mtcars_table")

# Use dplyr::tbl

con_databricks$tbl("my_mtcars_table")

# Remove table

con_databricks$remove("my_mtcars_table")

# Disconnect

con_databricks$disconnect()
} # }
```
