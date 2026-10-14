# List available content from the connector

Additional list content methods for Databricks connectors implemented
for
[`connector::list_content_cnt()`](https://novonordisk-opensource.github.io/connector/reference/list_content_cnt.html):

- [ConnectorDatabricksSQL](https://novonordisk-opensource.github.io/connector.databricks/reference/ConnectorDatabricksSQL.md):
  Reuses the
  [`connector::list_content_cnt()`](https://novonordisk-opensource.github.io/connector/reference/list_content_cnt.html)
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
  [`connector::list_content_cnt()`](https://novonordisk-opensource.github.io/connector/reference/list_content_cnt.html)
  method for
  [ConnectorDatabricksVolume](https://novonordisk-opensource.github.io/connector.databricks/reference/ConnectorDatabricksVolume.md),
  but always sets the `catalog`, `schema` and `path` as defined in when
  initializing the connector.

## Usage

``` r
list_content_cnt(connector_object, ...)

# S3 method for class 'ConnectorDatabricksSQL'
list_content_cnt(connector_object, ...)

# S3 method for class 'ConnectorDatabricksTable'
list_content_cnt(connector_object, ..., tags = NULL)

# S3 method for class 'ConnectorDatabricksVolume'
list_content_cnt(connector_object, ...)
```

## Arguments

- connector_object:

  [Connector](https://novonordisk-opensource.github.io/connector/reference/Connector.html)
  The connector object to use.

- ...:

  [ConnectorDatabricksVolume](https://novonordisk-opensource.github.io/connector.databricks/reference/ConnectorDatabricksVolume.md):
  Additional parameters to pass to the
  [`brickster::db_volume_list()`](https://rdrr.io/pkg/brickster/man/db_volume_list.html)
  method

- tags:

  Expression to be translated to SQL using
  [`dbplyr::translate_sql()`](https://dbplyr.tidyverse.org/reference/translate_sql.html)
  e.g.
  `((tag_name == "name1" && tag_value == "value1") || (tag_name == "name2"))`.
  It should contain `tag_name` and `tag_value` values to filter by.

## Value

A [character](https://rdrr.io/r/base/character.html) vector of content
names
