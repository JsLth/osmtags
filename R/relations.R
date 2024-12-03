#' Relations
#' @description
#' Query relations.
#'
#' @export
#' @source \url{https://taginfo.openstreetmap.org/taginfo/apidoc}
#'
relations_all <- function(query = NULL, ...) {
  query <- as.list(environment())
  query <- c(query, additional_options(...))
  as_data_frame(request_taginfo("relations", "all", query)$data)
}


relation_projects <- function(relation, query = NULL, ...) {
  query <- list(rtype = relation, query = query)
  query <- c(query, additional_options(...))
  as_data_frame(request_taginfo("relation", "projects", query)$data)
}


relation_roles <- function(relation, query = NULL, min_fraction = NULL, ...) {
  query <- list(rtype = relation, query = query, min_fraction = min_fraction)
  query <- c(query, additional_options(...))
  as_data_frame(request_taginfo("relation", "roles", query)$data)
}


relation_stats <- function(relation) {
  query <- list(rtype = relation)
  as_data_frame(request_taginfo("relation", "stats", query)$data)
}


relation_wiki_pages <- function(relation) {
  query <- list(rtype = relation)
  as_data_frame(request_taginfo("relation", "wiki_pages", query)$data)
}
