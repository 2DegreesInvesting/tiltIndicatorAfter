test_that("total number of rows for a comapny is either 1 or 6", {
  out <- prepare_pctr_product(pctr_product, ep_companies, ecoinvent_activities, matches_mapper, isic_tilt_mapper) |>
    group_by(companies_id, ep_product, activity_uuid_product_uuid) |>
    summarise(count = n())
  expect_true(all(unique(out$count) %in% c(1, 6)))
})

test_that("throws no error", {
  # FIXME: Create an example_emissions_profile_product()
  emissions_profile_product <- tibble(
    companies_id = "a",
    grouped_by = "all",
    risk_category = "high",
    co2_footprint = 1,
    tilt_sector = "Industry",
    tilt_subsector = "Other",
    isic_4digit = "2560"
  )
  europages_companies <- tiltIndicatorAfter::ep_companies |> head(1)
  ecoinvent_activities <- tiltIndicatorAfter::ecoinvent_activities |> head(1)
  europages_ecoinvent <- tiltIndicatorAfter::matches_mapper |> head(1)
  isic_tilt <- tiltIndicatorAfter::isic_tilt_mapper |> head(1)

  expect_no_error(
    emissions_profile_product |>
    prepare_pctr_product(
      europages_companies,
      ecoinvent_activities,
      europages_ecoinvent,
      isic_tilt
    )
  )
})
