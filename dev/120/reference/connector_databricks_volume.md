# Create databricks volume connector

Create a new databricks volume connector object. See
[ConnectorDatabricksVolume](https://novonordisk-opensource.github.io/connector.databricks/reference/ConnectorDatabricksVolume.md)
for details.

Initializes the connector for Databricks volume storage.

## Usage

``` r
connector_databricks_volume(
  full_path = NULL,
  catalog = NULL,
  schema = NULL,
  path = NULL,
  extra_class = NULL,
  force = FALSE,
  ...
)
```

## Arguments

- full_path:

  Full path to the file storage in format `catalog/schema/path`. If
  NULL, `catalog`, `schema`, and `path` must be provided.

- catalog:

  Databricks catalog

- schema:

  Databricks schema

- path:

  Path to the file storage

- extra_class:

  Extra class to assign to the new connector.

- force:

  If TRUE, the volume will be created without asking if it does not
  exist.

- ...:

  Additional arguments passed to the
  [connector::connector](https://novonordisk-opensource.github.io/connector/reference/Connector.html)

## Value

A new
[ConnectorDatabricksVolume](https://novonordisk-opensource.github.io/connector.databricks/reference/ConnectorDatabricksVolume.md)
object

## Details

The `extra_class` parameter allows you to create a subclass of the
`ConnectorDatabricksVolume` object. This can be useful if you want to
create a custom connection object for easier dispatch of new s3 methods,
while still inheriting the methods from the `ConnectorDatabricksVolume`
object.

## Examples

``` r
if (FALSE) { # \dontrun{
# Connect to a file system
databricks_volume <- "catalog/schema/path"
db <- connector_databricks_volume(databricks_volume)

db

# Create subclass connection
db_subclass <- connector_databricks_volume(databricks_volume,
  extra_class = "subclass"
)

db_subclass
class(db_subclass)
} # }
```
