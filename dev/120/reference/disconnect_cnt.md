# Disconnect (close) the connection of the connector

Generic implementing of how to disconnect from the relevant connections.
Mostly relevant for DBI connectors.

- [ConnectorDBI](https://novonordisk-opensource.github.io/connector/reference/ConnectorDBI.html):
  Uses
  [`DBI::dbDisconnect()`](https://dbi.r-dbi.org/reference/dbDisconnect.html)
  to create a table reference to close a DBI connection.

## Usage

``` r
disconnect_cnt(connector_object, ...)
```

## Arguments

- connector_object:

  [Connector](https://novonordisk-opensource.github.io/connector/reference/Connector.html)
  The connector object to use.

- ...:

  Additional arguments passed to the method for the individual
  connector.

## Value

[invisible](https://rdrr.io/r/base/invisible.html) connector_object.
