# connector.databricks 0.0.4.9000

## New features and improvements

* Update `write_cnt()` to use temporary volume solution, in order to allow upload of bigger files.

# connector.databricks 0.0.4

* Minor tweaks to the DESCRIPTION file. Removed references to 'external' non-CRAN GitHub packages.

# connector.databricks 0.0.3

## Breaking Changes

* Major renaming: `connector_databricks_dbi` is now `ConnectorDatabricksTable`. This affects several methods and functions throughout the package.
* A wrapper function has been added for better consistency with other connector packages `connector_databricks_table`
* The dependency on `connector` has been updated to use 0.0.8

## New Features and Improvements

* Refactored API for better consistency with the `connector` package.
* Updated methods for `list_content_cnt`, `log_read_connector`, `log_write_connector`, and `log_remove_connector` to use the new structure.

## Documentation Changes

* Comprehensive update of documentation to reflect naming and structure changes.
* Revised examples in the README to use the new nomenclature.

## Internal Changes

* Renamed `volume_api.R` file to `volumes_api.R`.
* Updated _pkgdown.yml file to reflect the new package structure.

# connector.databricks 0.0.1
* Initial release to internal package manager
