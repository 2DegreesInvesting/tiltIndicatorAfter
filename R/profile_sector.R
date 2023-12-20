#' @rdname profile_sector_upstream
#' @export
profile_sector <- function(companies,
                           scenarios,
                           europages_companies,
                           ecoinvent_activities,
                           ecoinvent_europages,
                           isic_tilt,
                           low_threshold = ifelse(scenarios$year == 2030, 1 / 9, 1 / 3),
                           high_threshold = ifelse(scenarios$year == 2030, 2 / 9, 2 / 3)) {
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
    isic_tilt
  )
  exec_profile("sector_profile", indicator, indicator_after)
}
