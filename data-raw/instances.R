geofabrik_url <- "https://taginfo.geofabrik.de/"
gf_instances <- rvest::read_html(geofabrik_url) |>
  rvest::html_element("#context") |>
  rvest::html_text() |>
  jsonlite::fromJSON() |>
  _$instances

gf_instances <- data.frame(
  type = "geofabrik",
  name = names(gf_instances),
  description = unlist(gf_instances),
  url = paste0(geofabrik_url, names(gf_instances))
)

wiki_url <- "https://wiki.openstreetmap.org/wiki/Taginfo/Sites"
wiki_instances <- rvest::read_html(wiki_url) |>
  rvest::html_table() |>
  _[[1]]

wiki_instances <- data.frame(
  type = "wiki",
  name = gsub(" ", "_", tolower(wiki_instances[[3]])),
  description = wiki_instances[[3]],
  url = wiki_instances$`Taginfo site`
)
wiki_instances <- wiki_instances[!grepl("geofabrik", wiki_instances$url), ]

all_instances <- rbind.data.frame(wiki_instances, gf_instances)
all_instances[!startsWith(all_instances$url, "http"), "url"] <-
  paste0("https://", all_instances[!startsWith(all_instances$url, "http"), "url"])

usethis::use_data(all_instances, version = 3, overwrite = TRUE, compress = "xz", internal = TRUE)
