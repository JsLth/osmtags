#' Tags
#' @description
#' Retrieve various data on OSM tags, i.e. key-value pairs. This includes:
#'
#' \itemize{
#'  \item{\code{tag_chronology}: Returns a history of nodes, ways, and
#'  relations for a given tag.}
#'  \item{\code{tag_combinations}: Returns combinations of tags that often
#'  co-occur.}
#'  \item{\code{tag_distribution}: Returns an image (or plot) of the spatial
#'  distribution of tags.}
#'  \item{\code{tag_overview}: Returns a list containing a detailed summary
#'  of tag metadata.}
#'  \item{\code{tag_projects}: Returns all projects using a tag.}
#'  \item{\code{tag_stats}: Returns the total number of nodes, ways, and
#'  relations associated with a tag.}
#'  \item{\code{tag_wiki_pages}: Returns information on the wiki pages
#'  associated with a tag.}
#' }
#'
#' @param key Name of the key, e.g. \code{"amenity"} from \code{"amenity=hospital"}.
#' @param value Name of the value, e.g. \code{"hospital"} from \code{"amenity=hospital"}.
#' @inheritParams key_chronology
#' @returns \code{tag_chronology}, \code{tag_combinations}, \code{tag_projects},
#' \code{tag_stats}, and \code{tag_wiki_pages} return a dataframe.
#' \code{tag_overview} returns a named list. \code{tag_distribution} returns
#' the path to an image and (optionally) plots the image using
#' \code{\link[showimage]{show_image}}.
#'
#' @export
#' @source \url{https://taginfo.openstreetmap.org/taginfo/apidoc}
#'
#' @examples
#' \donttest{# Retrieve the history of a tag
#' history <- tag_chronology("amenity", "hospital")
#' history$nodes <- cumsum(history$nodes)
#' with(history, plot(date, nodes, type = "l"))
#'
#' # Only retrieve number of hospitals that are explicitly buildings
#' tag_combinations("amenity", "hospital", query = "building")
#'
#' # Only retrieve combinations for hospitals that are mapped as relations
#' tag_combinations("amenity", "hospital", filter = "relations")
#'
#' # Plot distribution of tags
#' tag_distribution("amenity", "hospital", type = "nodes")
#' tag_distribution("highway", "residential", type = "ways")
#'
#' summ <- tag_overview("amenity", "post_box")
#' str(summ)
#'
#' # Retrieve JOSM projects on hospitals
#' tag_projects("amenity", "hospital", query = "josm")
#'
#' # Retrieve number of tags for each geometry type
#' tag_stats("amenity", "hospital")
#'
#' # Retrieve wiki pages on a tag
#' tag_wiki_pages("amenity", "hospital")}
tag_chronology <- function(key, value) {
  force(key)
  force(value)
  query <- as.list(environment())
  res <- request_taginfo("tag", "chronology", query)$data
  res$date <- as.POSIXct(res$date)
  as_data_frame(res)
}


#' @rdname tag_chronology
#' @export
tag_combinations <- function(key, value, query = NULL, ...) {
  force(key)
  force(value)
  query <- as.list(environment())
  query <- c(query, additional_options(...))
  as_data_frame(request_taginfo("tag", "combinations", query = query)$data)
}


#' @rdname tag_chronology
#' @export
tag_distribution <- function(key,
                             value,
                             type = c("nodes", "ways"),
                             path = tempfile(),
                             plot = TRUE) {
  type <- match.arg(type)
  if (!grepl("\\.png$", path)) {
    path <- paste0(path, ".", "png")
  }
  endpoint <- paste0("distribution/", type)
  query <- list(key = key, value = value)
  request_taginfo("tag", endpoint, query = query, path = path)
  if (loadable("showimage") && plot) {
    showimage::show_image(path)
  }

  invisible(normalizePath(path, "/"))
}


#' @rdname tag_chronology
#' @export
tag_overview <- function(key, value) {
  force(key)
  force(value)
  query <- as.list(environment())
  request_taginfo("tag", "overview", query)$data
}


#' @rdname tag_chronology
#' @export
tag_projects <- function(key, value, query = NULL, ...) {
  force(key)
  force(value)
  query <- as.list(environment())
  query <- c(query, additional_options(...))
  as_data_frame(request_taginfo("tag", "projects", query)$data)
}


#' @rdname tag_chronology
#' @export
tag_stats <- function(key, value) {
  force(key)
  force(value)
  query <- as.list(environment())
  as_data_frame(request_taginfo("tag", "stats", query)$data)
}


#' @rdname tag_chronology
#' @export
tag_wiki_pages <- function(key, value) {
  force(key)
  force(value)
  query <- as.list(environment())
  as_data_frame(request_taginfo("tag", "wiki_pages", query)$data)
}
