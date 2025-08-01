% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/connector_imports.R, R/table_methods.R,
%   R/volume_methods.R
\name{remove_cnt}
\alias{remove_cnt}
\alias{remove_cnt.ConnectorDatabricksTable}
\alias{remove_cnt.ConnectorDatabricksVolume}
\title{Remove content from the connector}
\usage{
remove_cnt(connector_object, name, ...)

\method{remove_cnt}{ConnectorDatabricksTable}(connector_object, name, ...)

\method{remove_cnt}{ConnectorDatabricksVolume}(connector_object, name, ...)
}
\arguments{
\item{connector_object}{\link[connector]{Connector} The connector object to use.}

\item{name}{\link{character} Name of the content to read, write, or remove. Typically the table name.}

\item{...}{\link{ConnectorDatabricksTable}: Additional parameters to pass to the
\code{\link[brickster:db_uc_tables_delete]{brickster::db_uc_tables_delete()}} method}
}
\value{
\link{invisible} connector_object.
}
\description{
Additional remove methods for Databricks connectors implemented for
\code{\link[connector:remove_cnt]{connector::remove_cnt()}}:

\itemize{
\item \link{ConnectorDatabricksTable}: Reuses the \code{\link[connector:list_content_cnt]{connector::list_content_cnt()}}
method for \link{ConnectorDatabricksTable}, but always
sets the \code{catalog} and \code{schema} as defined in when initializing the
connector.
}

\itemize{
\item \link{ConnectorDatabricksVolume}: Reuses the \code{\link[connector:remove_cnt]{connector::remove_cnt()}}
method for \link{ConnectorDatabricksVolume}, but always
sets the \code{catalog}, \code{schema} and \code{path} as defined in when initializing the
connector.
}
}
