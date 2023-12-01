#' @rdname profile_sector_upstream
#' @export
profile_sector <- function(companies,
                           scenarios,
                           europages_companies,
                           ecoinvent_activities,
                           ecoinvent_europages,
                           low_threshold = ifelse(scenarios$year == 2030, 1 / 9, 1 / 3),
                           high_threshold = ifelse(scenarios$year == 2030, 2 / 9, 2 / 3)) {
  indicator <- list(
    rowid_to_column(companies, "extra_rowid"),
    scenarios,
    low_threshold,
    high_threshold
  )
  indicator_after <- list(
    europages_companies,
    ecoinvent_activities,
    ecoinvent_europages
  )
  exec_profile("sector_profile", indicator, indicator_after)
}
