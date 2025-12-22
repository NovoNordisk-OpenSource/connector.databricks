# Create `ConnectorDatabricksSQL` connector **\[experimental\]**

Initializes the connector for SQL warehouse type of storage. See
[ConnectorDatabricksSQL](https://novonordisk-opensource.github.io/connector.databricks/reference/ConnectorDatabricksSQL.md)
for details.

Initialize the connection to Databricks

## Usage

``` r
connector_databricks_sql(
  warehouse_id,
  catalog,
  schema,
  staging_volume = NULL,
  ...,
  extra_class = NULL
)
```

## Arguments

- warehouse_id:

  [character](https://rdrr.io/r/base/character.html) The ID of the
  Databricks SQL warehouse you want to connect to

- catalog:

  [character](https://rdrr.io/r/base/character.html) The catalog to use

- schema:

  [character](https://rdrr.io/r/base/character.html) The schema to use

- staging_volume:

  [character](https://rdrr.io/r/base/character.html) Optional volume
  path for large dataset staging. Recommended way for better
  performances.

- ...:

  Additional parameters sent to
  [`brickster::DatabricksSQL()`](https://rdrr.io/pkg/brickster/man/DatabricksSQL.html)
  driver.

- extra_class:

  [character](https://rdrr.io/r/base/character.html) Extra class to
  assign to the new connector

## Value

A
[ConnectorDatabricksSQL](https://novonordisk-opensource.github.io/connector.databricks/reference/ConnectorDatabricksSQL.md)
object

## Details

The `extra_class` parameter allows you to create a subclass of the
`ConnectorDatabricksSQL` object. This can be useful if you want to
create a custom connection object for easier dispatch of new s3 methods,
while still inheriting the methods from the `ConnectorDatabricksSQL`
object.

## Examples

``` r
if (FALSE) { # \dontrun{
# Establish connection to your SQL warehouse

con_databricks <- connector_databricks_sql(
  warehouse_id = "your-warehouse-id",
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
