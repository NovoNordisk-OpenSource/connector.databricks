# Download content from the connector

Additional list content methods for Databricks connectors implemented
for
[`connector::download_cnt()`](https://novonordisk-opensource.github.io/connector/reference/download_cnt.html):

- [ConnectorDatabricksVolume](https://novonordisk-opensource.github.io/connector.databricks/reference/ConnectorDatabricksVolume.md):
  Reuses the
  [`connector::download_cnt()`](https://novonordisk-opensource.github.io/connector/reference/download_cnt.html)
  method for
  [ConnectorDatabricksVolume](https://novonordisk-opensource.github.io/connector.databricks/reference/ConnectorDatabricksVolume.md),
  but always sets the `catalog`, `schema` and `path` as defined in when
  initializing the connector.

## Usage

``` r
download_cnt(connector_object, src, dest = basename(src), ...)

# S3 method for class 'ConnectorDatabricksVolume'
download_cnt(connector_object, src, dest = basename(src), ...)
```

## Arguments

- connector_object:

  [Connector](https://novonordisk-opensource.github.io/connector/reference/Connector.html)
  The connector object to use.

- src:

  [character](https://rdrr.io/r/base/character.html) Name of the content
  to read, write, or remove. Typically the table name.

- dest:

  [character](https://rdrr.io/r/base/character.html) Path to the file to
  download to or upload from

- ...:

  [ConnectorDatabricksVolume](https://novonordisk-opensource.github.io/connector.databricks/reference/ConnectorDatabricksVolume.md):
  Additional parameters to pass to the
  [`brickster::db_volume_read()`](https://rdrr.io/pkg/brickster/man/db_volume_read.html)
  method

## Value

[invisible](https://rdrr.io/r/base/invisible.html) connector_object.
