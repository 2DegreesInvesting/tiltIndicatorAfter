test_that("yields a 'tilt_profile'", {
  companies <- read_csv(toy_sector_profile_companies())
  scenarios <- read_csv(toy_sector_profile_any_scenarios())

  europages_companies <- read_csv(toy_europages_companies())
  ecoinvent_activities <- read_csv(toy_ecoinvent_activities())
  ecoinvent_europages <- read_csv(toy_ecoinvent_europages())
  isic_name <- read_csv(toy_isic_name())

  out <- profile_sector(
    companies,
    scenarios,
    europages_companies,
    ecoinvent_activities,
    ecoinvent_europages,
    isic_name
  )

  expect_s3_class(out, "tilt_profile")
})

test_that("irrelevant columns in europages_companies aren't in the output ", {
  companies <- read_csv(toy_sector_profile_companies())
  scenarios <- read_csv(toy_sector_profile_any_scenarios())

  europages_companies <- read_csv(toy_europages_companies())
  europages_companies$new <- "test"

  ecoinvent_activities <- read_csv(toy_ecoinvent_activities())
  ecoinvent_europages <- read_csv(toy_ecoinvent_europages())
  isic_name <- read_csv(toy_isic_name())

  out <- profile_sector(
    companies,
    scenarios,
    europages_companies,
    ecoinvent_activities,
    ecoinvent_europages,
    isic_name
  )

  expect_false(hasName(unnest_product(out), "new"))
  expect_false(hasName(unnest_company(out), "new"))
})

test_that("the output at product level has columns matching isic and sector", {
  companies <- read_csv(toy_sector_profile_companies())
  scenarios <- read_csv(toy_sector_profile_any_scenarios())
  europages_companies <- read_csv(toy_europages_companies())
  ecoinvent_activities <- read_csv(toy_ecoinvent_activities())
  ecoinvent_europages <- read_csv(toy_ecoinvent_europages())
  isic_name <- read_csv(toy_isic_name())

  out <- profile_sector(
    companies,
    scenarios,
    europages_companies,
    ecoinvent_activities,
    ecoinvent_europages,
    isic_name
  )

  product <- unnest_product(out)
  expect_true(any(matches_name(product, "isic")))
  expect_true(any(matches_name(product, "sector")))
})

test_that("doesn't pad `*isic*`", {
  companies <- read_csv(toy_sector_profile_companies())
  companies$isic_4digit <- "1"

  scenarios <- read_csv(toy_sector_profile_any_scenarios())
  europages_companies <- read_csv(toy_europages_companies())
  ecoinvent_activities <- read_csv(toy_ecoinvent_activities())
  ecoinvent_europages <- read_csv(toy_ecoinvent_europages())
  isic_name <- read_csv(toy_isic_name())

  out <- profile_sector(
    companies,
    scenarios,
    europages_companies,
    ecoinvent_activities,
    ecoinvent_europages,
    isic_name
  )

  actual <- rm_na(unique(unnest_product(out)$isic_4digit))
  expect_equal(actual, "1")
})

test_that("`ei_geography` column is present at product level output", {
  companies <- read_csv(toy_sector_profile_companies())
  scenarios <- read_csv(toy_sector_profile_any_scenarios())
  europages_companies <- read_csv(toy_europages_companies())
  ecoinvent_activities <- read_csv(toy_ecoinvent_activities())
  ecoinvent_europages <- read_csv(toy_ecoinvent_europages())
  isic_name <- read_csv(toy_isic_name())

  out <- profile_sector(
    companies,
    scenarios,
    europages_companies,
    ecoinvent_activities,
    ecoinvent_europages,
    isic_name
  ) |> unnest_product()

  expect_true(all(c("ei_geography") %in% names(out)))
})

test_that("total number of rows for a comapny is either 1 or 4", {
  skip_unless_tilt_indicator_is_newer_than("0.0.0.9209")

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

  expect_true(all(unique(out$count) %in% c(1, 4)))
})

test_that("'empty' tiltIndicator results yield at most 1 NA in *profile$ risk column", {
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

test_that("total number of rows for a comapny is either 1, 2 or 4", {
  # this test is applied on real data to ascertain that number of rows can either be 1, 2, or 4

  companies <- read_csv(toy_sector_profile_companies())
  scenarios <- read_csv(toy_sector_profile_any_scenarios())
  europages_companies <- read_csv(toy_europages_companies())
  ecoinvent_activities <- read_csv(toy_ecoinvent_activities())
  ecoinvent_europages <- read_csv(toy_ecoinvent_europages())
  isic_name <- read_csv(toy_isic_name())

  product <- profile_sector(
    companies,
    scenarios,
    europages_companies,
    ecoinvent_activities,
    ecoinvent_europages,
    isic_name
  ) |> unnest_product()

  out <- product |>
    group_by(companies_id, ep_product, activity_uuid_product_uuid) |>
    summarise(count = n())

  expect_true(all(unique(out$count) %in% c(1, 2, 4)))
})

test_that("'empty' tiltIndicator results yield at most 1 NA in *profile$ risk column", {
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
    unnest_product()

  na <- filter(result, is.na(get_column(result, "profile$")))
  # Ensure we have many missing values
  stopifnot(nrow(na) > 5)
  # Ensure we have many companies
  stopifnot(length(unique(na$companies_id)) > 5)

  number_of_na_per_company <- count(na, companies_id)$n
  expect_equal(unique(number_of_na_per_company), 1)
})

test_that("yield NA in `*tilt_sector` and `*tilt_subsector` in *profile$ risk column", {
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
    unnest_product()

  na <- filter(result, is.na(get_column(result, "profile$")))
  # Ensure we have many missing values
  stopifnot(nrow(na) > 5)
  # Ensure we have many companies
  stopifnot(length(unique(na$companies_id)) > 5)

  these_cols_are_full_of_na <- all(is.na(select(na, tilt_sector, tilt_subsector)))
  expect_true(these_cols_are_full_of_na)
})

test_that("outputs `profile_ranking_avg` at company level", {
  companies <- read_csv(toy_sector_profile_companies())
  scenarios <- read_csv(toy_sector_profile_any_scenarios())
  europages_companies <- read_csv(toy_europages_companies())
  ecoinvent_activities <- read_csv(toy_ecoinvent_activities())
  ecoinvent_europages <- read_csv(toy_ecoinvent_europages())
  isic_name <- read_csv(toy_isic_name())

  out <- profile_sector(
    companies,
    scenarios,
    europages_companies,
    ecoinvent_activities,
    ecoinvent_europages,
    isic_name
  )

  company <- unnest_company(out)
  expect_true(hasName(company, "reduction_targets_avg"))
})

test_that("given a product in 'ipr', when scenarios has also 'weo', then the product-result includes a 'weo*' `scenario` and maps to `NA` in `sector_profile` (#279, tiltIndicator#739)", {
  one_type <- "ipr"
  companies <- read_csv(toy_sector_profile_companies()) |>
    filter(type == one_type) |>
    head(1)

  scenarios <- read_csv(toy_sector_profile_any_scenarios())
  has_two_types <- all(sort(unique(scenarios$type)) %in% c("ipr", "weo"))
  stopifnot(has_two_types)

  europages_companies <- read_csv(toy_europages_companies())
  ecoinvent_activities <- read_csv(toy_ecoinvent_activities())
  ecoinvent_europages <- read_csv(toy_ecoinvent_europages())
  isic_name <- read_csv(toy_isic_name())

  product <- profile_sector(
    companies,
    scenarios,
    europages_companies,
    ecoinvent_activities,
    ecoinvent_europages,
    isic_name
  ) |>
    unnest_product()

  actual <- product |>
    distinct(scenario) |>
    left_join(distinct(scenarios, scenario, type), by = "scenario")

  expect_equal(sort(unique(actual$type)), c("ipr", "weo"))
  expect_true(anyNA(product$sector_profile))
})
