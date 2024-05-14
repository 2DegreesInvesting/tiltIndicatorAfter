categorize_avg_matching_certainity <- function(x, ...) {
  case_when(
    x > 2 / 3 ~ "high",
    x > 1 / 3 & x <= 2 / 3 ~ "medium",
    x <= 1 / 3 ~ "low",
    ...
  )
}

categorize_matching_certainity <- function(x, ...) {
  case_when(
    x == "high" ~ 1,
    x == "medium" ~ 0.5,
    x == "low" ~ 0,
    ...
  )
}

add_avg_matching_certainty <- function(data, col) {
  data |>
    rename(matching_certainty = all_of(col)) |>
    mutate(matching_certainty_num = categorize_matching_certainity(.data$matching_certainty)) |>
    mutate(avg_matching_certainty_num = mean(.data$matching_certainty_num, na.rm = TRUE), .by = c("companies_id")) |>
    mutate(avg_matching_certainty = categorize_avg_matching_certainity(.data$avg_matching_certainty_num))
}

# excluding rows with `risk_category` as NA without excluding any company which contain NAs
exclude_rows <- function(data, col) {
  ids <- data |>
    filter(all(is.na(.data[[col]])), .by = c("companies_id")) |>
    distinct(
      .data$companies_id, .data$postcode, .data$address,
      .data$company_name, .data$company_city, .data$country, .data$main_activity
    )

  # Write test to include the meta data
  data |>
    filter(!is.na(.data[[col]])) |>
    bind_rows(ids)
}

sanitize_isic <- function(data) {
  data |> modify_col("isic", as.character)
}

modify_col <- function(data, pattern, f) {
  col <- extract_name(data, pattern)
  val <- get_column(data, pattern)
  data[col] <- f(val)
  data
}

# stop if columns other than "activity_uuid_product_uuid" and "activity_name" have
# more than one unique value for `country`, `main_activity`, and `clustered` group of columns.
stop_if_some_columns_have_more_than_one_unique_value <- function(matches_mapp) {
  check_col <- matches_mapp |>
    summarise(across(everything(), \(x) length(unique(na.omit(x)))), .by = c("country", "main_activity", "clustered")) |>
    select(-c("country", "main_activity", "clustered"))

  if (!all(unlist(check_col) %in% c(0, 1))) {
    abort(c(
      "Columns other than `activity_uuid_product_uuid` and `activity_name`
      should not have more than one unique value for `country`, `main_activity`,
      and `clustered` group of columns."
    ))
  }
  invisible(matches_mapp)
}

# To disable this renaming function use: options(tiltIndicatorAfter.dissable_issue_118 = TRUE)
rename_118 <- function(data) {
  if (getOption("tiltIndicatorAfter.dissable_issue_118", default = FALSE)) {
    return(data)
  }

  data |>
    rename(any_of(c(
      emission_profile = "PCTR_risk_category",
      emission_profile_share = "PCTR_share",
      emission_upstream_profile = "ICTR_risk_category",
      emission_upstream_profile_share = "ICTR_share",
      sector_profile = "PSTR_risk_category",
      sector_profile_share = "PSTR_share",
      sector_profile_upstream = "ISTR_risk_category",
      sector_profile_upstream_share = "ISTR_share",
      sector_scenario = "sector",
      subsector_scenario = "subsector"
    )))
}

add_profile_ranking_average <- function(data, product) {
  profile_ranking_average <- product |>
    select("companies_id", "grouped_by", "profile_ranking") |>
    mutate(
      profile_ranking_avg = round(mean(.data$profile_ranking, na.rm = TRUE), 3),
      .by = c("companies_id", "grouped_by")
    ) |>
    select(-c("profile_ranking")) |>
    distinct()

  data |> left_join(profile_ranking_average, by = c("companies_id", "grouped_by"))
}

check_matches_col_names <- function(data, cols) {
  if (!any(cols %in% names(data))) {
    pattern <- cols[!(cols %in% names(data))]
    abort(c(
      glue("The data lacks column '{pattern}'."),
      i = "Are you using the correct data?"
    ), class = "check_matches_name")
  }
  invisible(data)
}

emission_profile_at_product_level_sample <- function() {
  tibble::tibble(
    companies_id = "any",
    ep_product = c("one", "two", "three"),
    benchmark = "all",
    emission_profile = c("low", "medium", "high")
  )
}
