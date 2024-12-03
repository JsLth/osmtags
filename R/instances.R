#' Taginfo instances
#' @description
#' By default, \code{osmtags} uses the official taginfo API. However, many
#' custom instances exist which can be retrieved and set using these functions.
#'
#' \code{taginfo_instances} retrieves a number of known taginfo hosts from
#' the OSM wiki (\url{https://wiki.openstreetmap.org/wiki/Taginfo/Sites}) or
#' geofabrik (\url{https://taginfo.geofabrik.de/}). \code{set_taginfo_url}
#' changes the default API either by using the name listed in
#' \code{taginfo_instances()} or by directly providing the URL.
#'
#' @param query A search text that can be used to filter the description text.
#' @param type The source of the taginfo instance. \code{"wiki"} retrieves
#' all instances listed on the OSM wiki, and \code{"geofabrik"} retrives only
#' instances from Geofabrik. Returns all instances by default.
#' @param name Name of the instance to set. Corresponds to the \code{name}
#' column from \code{taginfo_instances()}. If both this and \code{url} are
#' \code{NULL}, falls back to the default API.
#' @param url A URL of a taginfo instance, e.g.
#' \code{"https://taginfo.openstreetmap.org/"}. If both this and \code{name} are
#' \code{NULL}, falls back to the default API.
#'
#' @returns \code{taginfo_instances} returns a dataframe containing the source
#' of the instance info (\code{type}), the internal name, a human-readable
#' description, and the URL of the instance.
#' \code{set_taginfo_url} returns the new taginfo URL, invisibly.
#'
#' @export
#'
#' @examples
#' # Get all instances for Africa
#' taginfo_instances("africa")
#'
#' # Set South Africa as new taginfo API
#' set_taginfo_url("africa:south-africa")
#'
#' # Reset taginfo API
#' set_taginfo_url()
taginfo_instances <- function(query = NULL, type = c("all", "wiki", "geofabrik")) {
  type <- match.arg(type)
  inst <- all_instances

  if (!identical(type, "all")) {
    inst <- inst[inst$type %in% type, ]
  }

  if (!is.null(query)) {
    inst <- inst[grepl(query, inst$description, ignore.case = TRUE), ]
  }

  as_data_frame(inst)
}


#' @rdname taginfo_instances
#' @export
set_taginfo_url <- function(name = NULL, url = NULL) {
  if (is.null(url) && !is.null(name)) {
    inst <- all_instances
    url <- inst[inst$name %in% name, ]$url
  }

  options(osmtags_url = url)
  invisible(url)
}
