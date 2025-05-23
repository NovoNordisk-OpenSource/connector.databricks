% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/table.R
\name{ConnectorDatabricksTable}
\alias{ConnectorDatabricksTable}
\title{Connector for connecting to Databricks using DBI}
\description{
Extension of the \link[connector:connector_dbi]{connector::connector_dbi} making it easier to connect to,
and work with tables in Databricks.
}
\details{
All methods for \link{ConnectorDatabricksTable} object are working from the
catalog and schema provided when initializing the connection.
This means you only need to provide the table name when using the built in
methods. If you want to access tables outside of the chosen schema, you can
either retrieve the connection with \code{ConnectorDatabricksTable$conn} or create
a new connector.

When creating the connections to Databricks you either need to provide the
sqlpath to Databricks cluster or the SQL warehouse you want to connect to.
Authentication to databricks is handed by the \code{odbc::databricks()} driver and
supports general use of personal access tokens and credentials through Posit
Workbench. See also \code{\link[odbc:databricks]{odbc::databricks()}} On more information on how the
connection to Databricks is established.
}
\examples{
\dontshow{if (FALSE) (if (getRversion() >= "3.4") withAutoprint else force)(\{ # examplesIf}
# Establish connection to your cluster

con_databricks <- ConnectorDatabricksTable$new(
  http_path = "path-to-cluster",
  catalog = "my_catalog",
  schema = "my_schema"
)

# List tables in my_schema

con_databricks$list_content()

# Read and write tables

con_databricks$write(mtcars, "my_mtcars_table")

con_databricks$read("my_mtcars_table")

# Use dplyr::tbl

con_databricks$tbl("my_mtcars_table")

# Remove table

con_databricks$remove("my_mtcars_table")

# Disconnect

con_databricks$disconnect()
\dontshow{\}) # examplesIf}
}
\section{Super classes}{
\code{\link[connector:Connector]{connector::Connector}} -> \code{\link[connector:ConnectorDBI]{connector::ConnectorDBI}} -> \code{ConnectorDatabricksTable}
}
\section{Active bindings}{
\if{html}{\out{<div class="r6-active-bindings">}}
\describe{
\item{\code{conn}}{The DBI connection object of the connector}

\item{\code{catalog}}{The catalog used in the connector}

\item{\code{schema}}{The schema used in the connector}
}
\if{html}{\out{</div>}}
}
\section{Methods}{
\subsection{Public methods}{
\itemize{
\item \href{#method-ConnectorDatabricksTable-new}{\code{ConnectorDatabricksTable$new()}}
\item \href{#method-ConnectorDatabricksTable-clone}{\code{ConnectorDatabricksTable$clone()}}
}
}
\if{html}{\out{
<details><summary>Inherited methods</summary>
<ul>
<li><span class="pkg-link" data-pkg="connector" data-topic="Connector" data-id="list_content_cnt"><a href='../../connector/html/Connector.html#method-Connector-list_content_cnt'><code>connector::Connector$list_content_cnt()</code></a></span></li>
<li><span class="pkg-link" data-pkg="connector" data-topic="Connector" data-id="print"><a href='../../connector/html/Connector.html#method-Connector-print'><code>connector::Connector$print()</code></a></span></li>
<li><span class="pkg-link" data-pkg="connector" data-topic="Connector" data-id="read_cnt"><a href='../../connector/html/Connector.html#method-Connector-read_cnt'><code>connector::Connector$read_cnt()</code></a></span></li>
<li><span class="pkg-link" data-pkg="connector" data-topic="Connector" data-id="remove_cnt"><a href='../../connector/html/Connector.html#method-Connector-remove_cnt'><code>connector::Connector$remove_cnt()</code></a></span></li>
<li><span class="pkg-link" data-pkg="connector" data-topic="Connector" data-id="write_cnt"><a href='../../connector/html/Connector.html#method-Connector-write_cnt'><code>connector::Connector$write_cnt()</code></a></span></li>
<li><span class="pkg-link" data-pkg="connector" data-topic="ConnectorDBI" data-id="disconnect_cnt"><a href='../../connector/html/ConnectorDBI.html#method-ConnectorDBI-disconnect_cnt'><code>connector::ConnectorDBI$disconnect_cnt()</code></a></span></li>
<li><span class="pkg-link" data-pkg="connector" data-topic="ConnectorDBI" data-id="tbl_cnt"><a href='../../connector/html/ConnectorDBI.html#method-ConnectorDBI-tbl_cnt'><code>connector::ConnectorDBI$tbl_cnt()</code></a></span></li>
</ul>
</details>
}}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-ConnectorDatabricksTable-new"></a>}}
\if{latex}{\out{\hypertarget{method-ConnectorDatabricksTable-new}{}}}
\subsection{Method \code{new()}}{
Initialize the connection to Databricks
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{ConnectorDatabricksTable$new(http_path, catalog, schema, extra_class = NULL)}\if{html}{\out{</div>}}
}

\subsection{Arguments}{
\if{html}{\out{<div class="arguments">}}
\describe{
\item{\code{http_path}}{\link{character} The path to the Databricks cluster or SQL
warehouse you want to connect to}

\item{\code{catalog}}{\link{character} The catalog to use}

\item{\code{schema}}{\link{character} The schema to use}

\item{\code{extra_class}}{\link{character} Extra class to assign to the new connector}
}
\if{html}{\out{</div>}}
}
\subsection{Returns}{
A \link{ConnectorDatabricksTable} object
}
}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-ConnectorDatabricksTable-clone"></a>}}
\if{latex}{\out{\hypertarget{method-ConnectorDatabricksTable-clone}{}}}
\subsection{Method \code{clone()}}{
The objects of this class are cloneable with this method.
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{ConnectorDatabricksTable$clone(deep = FALSE)}\if{html}{\out{</div>}}
}

\subsection{Arguments}{
\if{html}{\out{<div class="arguments">}}
\describe{
\item{\code{deep}}{Whether to make a deep clone.}
}
\if{html}{\out{</div>}}
}
}
}
