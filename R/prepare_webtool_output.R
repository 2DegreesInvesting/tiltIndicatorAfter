prepare_webtool_output <- function(data, pivot_wider = FALSE, for_webtool = FALSE) {
  if (pivot_wider & for_webtool) {
    prepare_webtool_output_impl(data)
  }
  else {
    data
  }
}

prepare_webtool_output_impl <- function(data) {
  product <- data |>
    unnest_product() |>
    select_webtool_cols_at_product_level()

  company <- data |>
    unnest_company() |>
    select_webtool_cols_at_company_level_wide() |>
    rename_webtool_cols_at_company_level_wide()

  tilt_profile(nest_levels(product, company))
}

polish_transition_risk_profile <- function(data) {
  product <- data |>
    unnest_product() |>
    rename_transition_risk_profile_cols_product()

  company <- data |>
    unnest_company() |>
    rename_transition_risk_profile_cols_company()

  tilt_profile(nest_levels(product, company))
}
