# Choosing between ConnectorDatabricksSQL and ConnectorDatabricksTable

## Introduction

connector.databricks has two connectors for Databricks tables:

- `ConnectorDatabricksSQL`, created with
  [`connector_databricks_sql()`](https://novonordisk-opensource.github.io/connector.databricks/reference/connector_databricks_sql.md).
  It connects to a SQL warehouse through the
  [`brickster::DatabricksSQL()`](https://rdrr.io/pkg/brickster/man/DatabricksSQL.html)
  DBI driver.
- `ConnectorDatabricksTable`, created with
  [`connector_databricks_table()`](https://novonordisk-opensource.github.io/connector.databricks/reference/connector_databricks_table.md).
  It connects to a cluster through the
  [`odbc::databricks()`](https://odbc.r-dbi.org/reference/databricks.html)
  DBI driver.

`ConnectorDatabricksSQL` is the preferred way of working with tables and
is where new development happens. `ConnectorDatabricksTable` is still
available for existing code and for features `ConnectorDatabricksSQL`
does not have yet. This article compares the two and shows how to move
from one to the other.

## At a glance

|  | `ConnectorDatabricksSQL` | `ConnectorDatabricksTable` |
|----|----|----|
| Constructor | `connector_databricks_sql(warehouse_id, catalog, schema)` | `connector_databricks_table(http_path, catalog, schema)` |
| DBI driver | [`brickster::DatabricksSQL()`](https://rdrr.io/pkg/brickster/man/DatabricksSQL.html) | [`odbc::databricks()`](https://odbc.r-dbi.org/reference/databricks.html) |
| Compute | The SQL warehouse given by `warehouse_id` | The cluster given by `http_path`, and the first SQL warehouse returned by [`brickster::db_sql_warehouse_list()`](https://rdrr.io/pkg/brickster/man/db_sql_warehouse_list.html) |
| System requirements | None | Databricks ODBC driver |
| Authentication | brickster | odbc and brickster |
| `...` is passed to | [`DBI::dbConnect()`](https://dbi.r-dbi.org/reference/dbConnect.html) for [`brickster::DatabricksSQL()`](https://rdrr.io/pkg/brickster/man/DatabricksSQL.html) | [`DBI::dbConnect()`](https://dbi.r-dbi.org/reference/dbConnect.html) for [`odbc::databricks()`](https://odbc.r-dbi.org/reference/databricks.html) |
| [`write_cnt()`](https://novonordisk-opensource.github.io/connector.databricks/reference/write_cnt.md) | `brickster::dbWriteTable()`, optionally through a staging volume | Always through a temporary volume |
| Appending rows | `append = TRUE` | Not supported |
| [`read_cnt()`](https://novonordisk-opensource.github.io/connector.databricks/reference/read_cnt.md) | [`DBI::dbReadTable()`](https://dbi.r-dbi.org/reference/dbReadTable.html) | Arrow results from the SQL warehouse |
| [`list_content_cnt()`](https://novonordisk-opensource.github.io/connector.databricks/reference/list_content_cnt.md) | [`DBI::dbListTables()`](https://dbi.r-dbi.org/reference/dbListTables.html) | Unity Catalog API |
| [`remove_cnt()`](https://novonordisk-opensource.github.io/connector.databricks/reference/remove_cnt.md) | [`DBI::dbRemoveTable()`](https://dbi.r-dbi.org/reference/dbRemoveTable.html) | Unity Catalog API |
| [`tbl_cnt()`](https://novonordisk-opensource.github.io/connector.databricks/reference/tbl_cnt.md) | dbplyr, executed on the SQL warehouse | dbplyr, executed on the cluster |
| whirl logging | Not supported yet | Supported |

## Compute and authentication

`ConnectorDatabricksSQL` does everything on one SQL warehouse, and only
needs the brickster authentication described in [this
article](https://databrickslabs.github.io/brickster/articles/setup-auth.html).
No system libraries are needed. `warehouse_id` defaults to the
`DATABRICKS_WAREHOUSE_ID` environment variable, and the IDs of the
warehouses you can use are listed by
[`brickster::db_sql_warehouse_list()`](https://rdrr.io/pkg/brickster/man/db_sql_warehouse_list.html).

`ConnectorDatabricksTable` opens its DBI connection to the cluster in
`http_path` with
[`odbc::databricks()`](https://odbc.r-dbi.org/reference/databricks.html),
which needs the Databricks ODBC driver. That connection is only used by
[`tbl_cnt()`](https://novonordisk-opensource.github.io/connector.databricks/reference/tbl_cnt.md).
Reading, writing, listing, removing and tagging tables are done with
brickster, on the first SQL warehouse returned by
[`brickster::db_sql_warehouse_list()`](https://rdrr.io/pkg/brickster/man/db_sql_warehouse_list.html).
It therefore needs both odbc and brickster authentication, and you
cannot choose which warehouse is used. See
[`vignette("articles/authentication")`](https://novonordisk-opensource.github.io/connector.databricks/articles/authentication.md)
for how to set up both.

## Writing

`ConnectorDatabricksSQL` writes with `brickster::dbWriteTable()`.
Without a staging volume the data is sent inside the SQL statement,
which is slow for large data and limited to 50,000 rows. With
`staging_volume` set, the data is uploaded as Parquet files to the
volume first. Use a staging volume for anything but small tables:

``` r

con <- connector_databricks_sql(
  warehouse_id = "your-warehouse-id",
  catalog = "my_catalog",
  schema = "my_schema",
  staging_volume = "/Volumes/my_catalog/my_schema/my_volume"
)
```

`ConnectorDatabricksTable` always writes through a temporary volume that
it creates and removes for every write.

See
[`vignette("articles/read_write")`](https://novonordisk-opensource.github.io/connector.databricks/articles/read_write.md)
for details on both.

## Driver parameters

Both constructors pass `...` on to
[`DBI::dbConnect()`](https://dbi.r-dbi.org/reference/dbConnect.html) for
their driver.

For `ConnectorDatabricksSQL` these are the arguments of the brickster
driver, for example `disposition`, `fetch_timeout`,
`max_active_connections`, `show_progress`, `host` or `token`:

``` r

con <- connector_databricks_sql(
  warehouse_id = "your-warehouse-id",
  catalog = "my_catalog",
  schema = "my_schema",
  fetch_timeout = 600,
  show_progress = FALSE
)
```

For `ConnectorDatabricksTable` these are the arguments of
[`odbc::databricks()`](https://odbc.r-dbi.org/reference/databricks.html),
for example `workspace`, `uid`, `pwd` or `driver`. `useNativeQuery`
defaults to `FALSE` and can be overridden:

``` r

con <- connector_databricks_table(
  http_path = "path-to-cluster",
  catalog = "my_catalog",
  schema = "my_schema",
  workspace = "https://<workspace>.cloud.databricks.com"
)
```

## Moving from ConnectorDatabricksTable to ConnectorDatabricksSQL

Replace `http_path` with the ID of the SQL warehouse you want to use. If
your `http_path` already points to a SQL warehouse, it has the form
`/sql/1.0/warehouses/<warehouse-id>` and the last part is the ID.

``` r

# Before
con <- connector_databricks_table(
  http_path = "/sql/1.0/warehouses/abc123",
  catalog = "my_catalog",
  schema = "my_schema"
)

# After
con <- connector_databricks_sql(
  warehouse_id = "abc123",
  catalog = "my_catalog",
  schema = "my_schema"
)
```

In a connector configuration file, change the backend `type` and replace
`http_path` with `warehouse_id`:

``` yaml
# Before
datasources:
  - name: "tables"
    backend:
      type: "connector.databricks::connector_databricks_table"
      http_path: "/sql/1.0/warehouses/abc123"
      catalog: "my_catalog"
      schema: "my_schema"

# After
datasources:
  - name: "tables"
    backend:
      type: "connector.databricks::connector_databricks_sql"
      warehouse_id: "abc123"
      catalog: "my_catalog"
      schema: "my_schema"
```

Calls to
[`read_cnt()`](https://novonordisk-opensource.github.io/connector.databricks/reference/read_cnt.md),
[`write_cnt()`](https://novonordisk-opensource.github.io/connector.databricks/reference/write_cnt.md),
[`list_content_cnt()`](https://novonordisk-opensource.github.io/connector.databricks/reference/list_content_cnt.md),
[`remove_cnt()`](https://novonordisk-opensource.github.io/connector.databricks/reference/remove_cnt.md)
and
[`tbl_cnt()`](https://novonordisk-opensource.github.io/connector.databricks/reference/tbl_cnt.md)
stay the same, except for the `timepoint`, `version` and `tags`
arguments, which `ConnectorDatabricksSQL` does not have. Consider
setting `staging_volume` if you write tables with more than a few
thousand rows.
