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
  tilt_profile <- profile_emissions_impl(
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

  out <- tilt_profile |>
    summarize_co2_range() |>
    jitter_co2_range(amount = option_jitter_amount()) |>
    polish_co2_range(output_min_max = option_output_min_max()) |>
    join_to(tilt_profile)

  # TODO Move to polish
  if (!option_output_co2_footprint()) {
    out <- out |> exclude("co2_footprint")
  }

  out

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
    # FIXME: Move to the edge
    output_co2_footprint(select(co2, matches(c("_uuid", "co2_footprint")))) |>
    tilt_profile()
}
