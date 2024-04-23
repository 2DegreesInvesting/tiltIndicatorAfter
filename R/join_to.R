#' Join every possible column and row
#'
#' This function is typically useful when you want to pipe data into a summary
#' and then join back the data to the summary. It joins by all shared columns
#' using a "many-to-many" relationship.
#'
#' @inheritParams dplyr::left_join
#'
#' @return A data frame with all columns in `x` and `y` and all rows in `y`,
#'   except the columns and resulting duplicates matched by the argument
#'   `excluding`.
#' @export
#' @keywords internal
#' @family composable friends
#'
#' @examples
#' library(dplyr, warn.conflicts = FALSE)
#'
#' data <- tibble(x = rep(1, 4), y = letters[rep(c(1, 2), 2)], z = 1:4)
#' data
#'
#' data |>
#'   summarize(mean = mean(x), .by = "y") |>
#'   join_to(data)
#'
#' data |>
#'   summarize(mean = mean(x), .by = "y") |>
#'   join_to(data |> exclude("z"))
join_to <- function(x, y) {
  UseMethod("join_to", y)
}

#' @export
join_to.data.frame <- function(x, y) {
  shared_cols <- intersect(names(x), names(y))
  no_shared_cols <- rlang::is_empty(shared_cols)
  if (no_shared_cols) {
    msg <- "`x` and `y` have no shared columns. Returning `y`"
    warn(msg, class = "no_shared_cols")
    return(y)
  }

  # Suppress the message about shared columns (and unfortunately other messages)
  suppressMessages(
    left_join(y, x, relationship = "many-to-many")
  )
}

#' @export
join_to.tilt_profile <- function(x, y) {
  product <- unnest_product(y)
  out_product <- join_to(x, product)
  company <- unnest_company(y)
  out_company <- join_to(x, company)

  result <- nest_levels(out_product, out_company)

  tilt_profile(result)
}
