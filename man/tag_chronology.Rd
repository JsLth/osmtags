% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/tag.R
\name{tag_chronology}
\alias{tag_chronology}
\alias{tag_combinations}
\alias{tag_distribution}
\alias{tag_overview}
\alias{tag_projects}
\alias{tag_stats}
\alias{tag_wiki_pages}
\title{Tags}
\source{
\url{https://taginfo.openstreetmap.org/taginfo/apidoc}
}
\usage{
tag_chronology(key, value)

tag_combinations(key, value, query = NULL, ...)

tag_distribution(
  key,
  value,
  type = c("nodes", "ways"),
  path = tempfile(),
  plot = TRUE
)

tag_overview(key, value)

tag_projects(key, value, query = NULL, ...)

tag_stats(key, value)

tag_wiki_pages(key, value)
}
\arguments{
\item{key}{Name of the key, e.g. \code{"amenity"} from \code{"amenity=hospital"}.}

\item{value}{Name of the value, e.g. \code{"hospital"} from \code{"amenity=hospital"}.}

\item{query}{A search term to filter results by. For \code{key_combinations}
and \code{key_similar}, this matches the \code{other_key} column, for
\code{key_projects} the project name or tag value, for \code{key_values}
the value. Defaults to \code{NULL}, i.e. no filtering.}

\item{...}{Additional generic parameters used for pagination, filtering,
and sorting. Can include the following:

\itemize{
 \item{\code{page}: If pagination is enabled, specifies the page number.}
 \item{\code{rp}: Enables pagination and specifies the number of results
 returned per page.}
 \item{\code{filter}: A character vector specifying the OSM geometry type
 to filter the results by. For example, if \code{"nodes"}, only tags on
 nodes are returned. Can be several of \code{"all"} (no filtering),
 \code{"nodes"}, \code{"relations"}, or \code{"ways"}.}
 \item{\code{sortname}: Numeric column of the output by which to arrange the
 results.}
 \item{\code{sortorder}: Whether to sort ascending (\code{"asc"}) or
 descending (\code{"desc"}).}
}
Note that not all additional arguments are defined for all API methods.
For details, refer to \code{\link{api_spec}}.}

\item{type}{OSM geometry type of the key whose distribution should be
plotted. Must be either \code{"nodes"} or \code{"ways"}. Defaults to
\code{"nodes"}.}

\item{path}{Path to a file where the plot should be written to.}

\item{plot}{Whether to plot the distribution using the R graphics device
using \code{\link[showimage]{show_image}}. If \code{FALSE}, simply returns
the path to the file. Defaults to \code{TRUE}.}
}
\value{
\code{tag_chronology}, \code{tag_combinations}, \code{tag_projects},
\code{tag_stats}, and \code{tag_wiki_pages} return a dataframe.
\code{tag_overview} returns a named list. \code{tag_distribution} returns
the path to an image and (optionally) plots the image using
\code{\link[showimage]{show_image}}.
}
\description{
Retrieve various data on OSM tags, i.e. key-value pairs. This includes:

\itemize{
 \item{\code{tag_chronology}: Returns a history of nodes, ways, and
 relations for a given tag.}
 \item{\code{tag_combinations}: Returns combinations of tags that often
 co-occur.}
 \item{\code{tag_distribution}: Returns an image (or plot) of the spatial
 distribution of tags.}
 \item{\code{tag_overview}: Returns a list containing a detailed summary
 of tag metadata.}
 \item{\code{tag_projects}: Returns all projects using a tag.}
 \item{\code{tag_stats}: Returns the total number of nodes, ways, and
 relations associated with a tag.}
 \item{\code{tag_wiki_pages}: Returns information on the wiki pages
 associated with a tag.}
}
}
\examples{
\donttest{# Retrieve the history of a tag
history <- tag_chronology("amenity", "hospital")
history$nodes <- cumsum(history$nodes)
with(history, plot(date, nodes, type = "l"))

# Only retrieve number of hospitals that are explicitly buildings
tag_combinations("amenity", "hospital", query = "building")

# Only retrieve combinations for hospitals that are mapped as relations
tag_combinations("amenity", "hospital", filter = "relations")

# Plot distribution of tags
tag_distribution("amenity", "hospital", type = "nodes")
tag_distribution("highway", "residential", type = "ways")

summ <- tag_overview("amenity", "post_box")
str(summ)

# Retrieve JOSM projects on hospitals
tag_projects("amenity", "hospital", query = "josm")

# Retrieve number of tags for each geometry type
tag_stats("amenity", "hospital")

# Retrieve wiki pages on a tag
tag_wiki_pages("amenity", "hospital")}
}
