#' API specification
#' @description
#' Retrieve a list of supported API methods and their supported dot arguments.
#' Each row in this dataframe has a corresponding function in the
#' \code{osmtags} package.
#'
#' @returns A dataframe containing the endpoint and method names of supported
#' API methods. Additionally, information on whether paging is supported,
#' and which filter and sort values are allowed.
#'
#' @export
#'
#' @examples
#' api_spec()
api_spec <- function() {
  spec <- lapply(spec_info, function(x) {
    x <- lapply(x, squeeze)
    attr(x, "row.names") <- 1L
    class(x) <- "data.frame"
    x
  })
  as_data_frame(rbind_list(spec))
}


rbind_list <- function(args) {
  nam <- lapply(args, names)
  unam <- unique(unlist(nam))
  len <- vapply(args, length, numeric(1))
  out <- vector("list", length(len))
  for (i in seq_along(len)) {
    if (nrow(args[[i]])) {
      nam_diff <- setdiff(unam, nam[[i]])
      if (length(nam_diff)) {
        args[[i]][nam_diff] <- NA
      }
    } else {
      next
    }
  }
  out <- do.call(rbind, args)
  rownames(out) <- NULL
  out
}


drop_null <- function(x) {
  if (length(x) == 0 || !is.list(x))
    return(x)
  x[!unlist(lapply(x, is.null))]
}


squeeze <- function(x) {
  if (is.atomic(x) && length(x) > 1) {
    x <- list(x)
  }
  x
}


loadable <- function(x) {
  suppressPackageStartupMessages(requireNamespace(x, quietly = TRUE))
}


as_data_frame <- function(x) {
  if (loadable("tibble")) {
    tibble::as_tibble(x)
  } else {
    as.data.frame(x)
  }
}


get_caller_name <- function(parent = sys.parent()) {
  deparse(sys.call(parent)[[1]])
}
