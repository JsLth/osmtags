#' Keys
#' @description
#' Query keys.
#'
#' @export
#' @source \url{https://taginfo.openstreetmap.org/taginfo/apidoc}
#'
keys_all <- function(query = NULL, ...) {
  query <- list(query = query)
  query <- c(query, additional_options(...))
  as_data_frame(request_taginfo("keys", "all", query)$data)
}


keys_similar <- function(query = NULL, ...) {
  query <- list(query = query)
  query <- c(query, additional_options(...))
  as_data_frame(request_taginfo("keys", "similar", query)$data)
}


keys_wiki_pages <- function(query = NULL, ...) {
  query <- list(query = query)
  query <- c(query, additional_options(...))
  as_data_frame(request_taginfo("keys", "wiki_pages", query)$data)
}


keys_without_wiki_page <- function(english = FALSE,
                                   min_count = 10000,
                                   query = NULL,
                                   ...) {
  query <- list(query = query, english = as.numeric(english), min_count = min_count)
  query <- c(query, additional_options(...))
  as_data_frame(request_taginfo("keys", "without_wiki_page", query)$data)
}
