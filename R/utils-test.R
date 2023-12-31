unquote <- function(x) {
  gsub("^'(.*)'$", "\\1", x)
}

format_minimal_snapshot <- function(data) {
  str(data, give.attr = FALSE)
}

tibble_names <- function(x, nms) {
  m <- matrix(x, ncol = length(nms), dimnames = list(NULL, nms))
  tibble::as_tibble(m)
}

rm_na <- function(x) {
  x[!is.na(x)]
}

skip_unless_toy_data_is_newer_than <- function(version) {
  testthat::skip_if(utils::packageVersion("tiltToyData") <= version)
}
