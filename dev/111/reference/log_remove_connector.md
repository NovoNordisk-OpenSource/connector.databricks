# Connector Logging Functions

- [ConnectorDatabricksTable](https://novonordisk-opensource.github.io/connector.databricks/reference/ConnectorDatabricksTable.md):
  Implementation of the `log_remove_connector` function for the
  ConnectorDatabricksTable class.

&nbsp;

- [ConnectorDatabricksVolume](https://novonordisk-opensource.github.io/connector.databricks/reference/ConnectorDatabricksVolume.md):
  Implementation of the `log_remove_connector` function for the
  ConnectorDatabricksVolume class.

Additional log remove methods for Databricks connectors implemented for
[`connector::log_remove_connector()`](https://novonordisk-opensource.github.io/connector/reference/log-functions.html):

## Usage

``` r
# S3 method for class 'ConnectorDatabricksTable'
log_remove_connector(connector_object, name, ...)

# S3 method for class 'ConnectorDatabricksVolume'
log_remove_connector(connector_object, name, ...)

log_remove_connector(connector_object, name, ...)
```

## Arguments

- connector_object:

  The connector object to log operations for. Can be any connector class
  (ConnectorFS, ConnectorDBI, ConnectorLogger, etc.)

- name:

  Character string specifying the name or identifier of the resource
  being operated on (e.g., file name, table name)

- ...:

  Additional parameters passed to specific method implementations. May
  include connector-specific options or metadata.

## Value

These are primarily side-effect functions that perform logging. The
actual return value depends on the specific method implementation,
typically:

- `log_read_connector`: Result of the read operation

- `log_write_connector`: Invisible result of write operation

- `log_remove_connector`: Invisible result of remove operation

- `log_list_content_connector`: List of connector contents

## Details

Connector Logging Functions

The logging system is built around S3 generic functions that dispatch to
specific implementations based on the connector class. Each operation is
logged with contextual information including connector details,
operation type, and resource names.
