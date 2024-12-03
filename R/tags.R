#' Tags
#' @description
#' Query all tags. \code{tags_list} returns all specified tags or (alternatively)
#' a certain key. \code{tags_popular} returns a list of the most commonly used
#' tags.
#'
#' @param tags A character vector of key-value pairs to match. Must be in the
#' format \code{"{key}={value}"}. Either this or \code{key} must be provided.
#' @param key A key to match key-value combinations. Either this or \code{tags}
#' must be provided.
#' @inheritParams key_chronology
#' @returns A dataframe containing various statistics on the specified tags
#' including the counts and fractions of the tags, whether they have a wiki
#' page and related OSM projects.
#'
#' @export
#' @source \url{https://taginfo.openstreetmap.org/taginfo/apidoc}
#'
#' @examples
#' \donttest{# Get metadata on specified tags
#' tags_list(tags = c("amenity=hospital", "amenity=post_box"))
#'
#' # ... or just query all tags for a certain key
#' tags_list(key = "amenity")
#'
#' # Get the most common tags related to fire
#' tags_popular("fire")}
tags_list <- function(tags = NULL, key = NULL) {
  if (is.null(tags) && is.null(key)) {
    stop("Either a vector of tags or a key must be provided.")
  }

  if (!is.null(tags)) {
    tags <- paste(tags, collapse = ",")
  }
  query <- as.list(environment())
  as_data_frame(request_taginfo("tags", "list", query)$data)
}


#' @rdname tags_list
#' @export
tags_popular <- function(query = NULL, ...) {
  query <- as.list(environment())
  query <- c(query, additional_options(...))
  as_data_frame(request_taginfo("tags", "popular", query)$data)
}
