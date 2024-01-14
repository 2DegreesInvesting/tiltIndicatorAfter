test_that("total number of rows for a comapny is either 1 or 3", {
  local_options(readr.show_col_types = FALSE)

  companies <- read_csv(toy_sector_profile_upstream_companies())
  scenarios <- read_csv(toy_sector_profile_any_scenarios())
  inputs <- read_csv(toy_sector_profile_upstream_products())

  out <- profile_sector_upstream(
    companies,
    scenarios,
    inputs,
    europages_companies = read_csv(toy_europages_companies()),
    ecoinvent_activities = read_csv(toy_ecoinvent_activities()),
    ecoinvent_inputs = read_csv(toy_ecoinvent_inputs()),
    ecoinvent_europages = small_matches_mapper,
    isic = isic_name
  ) |>
    unnest_company() |>
    group_by(companies_id, scenario, year) |>
    summarise(count = n())
  expect_true(all(unique(out$count) %in% c(1, 3)))
})
