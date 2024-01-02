test_that("irrelevant columns in europages_companies aren't in the output ", {
  local_options(readr.show_col_types = FALSE)

  companies <- read_csv(toy_sector_profile_companies())
  scenarios <- read_csv(toy_sector_profile_any_scenarios())

  europages_companies <- ep_companies |> head(3)
  europages_companies$new <- "test"

  ecoinvent_activities <- ecoinvent_activities |> head(3)
  ecoinvent_europages <- small_matches_mapper |> head(3)
  isic <- isic_name |> head(3)

  out <- profile_sector(
    companies,
    scenarios,
    europages_companies,
    ecoinvent_activities,
    ecoinvent_europages,
    isic
  )

  expect_false(hasName(unnest_product(out), "new"))
  expect_false(hasName(unnest_company(out), "new"))
})

test_that("the new API is equivalent to the old API except for extra columns", {
  local_options(readr.show_col_types = FALSE)

  companies <- read_csv(toy_sector_profile_companies())
  scenarios <- read_csv(toy_sector_profile_any_scenarios())
  europages_companies <- ep_companies |> head(3)
  ecoinvent_activities <- ecoinvent_activities |> head(3)
  ecoinvent_europages <- small_matches_mapper |> head(3)
  isic <- isic_name |> head(3)

  # New API
  out <- profile_sector(
    companies,
    scenarios,
    europages_companies,
    ecoinvent_activities,
    ecoinvent_europages,
    isic
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

  out_product <- prepare_pstr_product(
    product,
    europages_companies,
    ecoinvent_activities,
    ecoinvent_europages,
    isic
  )

  out_company <- prepare_pstr_company(
    company,
    product,
    europages_companies,
    ecoinvent_activities,
    ecoinvent_europages,
    isic
  )

  expect_equal(
    out |> unnest_product() |> arrange(companies_id),
    out_product |> arrange(companies_id)
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
  europages_companies <- ep_companies |> head(3)
  ecoinvent_activities <- ecoinvent_activities |> head(3)
  ecoinvent_europages <- small_matches_mapper |> head(3)
  isic <- isic_name |> head(3)

  out <- profile_sector(
    companies,
    scenarios,
    europages_companies,
    ecoinvent_activities,
    ecoinvent_europages,
    isic
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
  europages_companies <- ep_companies |> head(3)
  ecoinvent_activities <- ecoinvent_activities |> head(3)
  ecoinvent_europages <- small_matches_mapper |> head(3)
  isic <- isic_name |> head(3)

  out <- profile_sector(
    companies,
    scenarios,
    europages_companies,
    ecoinvent_activities,
    ecoinvent_europages,
    isic
  )

  actual <- rm_na(unique(unnest_product(out)$isic_4digit))
  expect_equal(actual, "1")
})
