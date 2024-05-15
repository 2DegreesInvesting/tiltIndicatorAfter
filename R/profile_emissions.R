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
  profile_emissions_impl(
    companies = companies,
    co2 = co2,
    europages_companies = europages_companies,
    ecoinvent_activities = ecoinvent_activities,
    ecoinvent_europages = ecoinvent_europages,
    isic = isic,
    isic_tilt = isic_tilt,
    low_threshold = low_threshold,
    high_threshold = high_threshold
  ) |>
    add_co2(co2, jitter_amount = option_jitter_amount()) |>
    best_case_worst_case(best_case_worst_case_emission_profile) |>
    polish_emissions_any(
      output_min_max = option_output_min_max(),
      output_co2_footprint = option_output_co2_footprint()
    )
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
