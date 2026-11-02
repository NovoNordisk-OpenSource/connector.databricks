# Write content to the connector

Additional write methods for Databricks connectors implemented for
[`connector::write_cnt()`](https://novonordisk-opensource.github.io/connector/reference/write_cnt.html):

- [ConnectorDatabricksSQL](https://novonordisk-opensource.github.io/connector.databricks/reference/ConnectorDatabricksSQL.md):
  Reuses the
  [`connector::write_cnt()`](https://novonordisk-opensource.github.io/connector/reference/write_cnt.html)
  method for
  [ConnectorDatabricksSQL](https://novonordisk-opensource.github.io/connector.databricks/reference/ConnectorDatabricksSQL.md),
  but always sets the `catalog`, `schema` and `staging_volume` as
  defined in when initializing the connector.

&nbsp;

- [ConnectorDatabricksTable](https://novonordisk-opensource.github.io/connector.databricks/reference/ConnectorDatabricksTable.md):
  Reuses the
  [`connector::write_cnt()`](https://novonordisk-opensource.github.io/connector/reference/write_cnt.html)
  method for
  [ConnectorDatabricksTable](https://novonordisk-opensource.github.io/connector.databricks/reference/ConnectorDatabricksTable.md),
  but always sets the `catalog` and `schema` as defined in when
  initializing the connector. Creates temporary volume to write object
  as a parquet file and then convert it to a table.

&nbsp;

- [ConnectorDatabricksVolume](https://novonordisk-opensource.github.io/connector.databricks/reference/ConnectorDatabricksVolume.md):
  Reuses the
  [`connector::write_cnt()`](https://novonordisk-opensource.github.io/connector/reference/write_cnt.html)
  method for
  [ConnectorDatabricksVolume](https://novonordisk-opensource.github.io/connector.databricks/reference/ConnectorDatabricksVolume.md),
  but always sets the `catalog`, `schema` and `path` as defined in when
  initializing the connector.

## Usage

``` r
write_cnt(
  connector_object,
  x,
  name,
  overwrite = zephyr::get_option("overwrite", "connector"),
  ...
)

# S3 method for class 'ConnectorDatabricksSQL'
write_cnt(
  connector_object,
  x,
  name,
  overwrite = zephyr::get_option("overwrite", "connector.databricks"),
  ...
)

# S3 method for class 'ConnectorDatabricksTable'
write_cnt(
  connector_object,
  x,
  name,
  overwrite = zephyr::get_option("overwrite", "connector.databricks"),
  ...,
  method = "volume",
  tags = NULL
)

# S3 method for class 'ConnectorDatabricksVolume'
write_cnt(
  connector_object,
  x,
  name,
  overwrite = zephyr::get_option("overwrite", "connector.databricks"),
  ...
)
```

## Arguments

- connector_object:

  [Connector](https://novonordisk-opensource.github.io/connector/reference/Connector.html)
  The connector object to use.

- x:

  The object to write to the connection

- name:

  [character](https://rdrr.io/r/base/character.html) Name of the content
  to read, write, or remove. Typically the table name.

- overwrite:

  Overwrite existing content if it exists in the connector.

- ...:

  [ConnectorDatabricksVolume](https://novonordisk-opensource.github.io/connector.databricks/reference/ConnectorDatabricksVolume.md):
  Additional parameters to pass to the
  [`brickster::db_volume_write()`](https://rdrr.io/pkg/brickster/man/db_volume_write.html)
  method

- method:

  - [ConnectorDatabricksTable](https://novonordisk-opensource.github.io/connector.databricks/reference/ConnectorDatabricksTable.md):
    Which method to use for writing the table. Options:

    - `volume` - using temporary volume to write data and then convert
      it to a table.

- tags:

  - [ConnectorDatabricksTable](https://novonordisk-opensource.github.io/connector.databricks/reference/ConnectorDatabricksTable.md):
    Named list containing tag names and tag values, e.g.
    `list("tag_name1" = "tag_value1", "tag_name2" = "tag_value2")`. More
    info
    [here](https://docs.databricks.com/aws/en/database-objects/tags)

## Value

[invisible](https://rdrr.io/r/base/invisible.html) connector_object.
