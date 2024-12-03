#' Parse unicode
#' @description
#' Get information about a string of unicode characters.
#'
#' @param string A string.
#'
#' @export
#' @source \url{https://taginfo.openstreetmap.org/taginfo/apidoc}
#'
#' @returns A dataframe containing details about each character including
#' the codepoint, script, category and character name.
#'
#' @examples
#' unicode_chars("a string")
unicode_chars <- function(string) {
  query <- list(string = string)
  as_data_frame(request_taginfo("unicode", "characters", query)$data)
}


#' OSM wiki
#' @description
#' Retrieve data from the OSM wiki including languages and key lists.
#' Additionally, \code{ietf_languages} returns a list of language tags from
#' the IETF BCP47 registry.
#'
#' @param query A search term to filter the results by. Searches language names
#' in case of \code{ietf_languages} and keys, values, relation types, item
#' codes and item descriptions in case of \code{wiki_data}.
#' @inheritParams key_chronology
#'
#' @returns \code{wiki_data} returns a dataframe containing the keys and their
#' descriptions, relation types, and values. \code{wiki_languages} returns a
#' dataframe containing the native and english names as well as the number of
#' key pages and the number of tag pages. \code{ietf_languages} returns a
#' dataframe containing the defined languages as well as their type, description,
#' time added and additional notes.
#'
#' @examples
#' \donttest{# Query languages
#' wiki_languages()
#' ietf_languages("irish")
#'
#' # Get all amenities defined on the wiki
#' wiki_data("amenity")}
wiki_data <- function(query = NULL, lang = "en", ...) {
  query <- as.list(environment())
  query <- c(query, additional_options(...))
  as_data_frame(request_taginfo("wikidata", "all", query)$data)
}


#' @rdname wiki_data
#' @export
wiki_languages <- function() {
  as_data_frame(request_taginfo("wiki", "languages")$data)
}


#' @rdname wiki_data
#' @export
ietf_languages <- function(query = NULL, ...) {
  query <- list(query = query)
  query <- c(query, additional_options(...))
  as_data_frame(request_taginfo("languages", NULL, query)$data)
}
