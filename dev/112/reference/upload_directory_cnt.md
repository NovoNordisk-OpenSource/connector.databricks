# Upload a directory

Additional list content methods for Databricks connectors implemented
for
[`connector::upload_directory_cnt()`](https://novonordisk-opensource.github.io/connector/reference/upload_directory_cnt.html):

- [ConnectorDatabricksVolume](https://novonordisk-opensource.github.io/connector.databricks/reference/ConnectorDatabricksVolume.md):
  Reuses the
  [`connector::upload_directory_cnt()`](https://novonordisk-opensource.github.io/connector/reference/upload_directory_cnt.html)
  method for
  [ConnectorDatabricksVolume](https://novonordisk-opensource.github.io/connector.databricks/reference/ConnectorDatabricksVolume.md),
  but always sets the `catalog`, `schema` and `path` as defined in when
  initializing the connector.

## Usage

``` r
upload_directory_cnt(
  connector_object,
  src,
  dest,
  overwrite = zephyr::get_option("overwrite", "connector"),
  open = FALSE,
  ...
)

# S3 method for class 'ConnectorDatabricksVolume'
upload_directory_cnt(
  connector_object,
  src,
  dest = basename(src),
  overwrite = zephyr::get_option("overwrite", "connector"),
  open = FALSE,
  ...
)
```

## Arguments

- connector_object:

  [Connector](https://novonordisk-opensource.github.io/connector/reference/Connector.html)
  The connector object to use.

- src:

  [character](https://rdrr.io/r/base/character.html) Path to the
  directory to upload

- dest:

  [character](https://rdrr.io/r/base/character.html) The name of the new
  directory to place the content in

- overwrite:

  Overwrite existing content if it exists in the connector? See
  [connector-options](https://novonordisk-opensource.github.io/connector/reference/connector-options.html)
  for details. Default can be set globally with
  `options(connector.overwrite = TRUE/FALSE)` or environment variable
  `R_CONNECTOR_OVERWRITE`.. Default: `FALSE`.

- open:

  [logical](https://rdrr.io/r/base/logical.html) Open the directory as a
  new connector object.

- ...:

  [ConnectorDatabricksVolume](https://novonordisk-opensource.github.io/connector.databricks/reference/ConnectorDatabricksVolume.md):
  Additional parameters to pass to the
  [`brickster::db_volume_dir_create()`](https://rdrr.io/pkg/brickster/man/db_volume_dir_create.html)
  method

## Value

[invisible](https://rdrr.io/r/base/invisible.html) connector_object.
