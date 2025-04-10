% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/volume_api.R
\name{delete_databricks_volume}
\alias{delete_databricks_volume}
\title{Delete Databricks volume}
\usage{
delete_databricks_volume(
  name,
  catalog_name = NULL,
  schema_name = NULL,
  client = DatabricksClient()
)
}
\arguments{
\item{name}{Name of a new volume}

\item{catalog_name}{The name of the catalog where the schema and the volume
are.}

\item{schema_name}{The name of the schema where the volume will be created.}

\item{client}{Instance of DatabricksClient().}
}
\description{
Deletes a volume from the specified parent catalog and schema.
}
\details{
More details can be found here:
https://docs.databricks.com/api/workspace/volumes/delete
}
\examples{
\dontshow{if (FALSE) (if (getRversion() >= "3.4") withAutoprint else force)(\{ # examplesIf}
# In order to connect to databricks on environments where configurations are
# available via the environment variable DATABRICKS_CONFIG_FILE or located
# at ~/.databrickscfg - simply write
db_client <- DatabricksClient()
# To check if connection is established
open_connection <- db_client$debug_string() != ""

if (open_connection) {
  connector.databricks::delete_databricks_volume(
    client = db_client,
    name = "new_volume",
    catalog_name = "amace_cdr_bronze_dev",
    schema_name = "my_study_adam"
  )
}
\dontshow{\}) # examplesIf}
}
