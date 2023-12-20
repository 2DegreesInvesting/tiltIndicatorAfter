#' @rdname profile_emissions_upstream
#' @export
profile_emissions <- function(companies,
                              co2,
                              europages_companies,
                              ecoinvent_activities,
                              ecoinvent_europages,
                              isic_tilt,
                              low_threshold = 1 / 3,
                              high_threshold = 2 / 3) {
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
    isic_tilt
  )
  exec_profile("emissions_profile", indicator, indicator_after)
}
