# Use dplyr verbs to interact with the remote database table

Additional tbl methods for Databricks connectors implemented for
[`connector::tbl_cnt()`](https://novonordisk-opensource.github.io/connector/reference/tbl_cnt.html):

- [ConnectorDatabricksSQL](https://novonordisk-opensource.github.io/connector.databricks/reference/ConnectorDatabricksSQL.md):
  Reuses the
  [`connector::tbl_cnt()`](https://novonordisk-opensource.github.io/connector/reference/tbl_cnt.html)
  method for
  [ConnectorDatabricksTable](https://novonordisk-opensource.github.io/connector.databricks/reference/ConnectorDatabricksTable.md),
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
  [`connector::remove_directory_cnt()`](https://novonordisk-opensource.github.io/connector/reference/remove_directory_cnt.html)
  method for
  [ConnectorDatabricksVolume](https://novonordisk-opensource.github.io/connector.databricks/reference/ConnectorDatabricksVolume.md),
  but always sets the `catalog`, `schema` and `path` as defined in when
  initializing the connector. Uses
  [`read_cnt()`](https://novonordisk-opensource.github.io/connector.databricks/reference/read_cnt.md)
  to allow redundancy between Volumes and Tables.

## Usage

``` r
tbl_cnt(connector_object, name, ...)

# S3 method for class 'ConnectorDatabricksSQL'
tbl_cnt(connector_object, name, ...)

# S3 method for class 'ConnectorDatabricksTable'
tbl_cnt(connector_object, name, ...)

# S3 method for class 'ConnectorDatabricksVolume'
tbl_cnt(connector_object, name, ...)
```

## Arguments

- connector_object:

  [Connector](https://novonordisk-opensource.github.io/connector/reference/Connector.html)
  The connector object to use.

- name:

  [character](https://rdrr.io/r/base/character.html) Name of the content
  to read, write, or remove. Typically the table name.

- ...:

  Additional arguments passed to the method for the individual
  connector.

## Value

A [dplyr::tbl](https://dplyr.tidyverse.org/reference/tbl.html) object.
