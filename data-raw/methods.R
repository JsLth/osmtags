docs <- rvest::read_html("https://taginfo.openstreetmap.org/taginfo/apidoc")
methods <- rvest::html_table(docs, header = FALSE)

reqs <- lapply(methods, function(x) {
  if (identical(x[1, 1, drop = TRUE], "Path:")) {
    # Extract name
    path <- x[x$X1 %in% "Path:",]$X2
    path <- strsplit(path, "/")[[1]]
    path <- tail(path, 2 + any(tail(path, 1) %in% c("nodes", "ways")))
    endpoint <- path[1]
    method <- path[2]

    # Extract paging
    paging <- x[x$X1 %in% "Paging:",]$X2
    paging <- ifelse(identical(paging, "no"), FALSE, TRUE)

    # Extract filter
    filter <- x[x$X1 %in% "Filter:",]$X2
    filter <- strsplit(filter, "\\.")[[1]]
    filter <- strsplit(filter, " — ")
    filter <- vapply(filter, FUN.VALUE = character(1), "[[", 1)

    # Extract sort
    sort <- x[x$X1 %in% "Sort:",]$X2
    sort <- strsplit(sort, ", ")[[1]]

    list(
      endpoint = endpoint,
      method = method,
      paging = paging,
      filter = filter,
      sort = sort
    )
  }
})
reqs <- Filter(Negate(is.null), reqs)

nms <- vapply(reqs, FUN.VALUE = character(1), function(x) {
  paste0(x$endpoint, "_", x$method)
})

nms <- replace(
  nms,
  nms %in% c(
    "search_by_key_and_value", "search_by_keyword", "search_by_role",
    "search_by_value", "4_languages", "unicode_characters", "wikidata_all"
  ),
  c(
    "search_key_value", "search_keyword", "search_role", "search_value",
    "ietf_languages", "unicode_chars", "wiki_data"
  )
)

names(reqs) <- nms
spec_info <- reqs[intersect(nms, getNamespaceExports("osmtags"))]

usethis::use_data(spec_info, internal = TRUE, version = 3, overwrite = TRUE, compress = "xz")
