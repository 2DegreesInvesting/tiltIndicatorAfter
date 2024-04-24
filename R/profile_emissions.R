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
  out <- profile_emissions_impl(
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

  # TODO: consider overwrite optionally_output_co2_footprint()
  if (output_co2_footprint()) {
    out <- out |>
      summarize_co2_range() |>
      # TODO consider set_jitter_amount()?
      jitter_co2_range(amount = 1) |>
      polish_co2_range() |>
      join_to(out |> exclude("co2_footprint"))
  }

  out
}

#' @rdname composable_friends
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
    # FIXME: Move outside _impl()
    optionally_output_co2_footprint(select(co2, matches(c("_uuid", "co2_footprint")))) |>
    tilt_profile()
}
