# Connector for connecting to Databricks using DBI

Extension of the
[connector::connector_dbi](https://novonordisk-opensource.github.io/connector/reference/connector_dbi.html)
making it easier to connect to, and work with tables in Databricks.

## Details

The `extra_class` parameter allows you to create a subclass of the
ConnectorDatabricksTable object. This can be useful if you want to
create a custom connection object for easier dispatch of new s3 methods,
while still inheriting the methods from the ConnectorDatabricksTable
object.

All methods for ConnectorDatabricksTable object are working from the
catalog and schema provided when initializing the connection. This means
you only need to provide the table name when using the built in methods.
If you want to access tables outside of the chosen schema, you can
either retrieve the connection with `ConnectorDatabricksTable$conn` or
create a new connector.

Authentication to Databricks is handed by drivers and supports general
use of personal access tokens and credentials through Posit Workbench.

## Super classes

[`connector::Connector`](https://novonordisk-opensource.github.io/connector/reference/Connector.html)
-\>
[`connector::ConnectorDBI`](https://novonordisk-opensource.github.io/connector/reference/ConnectorDBI.html)
-\> `ConnectorDatabricksTable`

## Active bindings

- `conn`:

  The DBI connection object of the connector

- `catalog`:

  The catalog used in the connector

- `schema`:

  The schema used in the connector

## Methods

### Public methods

- [`ConnectorDatabricksTable$new()`](#method-ConnectorDatabricksTable-new)

- [`ConnectorDatabricksTable$clone()`](#method-ConnectorDatabricksTable-clone)

Inherited methods

- [`connector::Connector$list_content_cnt()`](https://novonordisk-opensource.github.io/connector/reference/Connector.html#method-list_content_cnt)
- [`connector::Connector$print()`](https://novonordisk-opensource.github.io/connector/reference/Connector.html#method-print)
- [`connector::Connector$read_cnt()`](https://novonordisk-opensource.github.io/connector/reference/Connector.html#method-read_cnt)
- [`connector::Connector$remove_cnt()`](https://novonordisk-opensource.github.io/connector/reference/Connector.html#method-remove_cnt)
- [`connector::Connector$write_cnt()`](https://novonordisk-opensource.github.io/connector/reference/Connector.html#method-write_cnt)
- [`connector::ConnectorDBI$disconnect_cnt()`](https://novonordisk-opensource.github.io/connector/reference/ConnectorDBI.html#method-disconnect_cnt)
- [`connector::ConnectorDBI$tbl_cnt()`](https://novonordisk-opensource.github.io/connector/reference/ConnectorDBI.html#method-tbl_cnt)

------------------------------------------------------------------------

### Method `new()`

Initialize the connection to Databricks

#### Usage

    ConnectorDatabricksTable$new(
      sql_warehouse,
      http_path,
      catalog,
      schema,
      extra_class = NULL
    )

#### Arguments

- `sql_warehouse`:

  [character](https://rdrr.io/r/base/character.html) The canonical
  identifier of the SQL warehouse. This connection is using
  [`brickster::DatabricksSQL()`](https://rdrr.io/pkg/brickster/man/DatabricksSQL.html)
  driver.

- `http_path`:

  [character](https://rdrr.io/r/base/character.html) **\[deprecated\]**
  The path to the Databricks cluster or SQL warehouse you want to
  connect to. This connection is using
  [`odbc::databricks()`](https://odbc.r-dbi.org/reference/databricks.html)
  driver.

- `catalog`:

  [character](https://rdrr.io/r/base/character.html) The catalog to use

- `schema`:

  [character](https://rdrr.io/r/base/character.html) The schema to use

- `extra_class`:

  [character](https://rdrr.io/r/base/character.html) Extra class to
  assign to the new connector

#### Returns

A ConnectorDatabricksTable object

------------------------------------------------------------------------

### Method `clone()`

The objects of this class are cloneable with this method.

#### Usage

    ConnectorDatabricksTable$clone(deep = FALSE)

#### Arguments

- `deep`:

  Whether to make a deep clone.

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
