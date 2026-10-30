# Remove content from the connector

Additional remove methods for Databricks connectors implemented for
[`connector::remove_cnt()`](https://novonordisk-opensource.github.io/connector/reference/remove_cnt.html):

- [ConnectorDatabricksSQL](https://novonordisk-opensource.github.io/connector.databricks/reference/ConnectorDatabricksSQL.md):
  Reuses the
  [`connector::remove_cnt()`](https://novonordisk-opensource.github.io/connector/reference/remove_cnt.html)
  method for
  [ConnectorDatabricksSQL](https://novonordisk-opensource.github.io/connector.databricks/reference/ConnectorDatabricksSQL.md),
  but always sets the `catalog` and `schema` as defined in when
  initializing the connector.

&nbsp;

- [ConnectorDatabricksTable](https://novonordisk-opensource.github.io/connector.databricks/reference/ConnectorDatabricksTable.md):
  Reuses the
  [`connector::list_content_cnt()`](https://novonordisk-opensource.github.io/connector/reference/list_content_cnt.html)
  method for
  [ConnectorDatabricksTable](https://novonordisk-opensource.github.io/connector.databricks/reference/ConnectorDatabricksTable.md),
  but always sets the `catalog` and `schema` as defined in when
  initializing the connector.

&nbsp;

- [ConnectorDatabricksVolume](https://novonordisk-opensource.github.io/connector.databricks/reference/ConnectorDatabricksVolume.md):
  Reuses the
  [`connector::remove_cnt()`](https://novonordisk-opensource.github.io/connector/reference/remove_cnt.html)
  method for
  [ConnectorDatabricksVolume](https://novonordisk-opensource.github.io/connector.databricks/reference/ConnectorDatabricksVolume.md),
  but always sets the `catalog`, `schema` and `path` as defined in when
  initializing the connector.

## Usage

``` r
remove_cnt(connector_object, name, ...)

# S3 method for class 'ConnectorDatabricksSQL'
remove_cnt(connector_object, name, ...)

# S3 method for class 'ConnectorDatabricksTable'
remove_cnt(connector_object, name, ...)

# S3 method for class 'ConnectorDatabricksVolume'
remove_cnt(connector_object, name, ...)
```

## Arguments

- connector_object:

  [Connector](https://novonordisk-opensource.github.io/connector/reference/Connector.html)
  The connector object to use.

- name:

  [character](https://rdrr.io/r/base/character.html) Name of the content
  to read, write, or remove. Typically the table name.

- ...:

  [ConnectorDatabricksTable](https://novonordisk-opensource.github.io/connector.databricks/reference/ConnectorDatabricksTable.md):
  Additional parameters to pass to the
  [`brickster::db_uc_tables_delete()`](https://rdrr.io/pkg/brickster/man/db_uc_tables_delete.html)
  method

## Value

[invisible](https://rdrr.io/r/base/invisible.html) connector_object.
