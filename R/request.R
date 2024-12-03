request_taginfo <- function(endpoint, method, query = NULL, path = NULL) {
  url <- getOption("osmtags_url", "https://taginfo.openstreetmap.org/")
  req <- httr2::request(url)
  req <- httr2::req_url_path_append(req, "api", TAGINFO_VERSION, endpoint, method)
  req <- do.call(httr2::req_url_query, c(list(.req = req), query))

  if (getOption("osmtags_debug", FALSE)) {
    message("GET ", req$url)
  }

  resp <- httr2::req_perform(req, path = path)

  type <- httr2::resp_content_type(resp)
  if (endsWith(type, "json")) {
    httr2::resp_body_json(resp, simplifyVector = TRUE)
  } else if (any(endsWith(type, c("png", "svg+xml")))) {
    unclass(resp$body)
  }
}


additional_options <- function(page = NULL,
                               rp = NULL,
                               sortname = NULL,
                               sortorder = NULL,
                               filter = NULL,
                               parent = sys.parent()) {
  caller <- get_caller_name(parent)
  if (!caller %in% names(spec_info)) {
    stop("Cannot fetch API specifications. Please open a bug report.")
  }

  spec <- spec_info[[caller]]
  if ((!is.null(rp) || !is.null(page)) && isFALSE(spec$paging)) {
    stop(sprintf(
      "Paging is not supported for `%s`. Arguments `page` and `rp` must be NULL.",
      caller
    ))
  }

  if (!is.null(filter)) {
    if (identical(spec$filter, "none")) {
      stop(sprintf(
        "Filtering is not supported for `%s`. Argument `filter` must be NULL.",
        caller
      ))
    }

    if (!filter %in% spec$filter) {
      stop(sprintf(
        "Argument `filter` can only contain the following values: %s",
        paste(spec$filter, collapse = ", ")
      ))
    }

  }

  if (!is.null(sortname) || !is.null(sortorder)) {
    if (identical(spec$sort, "none")) {
      stop(sprintf(
        "Sorting is not supported for `%s`. Arguments `sortname` and `sortorder` must be NULL.",
        caller
      ))
    }

    if (!sortname %in% spec$sort) {
      stop(sprintf(
        "Argument `sortname` can only contain the following values: %s",
        paste(spec$sort, collapse = ", ")
      ))
    }

  }

  if (!is.null(filter)) {
    filter <- paste(filter, collapse = ",")
  }

  args <- as.list(environment())
  args <- args[!names(args) %in% c("caller", "spec")]
  drop_null(structure(args, class = "taginfo_opts"))
}
