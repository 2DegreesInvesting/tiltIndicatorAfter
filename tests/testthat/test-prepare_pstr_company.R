test_that("total number of rows for a comapny is either 1 or 3", {
  local_options(readr.show_col_types = FALSE)

  companies <- read_csv(toy_sector_profile_companies())
  scenarios <- read_csv(toy_sector_profile_any_scenarios())
  europages_companies <- read_csv(toy_europages_companies()) |> head(3)
  ecoinvent_activities <- read_csv(toy_ecoinvent_activities()) |> head(3)
  ecoinvent_europages <- read_csv(toy_ecoinvent_europages()) |> head(3)
  isic_name <- read_csv(toy_isic_name()) |> head(3)


  out <- profile_sector(
    companies,
    scenarios,
    europages_companies = europages_companies,
    ecoinvent_activities = ecoinvent_activities,
    ecoinvent_europages = ecoinvent_europages,
    isic = isic_name
  ) |>
    unnest_company() |>
    group_by(companies_id, scenario, year) |>
    summarise(count = n())

  expect_true(all(unique(out$count) %in% c(1, 3)))
})

test_that("'empty' tiltIndicator results yield at most 1 NA in *profile$ risk column", {
  local_options(readr.show_col_types = FALSE)

  companies <- read_csv(toy_sector_profile_companies())
  scenarios_that_yields_na <- read_csv(toy_sector_profile_any_scenarios()) |>
    head(1)

  europages_companies <- read_csv(toy_europages_companies())
  ecoinvent_activities <- read_csv(toy_ecoinvent_activities())
  ecoinvent_europages <- read_csv(toy_ecoinvent_europages())
  isic_name <- read_csv(toy_isic_name())


  result <- profile_sector(
    companies,
    scenarios_that_yields_na,
    europages_companies = europages_companies,
    ecoinvent_activities = ecoinvent_activities,
    ecoinvent_europages = ecoinvent_europages,
    isic = isic_name
  ) |>
    unnest_company()

  na <- filter(result, is.na(get_column(result, "profile$")))
  # Ensure we have many missing values
  stopifnot(nrow(na) > 5)
  # Ensure we have many companies
  stopifnot(length(unique(na$companies_id)) > 5)

  number_of_na_per_company <- count(na, companies_id)$n
  expect_equal(unique(number_of_na_per_company), 1)
})
