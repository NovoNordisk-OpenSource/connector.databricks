# Connector for connecting to Databricks using brickster DatabricksSQL **\[experimental\]**

Extension of the
[connector::connector_dbi](https://novonordisk-opensource.github.io/connector/reference/connector_dbi.html)
making it easier to connect to, and work with tables in Databricks using
SQL warehouses.

## Details

All methods for ConnectorDatabricksSQL object are working from the
catalog and schema provided when initializing the connection. This means
you only need to provide the table name when using the built in methods.
If you want to access tables outside of the chosen schema, you can
either retrieve the connection with `ConnectorDatabricksSQL$conn` or
create a new connector.

When creating the connections to Databricks you need to provide the
warehouse ID of the SQL warehouse you want to connect to. Authentication
to databricks is handled by the
[`brickster::DatabricksSQL()`](https://rdrr.io/pkg/brickster/man/DatabricksSQL.html)
driver and supports general use of personal access tokens and
credentials through Posit Workbench. See also
[`brickster::DatabricksSQL()`](https://rdrr.io/pkg/brickster/man/DatabricksSQL.html)
for more information on how the connection to Databricks is established.

## Super classes

[`connector::Connector`](https://novonordisk-opensource.github.io/connector/reference/Connector.html)
-\>
[`connector::ConnectorDBI`](https://novonordisk-opensource.github.io/connector/reference/ConnectorDBI.html)
-\> `ConnectorDatabricksSQL`

## Active bindings

- `conn`:

  The DBI connection object of the connector

- `catalog`:

  The catalog used in the connector

- `schema`:

  The schema used in the connector

- `staging_volume`:

  Optional volume path for large dataset staging

## Methods

### Public methods

- [`ConnectorDatabricksSQL$new()`](#method-ConnectorDatabricksSQL-new)

- [`ConnectorDatabricksSQL$clone()`](#method-ConnectorDatabricksSQL-clone)

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

    ConnectorDatabricksSQL$new(
      warehouse_id,
      catalog,
      schema,
      staging_volume = NULL,
      ...,
      extra_class = NULL
    )

#### Arguments

- `warehouse_id`:

  [character](https://rdrr.io/r/base/character.html) The ID of the
  Databricks SQL warehouse you want to connect to

- `catalog`:

  [character](https://rdrr.io/r/base/character.html) The catalog to use

- `schema`:

  [character](https://rdrr.io/r/base/character.html) The schema to use

- `staging_volume`:

  [character](https://rdrr.io/r/base/character.html) Optional volume
  path for large dataset staging

- `...`:

  Additional parameters sent to
  [`brickster::DatabricksSQL()`](https://rdrr.io/pkg/brickster/man/DatabricksSQL.html)
  driver.

- `extra_class`:

  [character](https://rdrr.io/r/base/character.html) Extra class to
  assign to the new connector

#### Returns

A ConnectorDatabricksSQL object

------------------------------------------------------------------------

### Method `clone()`

The objects of this class are cloneable with this method.

#### Usage

    ConnectorDatabricksSQL$clone(deep = FALSE)

#### Arguments

- `deep`:

  Whether to make a deep clone.

## Examples

``` r
if (FALSE) { # \dontrun{
# Establish connection to your SQL warehouse

con_databricks <- ConnectorDatabricksSQL$new(
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
