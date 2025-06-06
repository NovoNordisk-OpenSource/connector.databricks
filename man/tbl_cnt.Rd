% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/connector_imports.R, R/table_methods.R,
%   R/volume_methods.R
\name{tbl_cnt}
\alias{tbl_cnt}
\alias{tbl_cnt.ConnectorDatabricksTable}
\alias{tbl_cnt.ConnectorDatabricksVolume}
\title{Use dplyr verbs to interact with the remote database table}
\usage{
tbl_cnt(connector_object, name, ...)

\method{tbl_cnt}{ConnectorDatabricksTable}(connector_object, name, ...)

\method{tbl_cnt}{ConnectorDatabricksVolume}(connector_object, name, ...)
}
\arguments{
\item{connector_object}{\link[connector]{Connector} The connector object to use.}

\item{name}{\link{character} Name of the content to read, write, or remove. Typically the table name.}

\item{...}{Additional arguments passed to the method for the individual connector.}
}
\value{
A \link[dplyr:tbl]{dplyr::tbl} object.
}
\description{
Addition tbl methods for databricks connectors implemented for
\code{\link[connector:tbl_cnt]{connector::tbl_cnt()}}:

\itemize{
\item \link{ConnectorDatabricksTable}: Reuses the \code{\link[connector:tbl_cnt]{connector::tbl_cnt()}} method for
\link[connector:connector_dbi]{connector::connector_dbi}, but always sets the \code{catalog} and \code{schema} as
defined in when initializing the connector.
}

\itemize{
\item \link{ConnectorDatabricksVolume}: Uses \code{\link[=read_cnt]{read_cnt()}} to allow redundancy between Volumes and DBI.
}
}
