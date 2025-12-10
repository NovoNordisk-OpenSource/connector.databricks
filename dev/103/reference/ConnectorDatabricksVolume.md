# Connector for databricks volume storage

The ConnectorDatabricksVolume class, built on top of
[connector::connector](https://novonordisk-opensource.github.io/connector/reference/Connector.html)
class. It is a file storage connector for accessing and manipulating
files inside Databricks volumes.

## Super classes

[`connector::Connector`](https://novonordisk-opensource.github.io/connector/reference/Connector.html)
-\>
[`connector::ConnectorFS`](https://novonordisk-opensource.github.io/connector/reference/ConnectorFS.html)
-\> `ConnectorDatabricksVolume`

## Active bindings

- `path`:

  [character](https://rdrr.io/r/base/character.html) Path to the file
  storage on Volume

- `catalog`:

  [character](https://rdrr.io/r/base/character.html) Databricks catalog

- `schema`:

  [character](https://rdrr.io/r/base/character.html) Databricks schema

- `full_path`:

  [character](https://rdrr.io/r/base/character.html) Full path to the
  file storage on Volume

## Methods

### Public methods

- [`ConnectorDatabricksVolume$new()`](#method-ConnectorDatabricksVolume-new)

- [`ConnectorDatabricksVolume$clone()`](#method-ConnectorDatabricksVolume-clone)

Inherited methods

- [`connector::Connector$list_content_cnt()`](https://novonordisk-opensource.github.io/connector/reference/Connector.html#method-list_content_cnt)
- [`connector::Connector$print()`](https://novonordisk-opensource.github.io/connector/reference/Connector.html#method-print)
- [`connector::Connector$read_cnt()`](https://novonordisk-opensource.github.io/connector/reference/Connector.html#method-read_cnt)
- [`connector::Connector$remove_cnt()`](https://novonordisk-opensource.github.io/connector/reference/Connector.html#method-remove_cnt)
- [`connector::Connector$write_cnt()`](https://novonordisk-opensource.github.io/connector/reference/Connector.html#method-write_cnt)
- [`connector::ConnectorFS$create_directory_cnt()`](https://novonordisk-opensource.github.io/connector/reference/ConnectorFS.html#method-create_directory_cnt)
- [`connector::ConnectorFS$download_cnt()`](https://novonordisk-opensource.github.io/connector/reference/ConnectorFS.html#method-download_cnt)
- [`connector::ConnectorFS$download_directory_cnt()`](https://novonordisk-opensource.github.io/connector/reference/ConnectorFS.html#method-download_directory_cnt)
- [`connector::ConnectorFS$remove_directory_cnt()`](https://novonordisk-opensource.github.io/connector/reference/ConnectorFS.html#method-remove_directory_cnt)
- [`connector::ConnectorFS$tbl_cnt()`](https://novonordisk-opensource.github.io/connector/reference/ConnectorFS.html#method-tbl_cnt)
- [`connector::ConnectorFS$upload_cnt()`](https://novonordisk-opensource.github.io/connector/reference/ConnectorFS.html#method-upload_cnt)
- [`connector::ConnectorFS$upload_directory_cnt()`](https://novonordisk-opensource.github.io/connector/reference/ConnectorFS.html#method-upload_directory_cnt)

------------------------------------------------------------------------

### Method `new()`

Initializes the connector for Databricks volume storage.

#### Usage

    ConnectorDatabricksVolume$new(
      full_path = NULL,
      catalog = NULL,
      schema = NULL,
      path = NULL,
      extra_class = NULL,
      force = FALSE,
      ...
    )

#### Arguments

- `full_path`:

  [character](https://rdrr.io/r/base/character.html) Full path to the
  file storage in format `catalog/schema/path`. If NULL, `catalog`,
  `schema`, and `path` must be provided.

- `catalog`:

  [character](https://rdrr.io/r/base/character.html) Databricks catalog

- `schema`:

  [character](https://rdrr.io/r/base/character.html) Databricks schema

- `path`:

  [character](https://rdrr.io/r/base/character.html) Path to the file
  storage

- `extra_class`:

  [character](https://rdrr.io/r/base/character.html) Extra class to
  assign to the new connector.

- `force`:

  [logical](https://rdrr.io/r/base/logical.html) If TRUE, the volume
  will be created without asking if it does not exist.

- `...`:

  Additional arguments passed to the initialize method of superclass

#### Returns

A new ConnectorDatabricksVolume object

------------------------------------------------------------------------

### Method `clone()`

The objects of this class are cloneable with this method.

#### Usage

    ConnectorDatabricksVolume$clone(deep = FALSE)

#### Arguments

- `deep`:

  Whether to make a deep clone.

## Examples

``` r
if (FALSE) { # \dontrun{
# Create Volume file storage connector
cnt <- ConnectorDatabricksVolume$new(full_path = "catalog/schema/path")

cnt

# List content
cnt$list_content_cnt()

# Write to the connector
cnt$write_cnt(iris, "iris.rds")

# Check it is there
cnt$list_content_cnt()

# Read the result back
cnt$read_cnt("iris.rds") |>
  head()
} # }
```
