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

skip_unless_tilt_indicator_is_newer_than <- function(version) {
  testthat::skip_if(utils::packageVersion("tiltIndicator") <= version)
}

toy_data_version <- function() {
  "0.0.0.9007"
}

skip_on_rcmd <- function() {
  testthat::skip_if(nzchar(Sys.getenv("R_CMD")), "On R CMD")
}

#' @examples
#' this_data <- tibble(x = 1)
#' this_data |> check_col("y", hint = "Did you forget something?")
#' @noRd
check_col <- function(data, col, hint = NULL) {
  if (!hasName(data, col)) {
    label <- deparse(substitute(data))
    abort(c(glue("`{label}` must have the column `{col}`."), i = hint))
  }

  invisible(data)
}

best_case_worst_case_emission_profile_sample <- function() {
  tibble::tibble(
    companies_id = "any",
    ep_product = c("one", "two", "three"),
    benchmark = "all",
    emission_profile = c("low", "medium", "high")
  )
}
