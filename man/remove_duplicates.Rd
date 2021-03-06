% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/special_cases.R
\name{remove_duplicates}
\alias{remove_duplicates}
\title{Remove duplicate entries}
\usage{
remove_duplicates(l0)
}
\arguments{
\item{l0}{A pairlist of edgelist and nodelist.}
}
\description{
This function removes functions that have the same name.
This is needed mostly for the function ".onLoad".
}
\examples{
\dontrun{
build_graph_from_dir("R/") \%>\%
  remove_duplicates() \%>\%
  prepare_graph_Rgraphviz() \%>\%     # Add plotting parameters
  start_app()
}
}
