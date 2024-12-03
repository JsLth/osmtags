#' Free search
#' @description
#' Search for tags, keys or relation roles.
#'
#' @param query Substring to search for. Used to search key/value combinations
#' in case of \code{search_key_value}, keywords in wiki pages in case of
#' \code{search_keyword}, relation roles in case of \code{search_role}, and
#' values in case of \code{search_value}
#'
#' @returns For \code{search_key_value} and \code{search_keyword} returns
#' a dataframe containing the matched key-value combinations. For
#' \code{search_role} returns a dataframe containing the matched relation type
#' and role.
#' @export
#' @source \url{https://taginfo.openstreetmap.org/taginfo/apidoc}
#'
#' @examples
#' \donttest{search_key_value("highway=residential")
#' search_key_value("amenity=")
#' search_value("residential")
#'
#' search_keyword("fire")
#' search_keyword("railway")
#'
#' search_role("highway")}
search_key_value <- function(query, ...) {
  if (!grepl("=", query, fixed = TRUE)) {
    stop("`query` must contain a key-value pair separated by a `=`.")
  }

  query <- as.list(environment())
  query <- c(query, additional_options(...))
  as_data_frame(request_taginfo("search", "by_key_and_value", query)$data)
}


#' @rdname search_key_value
#' @export
search_keyword <- function(query, ...) {
  force(query)
  query <- as.list(environment())
  query <- c(query, additional_options(...))
  as_data_frame(request_taginfo("search", "by_keyword", query)$data)
}


#' @rdname search_key_value
#' @export
search_role <- function(query, ...) {
  force(query)
  query <- as.list(environment())
  query <- c(query, additional_options(...))
  as_data_frame(request_taginfo("search", "by_role", query)$data)
}


#' @rdname search_key_value
#' @export
search_value <- function(query, ...) {
  query <- as.list(environment())
  query <- c(query, additional_options(...))
  as_data_frame(request_taginfo("search", "by_value", query)$data)
}
