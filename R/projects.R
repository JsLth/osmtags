#' Projects
#' @description
#' Query projects.
#'
#' @export
#' @source \url{https://taginfo.openstreetmap.org/taginfo/apidoc}
#'
projects_all <- function(query = NULL, status = "OK", ...) {
  query <- as.list(environment())
  query <- c(query, additional_options(...))
  as_data_frame(request_taginfo("projects", "all", query)$data)
}


projects_keys <- function(query = NULL, ...) {
  query <- list(query = query)
  query <- c(query, additional_options(...))
  as_data_frame(request_taginfo("projects", "keys", query)$data)
}


projects_tags <- function(query = NULL, ...) {
  query <- list(query = query)
  query <- c(query, additional_options(...))
  as_data_frame(request_taginfo("projects", "tags", query)$data)
}


project_icon <- function(project, path = tempfile(), plot = TRUE) {
  request_taginfo("project", "icon", query = list(project = project), path = path)

  if (loadable("showimage") && plot) {
    showimage::show_image(path)
  }

  invisible(normalizePath(path, "/"))
}


project_tags <- function(project, ...) {
  query <- list(project = project)
  query <- c(query, additional_options(...))
  as_data_frame(request_taginfo("project", "tags", query)$data)
}
