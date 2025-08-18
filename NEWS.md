# connector.databricks 0.0.6

## Breaking Changes

### Parameter Name Changes in Volume Methods

**BREAKING:** The following methods have renamed parameters to improve consistency:

- `upload_cnt()`: `file` → `src`, `name` → `dest`
- `download_cnt()`: `name` → `src`, `file` → `dest`  
- `upload_directory_cnt()`: `dir` → `src`, `name` → `dest`
- `download_directory_cnt()`: `name` → `src`, `dir` → `dest`

#### Migration Examples

**Before:**
```r
# Old parameter names
conn$upload_cnt(file = "local_file.csv", name = "remote_file.csv")
conn$download_cnt(name = "remote_file.csv", file = "local_file.csv")
conn$upload_directory_cnt(dir = "local_dir", name = "remote_dir")  
conn$download_directory_cnt(name = "remote_dir", dir = "local_dir")
```

**After:**
```r  
# New parameter names
conn$upload_cnt(src = "local_file.csv", dest = "remote_file.csv")
conn$download_cnt(src = "remote_file.csv", dest = "local_file.csv")
conn$upload_directory_cnt(src = "local_dir", dest = "remote_dir")
conn$download_directory_cnt(src = "remote_dir", dest = "local_dir")
```

## New features and improvements

* Fix naming convention in `upload_directory_cnt.DatabricksVolume` [#84](https://github.com/NovoNordisk-OpenSource/connector.databricks/issues/84)
* Added `Connecting to cluster, please wait..` as a zephyr::msg_info prior to initialization of table and volume connection
* Set dependency `brickster (>= 0.2.7)`
* Add github templates for issues, features and PRs
* Updated `volume_methods` to use zephyr::msg_info(), replacing cli::cli_alert()
* Updated `volume_methods`, `table_utils` and `table_methods` to use zephyr::get_option() replacing a bool
* Updated tests to use zephyr-option, with verbosity = quiet
* Fix bug regarding empty tables [#73](https://github.com/NovoNordisk-OpenSource/connector.databricks/issues/73)
* Fix tmp volume bug [#63](https://github.com/NovoNordisk-OpenSource/connector.databricks/issues/63)
* Add `upload_directory_cnt()` and `download_directory_cnt()` methods for
`ConnectorDatabricksVolume` class. Solves [#77](https://github.com/NovoNordisk-OpenSource/connector.databricks/issues/77)
* Update `remove_directory_cnt()` method for `ConnectorDatabricksVolume` class, now iterates over directories and erases all the subdirectories and files. Solves [#78](https://github.com/NovoNordisk-OpenSource/connector.databricks/issues/78)
* Update `connector` dependency to `0.1.0` official CRAN version.

# connector.databricks 0.0.5

## New features and improvements

* Update `write_cnt()` to use temporary volume solution, in order to allow upload of bigger files.
* Update `list_content_cnt()` to use tags when listing tables in Databricks.
* Update `read_cnt()` to allow users to search tables using either `timepoint` or `version` parameter.
* Remove `DatabricksClient()` and replace table and volume methods with `brickster` methods.

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
