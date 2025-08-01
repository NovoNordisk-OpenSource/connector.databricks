% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/volume.R
\name{ConnectorDatabricksVolume}
\alias{ConnectorDatabricksVolume}
\title{Connector for databricks volume storage}
\description{
The ConnectorDatabricksVolume class, built on top of \link[connector:Connector]{connector::connector}
class. It is a file storage connector for accessing and manipulating files
inside Databricks volumes.
}
\examples{
\dontshow{if (FALSE) (if (getRversion() >= "3.4") withAutoprint else force)(\{ # examplesIf}
# Create Volume file storage connector
cnt <- ConnectorDatabricksVolume$new(full_path = "catalog/schema/path")

cnt

# List content
cnt$list_content_cnt()

# Write to the connector
cnt$write_cnt(iris, "iris.rds")

# Check it is there
cnt$list_content_cnt()

# Read the result back
cnt$read_cnt("iris.rds") |>
  head()
\dontshow{\}) # examplesIf}
}
\section{Super classes}{
\code{\link[connector:Connector]{connector::Connector}} -> \code{\link[connector:ConnectorFS]{connector::ConnectorFS}} -> \code{ConnectorDatabricksVolume}
}
\section{Active bindings}{
\if{html}{\out{<div class="r6-active-bindings">}}
\describe{
\item{\code{path}}{\link{character} Path to the file storage on Volume}

\item{\code{catalog}}{\link{character} Databricks catalog}

\item{\code{schema}}{\link{character} Databricks schema}

\item{\code{full_path}}{\link{character} Full path to the file storage on Volume}
}
\if{html}{\out{</div>}}
}
\section{Methods}{
\subsection{Public methods}{
\itemize{
\item \href{#method-ConnectorDatabricksVolume-new}{\code{ConnectorDatabricksVolume$new()}}
\item \href{#method-ConnectorDatabricksVolume-clone}{\code{ConnectorDatabricksVolume$clone()}}
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
<li><span class="pkg-link" data-pkg="connector" data-topic="ConnectorFS" data-id="create_directory_cnt"><a href='../../connector/html/ConnectorFS.html#method-ConnectorFS-create_directory_cnt'><code>connector::ConnectorFS$create_directory_cnt()</code></a></span></li>
<li><span class="pkg-link" data-pkg="connector" data-topic="ConnectorFS" data-id="download_cnt"><a href='../../connector/html/ConnectorFS.html#method-ConnectorFS-download_cnt'><code>connector::ConnectorFS$download_cnt()</code></a></span></li>
<li><span class="pkg-link" data-pkg="connector" data-topic="ConnectorFS" data-id="download_directory_cnt"><a href='../../connector/html/ConnectorFS.html#method-ConnectorFS-download_directory_cnt'><code>connector::ConnectorFS$download_directory_cnt()</code></a></span></li>
<li><span class="pkg-link" data-pkg="connector" data-topic="ConnectorFS" data-id="remove_directory_cnt"><a href='../../connector/html/ConnectorFS.html#method-ConnectorFS-remove_directory_cnt'><code>connector::ConnectorFS$remove_directory_cnt()</code></a></span></li>
<li><span class="pkg-link" data-pkg="connector" data-topic="ConnectorFS" data-id="tbl_cnt"><a href='../../connector/html/ConnectorFS.html#method-ConnectorFS-tbl_cnt'><code>connector::ConnectorFS$tbl_cnt()</code></a></span></li>
<li><span class="pkg-link" data-pkg="connector" data-topic="ConnectorFS" data-id="upload_cnt"><a href='../../connector/html/ConnectorFS.html#method-ConnectorFS-upload_cnt'><code>connector::ConnectorFS$upload_cnt()</code></a></span></li>
<li><span class="pkg-link" data-pkg="connector" data-topic="ConnectorFS" data-id="upload_directory_cnt"><a href='../../connector/html/ConnectorFS.html#method-ConnectorFS-upload_directory_cnt'><code>connector::ConnectorFS$upload_directory_cnt()</code></a></span></li>
</ul>
</details>
}}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-ConnectorDatabricksVolume-new"></a>}}
\if{latex}{\out{\hypertarget{method-ConnectorDatabricksVolume-new}{}}}
\subsection{Method \code{new()}}{
Initializes the connector for Databricks volume storage.
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{ConnectorDatabricksVolume$new(
  full_path = NULL,
  catalog = NULL,
  schema = NULL,
  path = NULL,
  extra_class = NULL,
  force = FALSE,
  ...
)}\if{html}{\out{</div>}}
}

\subsection{Arguments}{
\if{html}{\out{<div class="arguments">}}
\describe{
\item{\code{full_path}}{\link{character} Full path to the file storage in format
\code{catalog/schema/path}. If NULL, \code{catalog}, \code{schema}, and \code{path} must be
provided.}

\item{\code{catalog}}{\link{character} Databricks catalog}

\item{\code{schema}}{\link{character} Databricks schema}

\item{\code{path}}{\link{character} Path to the file storage}

\item{\code{extra_class}}{\link{character} Extra class to assign to the new
connector.}

\item{\code{force}}{\link{logical} If TRUE, the volume will be created without asking
if it does not exist.}

\item{\code{...}}{Additional arguments passed to the initialize method of
superclass}
}
\if{html}{\out{</div>}}
}
\subsection{Returns}{
A new \link{ConnectorDatabricksVolume} object
}
}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-ConnectorDatabricksVolume-clone"></a>}}
\if{latex}{\out{\hypertarget{method-ConnectorDatabricksVolume-clone}{}}}
\subsection{Method \code{clone()}}{
The objects of this class are cloneable with this method.
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{ConnectorDatabricksVolume$clone(deep = FALSE)}\if{html}{\out{</div>}}
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
