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
    may_add_licensed_co2_columns(select(co2, matches(c("_uuid", "co2_footprint"))))
}
