# Standalone file: do not edit by hand
# Source: <https://github.com/2degreesInvesting/tiltIndicator/blob/main/R/standalone-name-pattern.R>
# ----------------------------------------------------------------------
#
check_matches_name <- function(data, pattern) {
  if (!matches_name(data, pattern)) {
    abort(c(
      glue("The data lacks a column matching the pattern '{pattern}'."),
      i = "Are you using the correct data?"
    ))
  }
  invisible(data)
}

matches_name <- function(data, pattern) {
  nzchar(extract_name(data, pattern))
}

extract_name <- function(data, pattern) {
  out <- grep(pattern, names(data), value = TRUE)
  if (identical(out, character(0))) {
    out <- ""
  }
  out
}

get_column <- function(data, pattern) {
  data[[extract_name(data, pattern)]]
}
