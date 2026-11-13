# Create a directory

Additional list content methods for Databricks connectors implemented
for
[`connector::create_directory_cnt()`](https://novonordisk-opensource.github.io/connector/reference/create_directory_cnt.html):

- [ConnectorDatabricksVolume](https://novonordisk-opensource.github.io/connector.databricks/reference/ConnectorDatabricksVolume.md):
  Reuses the
  [`connector::create_directory_cnt()`](https://novonordisk-opensource.github.io/connector/reference/create_directory_cnt.html)
  method for
  [ConnectorDatabricksVolume](https://novonordisk-opensource.github.io/connector.databricks/reference/ConnectorDatabricksVolume.md),
  but always sets the `catalog`, `schema` and `path` as defined in when
  initializing the connector.

## Usage

``` r
create_directory_cnt(connector_object, name, open = TRUE, ...)

# S3 method for class 'ConnectorDatabricksVolume'
create_directory_cnt(connector_object, name, open = TRUE, ...)
```

## Arguments

- connector_object:

  [Connector](https://novonordisk-opensource.github.io/connector/reference/Connector.html)
  The connector object to use.

- name:

  [character](https://rdrr.io/r/base/character.html) The name of the
  directory to create

- open:

  create a new connector object

- ...:

  [ConnectorDatabricksVolume](https://novonordisk-opensource.github.io/connector.databricks/reference/ConnectorDatabricksVolume.md):
  Additional parameters to pass to the
  [brickster::db_volume_dir_create](https://rdrr.io/pkg/brickster/man/db_volume_dir_create.html)
  method

## Value

[invisible](https://rdrr.io/r/base/invisible.html) connector_object.
