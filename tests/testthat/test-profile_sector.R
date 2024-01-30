test_that("irrelevant columns in europages_companies aren't in the output ", {
  local_options(readr.show_col_types = FALSE)

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

test_that("the new API is equivalent to the old API except for extra columns", {
  local_options(readr.show_col_types = FALSE)

  companies <- read_csv(toy_sector_profile_companies())
  scenarios <- read_csv(toy_sector_profile_any_scenarios())
  europages_companies <- read_csv(toy_europages_companies())
  ecoinvent_activities <- read_csv(toy_ecoinvent_activities())
  ecoinvent_europages <- read_csv(toy_ecoinvent_europages())
  isic_name <- read_csv(toy_isic_name())

  # New API
  out <- profile_sector(
    companies,
    scenarios,
    europages_companies,
    ecoinvent_activities,
    ecoinvent_europages,
    isic_name
  )

  # Old API
  .companies <- add_rowid(companies)
  output <- sector_profile(.companies, scenarios)
  .product <- unnest_product(output)
  product <- left_join(
    select(.product, -matches(extra_cols_pattern()), extra_rowid()),
    select(.companies, matches(extra_cols_pattern())),
    relationship = "many-to-many",
    by = extra_rowid()
  )
  company <- unnest_company(output)
  europages_companies_old <- select_europages_companies(europages_companies)

  out_product <- prepare_pstr_product(
    product,
    europages_companies_old,
    ecoinvent_activities,
    ecoinvent_europages,
    isic_name
  )

  out_company <- prepare_pstr_company(
    company,
    product,
    europages_companies_old,
    ecoinvent_activities,
    ecoinvent_europages,
    isic_name
  )

  expect_equal(
    out |> unnest_product() |> arrange(companies_id, ep_product),
    out_product |> arrange(companies_id, ep_product)
  )
  expect_equal(
    out |> unnest_company() |> arrange(companies_id),
    out_company |> arrange(companies_id)
  )
})

test_that("the output at product level has columns matching isic and sector", {
  local_options(readr.show_col_types = FALSE)

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
  local_options(readr.show_col_types = FALSE)

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
  local_options(readr.show_col_types = FALSE)

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
