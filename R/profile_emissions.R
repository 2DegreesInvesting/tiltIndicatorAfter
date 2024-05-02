#' @rdname profile_emissions_upstream
#' @export
profile_emissions <- function(companies,
                              co2,
                              europages_companies,
                              ecoinvent_activities,
                              ecoinvent_europages,
                              isic,
                              isic_tilt = lifecycle::deprecated(),
                              low_threshold = 1 / 3,
                              high_threshold = 2 / 3) {
  profile <- profile_emissions_impl(
    companies = companies,
    co2 = co2,
    europages_companies = europages_companies,
    ecoinvent_activities = ecoinvent_activities,
    ecoinvent_europages = ecoinvent_europages,
    isic = isic,
    isic_tilt = isic_tilt,
    low_threshold = low_threshold,
    high_threshold = high_threshold
  )

  product <- unnest_product(profile)
  col <- extract_name(product, pattern_risk_category_emissions_profile_any())
  missing_profile <- profile |>
    unnest_product() |>
    filter(is.na(.data[[col]]))

  out <- profile |>
    add_co2(co2)

  product <- out |>
    unnest_product() |>
    bind_rows(missing_profile)

  company <- out |>
    unnest_company()

  tilt_profile(nest_levels(product, company))
}

#' @rdname profile_impl
#' @export
#' @keywords internal
profile_emissions_impl <- function(companies,
                                   co2,
                                   europages_companies,
                                   ecoinvent_activities,
                                   ecoinvent_europages,
                                   isic,
                                   isic_tilt = lifecycle::deprecated(),
                                   low_threshold = 1 / 3,
                                   high_threshold = 2 / 3) {
  if (lifecycle::is_present(isic_tilt)) {
    lifecycle::deprecate_warn(
      "0.0.0.9017",
      "profile_emissions(isic_tilt)",
      "profile_emissions(isic)"
    )
    isic <- isic_tilt
  }

  europages_companies <- select_europages_companies(europages_companies)

  indicator <- list(
    companies,
    add_rowid(co2),
    low_threshold,
    high_threshold
  )
  indicator_after <- list(
    europages_companies,
    ecoinvent_activities,
    ecoinvent_europages,
    isic
  )
  exec_profile("emissions_profile", indicator, indicator_after) |>
    tilt_profile()
}
