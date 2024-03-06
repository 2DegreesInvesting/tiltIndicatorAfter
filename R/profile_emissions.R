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
  out <- exec_profile("emissions_profile", indicator, indicator_after)

  if (co2_keep_licensed_footprint()) {
    co2_footprint <- select(indicator[[2]], matches(c("uuid", "co2")))
    product <- out |>
      unnest_product() |>
      left_join(co2_footprint, by = "activity_uuid_product_uuid")
    company <- out |> unnest_company()
    out <- nest_levels(product, company)
  }

  out
}

