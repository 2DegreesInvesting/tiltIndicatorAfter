test_that("total number of rows for a comapny is either 1 or 3", {
  local_options(readr.show_col_types = FALSE)

  companies <- read_csv(toy_sector_profile_companies())
  scenarios <- read_csv(toy_sector_profile_any_scenarios())

  out <- profile_sector(
    companies,
    scenarios,
    europages_companies = ep_companies,
    ecoinvent_activities = ecoinvent_activities,
    ecoinvent_europages = small_matches_mapper,
    isic = isic_tilt_mapper
  ) |>
    unnest_company() |>
    group_by(companies_id, scenario, year) |>
    summarise(count = n())

  expect_true(all(unique(out$count) %in% c(1, 3)))
})

test_that("'empty' tiltIndicator results yield at most 1 NA in *risk_category", {
  local_options(readr.show_col_types = FALSE)

  companies <- read_csv(toy_sector_profile_companies())
  scenarios_that_yields_na <- read_csv(toy_sector_profile_any_scenarios()) |>
    head(1)

  result <- profile_sector(
    companies,
    scenarios_that_yields_na,
    europages_companies = ep_companies,
    ecoinvent_activities = ecoinvent_activities,
    ecoinvent_europages = small_matches_mapper,
    isic = isic_tilt_mapper
  ) |>
    unnest_company()

  na <- filter(result, is.na(get_column(result, "risk_category")))
  # Ensure we have many missing values
  stopifnot(nrow(na) > 5)
  # Ensure we have many companies
  stopifnot(length(unique(na$companies_id)) > 5)

  number_of_na_per_company <- count(na, companies_id)$n
  expect_equal(unique(number_of_na_per_company), 1)
})
