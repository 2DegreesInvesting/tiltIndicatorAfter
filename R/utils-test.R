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

# FIXME: Delete once tiltToyData#19 is merged
# TODO:
# * Search for "tiltToyData::", remove the namespace.
# * Import the "*_ecoinvent()" functions.
# Helps add snapshots of new toy datasets before tiltToyData#19 is merged
skip_if_toy_data_is_old <- function() {
  testthat::skip_if(old_toy_data())
}

old_toy_data <- function(utils, packageVersion) {
  utils::packageVersion("tiltToyData") <= "0.0.0.9005"
}
