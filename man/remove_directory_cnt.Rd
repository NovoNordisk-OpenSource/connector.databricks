% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/connector_imports.R, R/volume_methods.R
\name{remove_directory_cnt}
\alias{remove_directory_cnt}
\alias{remove_directory_cnt.ConnectorDatabricksVolume}
\title{Remove a directory}
\usage{
remove_directory_cnt(connector_object, name, ...)

\method{remove_directory_cnt}{ConnectorDatabricksVolume}(connector_object, name, ...)
}
\arguments{
\item{connector_object}{\link[connector]{Connector} The connector object to use.}

\item{name}{\link{character} The name of the directory to remove}

\item{...}{\link{ConnectorDatabricksVolume}: Additional parameters to pass to
the \code{\link[brickster:db_volume_dir_delete]{brickster::db_volume_dir_delete()}} method}
}
\value{
\link{ConnectorDatabricksVolume} object
}
\description{
Addition list content methods for databricks connectors implemented for
\code{\link[connector:remove_directory_cnt]{connector::remove_directory_cnt()}}:
}
