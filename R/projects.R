#' Projects
#' @description
#' OSM projects are projects that use tags in some way, e.g. editors, routers,
#' maps, or data extractions tools. Taginfo keeps information about the keys
#' and tags that a project uses. These functions provide a means to retrieve
#' this information.
#'
#' @param query A search term to filter results by. For \code{projects_all},
#' this matches name or description. For \code{projects_keys}, this matches the
#' keys. For \code{projects_tags}, this matches the tags.
#' @param status Only show projects with a given status. This argument does
#' not seem to do anything currently.
#' @param project A project ID.
#' @inheritParams key_distribution
#'
#' @returns \itemize{
#'  \item{\code{projects_all}: A dataframe containing basic information about
#'  all projects and their used keys}
#'  \item{\code{projects_key} / \code{projects_tags}: A dataframe containing
#'  information about each key / tag associated with a project and their
#'  occurences in projects and wiki pages.}
#'  \item{\code{project_icon}: The path to the downloaded icon and
#'  (if \code{plot = TRUE})}, the icon shown as an R plot. Note that some
#'  icons are stored as SVG and produce an error when trying to plot.
#'  \item{\code{project_tags}: A dataframe containing information about how
#'  a tag is used in a project.}
#' }
#'
#' @export
#' @source \url{https://taginfo.openstreetmap.org/taginfo/apidoc}
#'
#' @examples
#' # get all projects in osmtags
#' projects_all()
#'
#' # get all highway keys and tags that are used in a project
#' projects_keys("highway")
#' projects_tags("highway")
#'
#' #
#'
projects_all <- function(query = NULL, status = "OK", ...) {
  query <- as.list(environment())
  query <- c(query, additional_options(...))
  as_data_frame(request_taginfo("projects", "all", query)$data)
}


#' @rdname projects_all
#' @export
projects_keys <- function(query = NULL, ...) {
  query <- list(query = query)
  query <- c(query, additional_options(...))
  as_data_frame(request_taginfo("projects", "keys", query)$data)
}


#' @rdname projects_all
#' @export
projects_tags <- function(query = NULL, ...) {
  query <- list(query = query)
  query <- c(query, additional_options(...))
  as_data_frame(request_taginfo("projects", "tags", query)$data)
}


#' @rdname projects_all
#' @export
project_icon <- function(project, path = tempfile(), plot = TRUE) {
  if (!has_file_ext(path)) {
    proj <- projects_all()
    icon_url <- proj[proj$id %in% project, ]$icon_url
    file_name <- basename(icon_url)
    req <- httr2::request(icon_url)
    path <- file.path(dirname(path), file_name)
    path <- httr2::req_perform(req, path = path)$body
  } else {
    request_taginfo("project", "icon", query = list(project = project), path = path)
  }

  if (loadable("showimage") && plot) {
    showimage::show_image(path)
  }

  invisible(normalizePath(path, "/"))
}


#' @rdname projects_all
#' @export
project_tags <- function(project, ...) {
  query <- list(project = project)
  query <- c(query, additional_options(...))
  as_data_frame(request_taginfo("project", "tags", query)$data)
}
