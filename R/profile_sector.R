#' @rdname profile_sector_upstream
#' @export
profile_sector <- function(companies,
                           scenarios,
                           europages_companies,
                           ecoinvent_activities,
                           ecoinvent_europages,
                           isic,
                           isic_tilt = lifecycle::deprecated(),
                           low_threshold = ifelse(scenarios$year == 2030, 1 / 9, 1 / 3),
                           high_threshold = ifelse(scenarios$year == 2030, 2 / 9, 2 / 3)) {
  profile_sector_impl(
    companies = companies,
    scenarios = scenarios,
    europages_companies = europages_companies,
    ecoinvent_activities = ecoinvent_activities,
    ecoinvent_europages = ecoinvent_europages,
    isic = isic,
    isic_tilt = isic_tilt,
    low_threshold = low_threshold,
    high_threshold = high_threshold
  )
}

#' @rdname profile_impl
#' @export
#' @keywords internal
profile_sector_impl <- function(companies,
                                scenarios,
                                europages_companies,
                                ecoinvent_activities,
                                ecoinvent_europages,
                                isic,
                                isic_tilt = lifecycle::deprecated(),
                                low_threshold = ifelse(scenarios$year == 2030, 1 / 9, 1 / 3),
                                high_threshold = ifelse(scenarios$year == 2030, 2 / 9, 2 / 3)) {
  if (lifecycle::is_present(isic_tilt)) {
    lifecycle::deprecate_warn(
      "0.0.0.9017",
      "profile_sector(isic_tilt)",
      "profile_sector(isic)"
    )
    isic <- isic_tilt
  }

  europages_companies <- select_europages_companies(europages_companies)

  indicator <- list(
    add_rowid(companies),
    scenarios,
    low_threshold,
    high_threshold
  )
  indicator_after <- list(
    europages_companies,
    ecoinvent_activities,
    ecoinvent_europages,
    isic
  )
  exec_profile("sector_profile", indicator, indicator_after) |>
    tilt_profile()
}
