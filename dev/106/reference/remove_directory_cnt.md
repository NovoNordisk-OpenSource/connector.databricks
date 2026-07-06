# Remove a directory

Additional list content methods for Databricks connectors implemented
for
[`connector::remove_directory_cnt()`](https://novonordisk-opensource.github.io/connector/reference/remove_directory_cnt.html):

- [ConnectorDatabricksVolume](https://novonordisk-opensource.github.io/connector.databricks/reference/ConnectorDatabricksVolume.md):
  Reuses the
  [`connector::remove_directory_cnt()`](https://novonordisk-opensource.github.io/connector/reference/remove_directory_cnt.html)
  method for
  [ConnectorDatabricksVolume](https://novonordisk-opensource.github.io/connector.databricks/reference/ConnectorDatabricksVolume.md),
  but always sets the `catalog`, `schema` and `path` as defined in when
  initializing the connector.

## Usage

``` r
remove_directory_cnt(connector_object, name, ...)

# S3 method for class 'ConnectorDatabricksVolume'
remove_directory_cnt(connector_object, name, ...)
```

## Arguments

- connector_object:

  [Connector](https://novonordisk-opensource.github.io/connector/reference/Connector.html)
  The connector object to use.

- name:

  [character](https://rdrr.io/r/base/character.html) The name of the
  directory to remove

- ...:

  [ConnectorDatabricksVolume](https://novonordisk-opensource.github.io/connector.databricks/reference/ConnectorDatabricksVolume.md):
  Additional parameters to pass to the
  [`brickster::db_volume_dir_delete()`](https://rdrr.io/pkg/brickster/man/db_volume_dir_delete.html)
  method

## Value

[invisible](https://rdrr.io/r/base/invisible.html) connector_object.
