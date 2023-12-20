# TODO: Move to test-profile_emissions()
test_that("total number of rows for a comapny is either 1 or 6", {
  local_options(readr.show_col_types = FALSE)

  companies <- read_csv(toy_emissions_profile_any_companies())
  co2 <- read_csv(toy_emissions_profile_products())

  out <- profile_emissions(
    companies,
    co2,
    europages_companies = ep_companies,
    ecoinvent_activities = ecoinvent_activities,
    ecoinvent_europages = small_matches_mapper,
    isic_tilt = isic_tilt_mapper
  ) |>
    unnest_product() |>
    group_by(companies_id, ep_product, activity_uuid_product_uuid) |>
    summarise(count = n())
  expect_true(all(unique(out$count) %in% c(1, 6)))
})

test_that("doesn't throw error: 'Column unit doesn't exist' (#26)", {
  local_options(readr.show_col_types = FALSE)

  companies <- read_csv(toy_emissions_profile_any_companies())
  co2 <- read_csv(toy_emissions_profile_products())

  expect_no_error(
    profile_emissions(
      companies,
      co2,
      europages_companies = ep_companies,
      ecoinvent_activities = ecoinvent_activities,
      ecoinvent_europages = small_matches_mapper,
      isic_tilt = isic_tilt_mapper
    )
  )
})

test_that("yields a single distinct value of `*matching_certainty_company_average` per company", {
  # TODO: Rewrite to call the new API
  id <- "id3"
  clustered_one <- "alarm system"
  clustered_two <- "aluminium"
  uuid_one <- "3d731062-1960-5a36-bd19-6ab2b0bf67c2_245732f4-a5ce-4881-816b-a207ba8df4c8"
  uuid_two <- "ff4fd9d9-7dcb-5a50-926f-76ae31fa454d_618bf4eb-bee5-4d38-8e4f-78cfebf779be"

  product <- tibble(
    companies_id = id,
    grouped_by = "a",
    risk_category = "a",
    clustered = c(clustered_one, clustered_one, clustered_two),
    activity_uuid_product_uuid = c(uuid_one, uuid_one, uuid_two),
    co2_footprint = "a",
    tilt_sector = "a",
    tilt_subsector = "a",
    isic_4digit = "a"
  )

  result <- prepare_pctr_product(
    product,
    ep_companies,
    ecoinvent_activities,
    matches_mapper,
    isic_tilt_mapper
  )

  expect_equal(unique(result$matching_certainty_company_average), "low")
})
