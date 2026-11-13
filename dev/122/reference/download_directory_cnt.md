# Download a directory

Additional list content methods for Databricks connectors implemented
for
[`connector::download_directory_cnt()`](https://novonordisk-opensource.github.io/connector/reference/download_directory_cnt.html):

- [ConnectorDatabricksVolume](https://novonordisk-opensource.github.io/connector.databricks/reference/ConnectorDatabricksVolume.md):
  Reuses the
  [`connector::download_directory_cnt()`](https://novonordisk-opensource.github.io/connector/reference/download_directory_cnt.html)
  method for
  [ConnectorDatabricksVolume](https://novonordisk-opensource.github.io/connector.databricks/reference/ConnectorDatabricksVolume.md),
  but always sets the `catalog`, `schema` and `path` as defined in when
  initializing the connector.

## Usage

``` r
download_directory_cnt(connector_object, src, dest = basename(src), ...)

# S3 method for class 'ConnectorDatabricksVolume'
download_directory_cnt(connector_object, src, dest = basename(src), ...)
```

## Arguments

- connector_object:

  [Connector](https://novonordisk-opensource.github.io/connector/reference/Connector.html)
  The connector object to use.

- src:

  [character](https://rdrr.io/r/base/character.html) The name of the
  directory to download from the connector

- dest:

  [character](https://rdrr.io/r/base/character.html) Path to the
  directory to download to

- ...:

  [ConnectorDatabricksVolume](https://novonordisk-opensource.github.io/connector.databricks/reference/ConnectorDatabricksVolume.md):
  Additional parameters to pass to the
  [`brickster::db_volume_dir_create()`](https://rdrr.io/pkg/brickster/man/db_volume_dir_create.html)
  method

## Value

[invisible](https://rdrr.io/r/base/invisible.html) connector_object.
