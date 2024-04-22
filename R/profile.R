#' Create objects of class profile
#'
#' @param data `r document_profile()`
#'
#' @return An object of class 'profile'.
#' @export
#' @keywords internal
#'
#' @examples
#' library(tiltIndicator)
#'
#' product <- company <- tibble(companies_id = 1)
#' data <- nest_levels(product, company)
#'
#' class(data)
#'
#' class(profile(data))
profile <- function(data) {
  validate_profile(data)
  new_profile(data)
}

validate_profile <- function(data) {
  if(!is_profile_result(data)) {
    msg <- "`data` must have columns `companies_id`, `product`, and `company`."
    abort(msg, class = "validate_profile_top_level_names")
  }

  if(!is.list(data$product) | !is.list(data$company)) {
    msg <- "The `product` and `company` columns must be a list."
    abort(msg, class = "validate_profile_type")

  }

  data
}

new_profile <- function(data) {
  stopifnot(is.data.frame(data))
  structure(data, class = c("profile", class(data)))
}

document_profile <- function() {
  paste0(
    "A data frame with the column `companies_id`, and the list columns ",
    "`product` and `company` holding the outputs at product and company level."
  )
}
