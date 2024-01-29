test_that("characterize columns", {
  local_options(readr.show_col_types = FALSE)

  companies <- read_csv(toy_sector_profile_upstream_companies())
  scenarios <- read_csv(toy_sector_profile_any_scenarios())
  inputs <- read_csv(toy_sector_profile_upstream_products())
  europages_companies <- read_csv(toy_europages_companies())
  ecoinvent_activities <- read_csv(toy_ecoinvent_activities())
  ecoinvent_europages <- read_csv(toy_ecoinvent_europages())
  ecoinvent_inputs <- read_csv(toy_ecoinvent_inputs())
  isic_name <- read_csv(toy_isic_name())

  out <- profile_sector_upstream(
    companies,
    scenarios,
    inputs,
    europages_companies,
    ecoinvent_activities,
    ecoinvent_inputs,
    ecoinvent_europages,
    isic_name
  )

  expect_snapshot(names(unnest_product(out)))

  expect_snapshot(names(unnest_company(out)))
})

test_that("the new API is equivalent to the old API except for extra columns", {
  local_options(readr.show_col_types = FALSE)

  companies <- read_csv(toy_sector_profile_upstream_companies())
  scenarios <- read_csv(toy_sector_profile_any_scenarios())
  inputs <- read_csv(toy_sector_profile_upstream_products())
  europages_companies <- read_csv(toy_europages_companies())
  ecoinvent_activities <- read_csv(toy_ecoinvent_activities())
  ecoinvent_europages <- read_csv(toy_ecoinvent_europages())
  ecoinvent_inputs <- read_csv(toy_ecoinvent_inputs())
  isic_name <- read_csv(toy_isic_name())

  # New API
  out <- profile_sector_upstream(
    companies,
    scenarios,
    inputs,
    europages_companies,
    ecoinvent_activities,
    ecoinvent_inputs,
    ecoinvent_europages,
    isic_name
  )

  # Old API
  .inputs <- add_rowid(inputs)
  output <- sector_profile_upstream(companies, scenarios, .inputs)
  .product <- unnest_product(output)

  y <- select(.inputs, matches(extra_cols_pattern()))
  x <- select(.product, -any_of(names(y)), extra_rowid())
  product <- left_join(x, y, relationship = "many-to-many", by = extra_rowid())
  company <- unnest_company(output)
  europages_companies_old <- select_europages_companies(europages_companies)
  ecoinvent_inputs_old <- select_ecoinvent_inputs(ecoinvent_inputs)

  out_product <- prepare_istr_product(
    product,
    europages_companies_old,
    ecoinvent_activities,
    ecoinvent_europages,
    ecoinvent_inputs_old,
    isic_name
  )

  out_company <- prepare_istr_company(
    company,
    product,
    europages_companies_old,
    ecoinvent_activities,
    ecoinvent_europages,
    ecoinvent_inputs_old,
    isic_name
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

  companies <- read_csv(toy_sector_profile_upstream_companies())
  scenarios <- read_csv(toy_sector_profile_any_scenarios())
  inputs <- read_csv(toy_sector_profile_upstream_products())
  europages_companies <- read_csv(toy_europages_companies())
  ecoinvent_activities <- read_csv(toy_ecoinvent_activities())
  ecoinvent_europages <- read_csv(toy_ecoinvent_europages())
  ecoinvent_inputs <- read_csv(toy_ecoinvent_inputs())
  isic_name <- read_csv(toy_isic_name())

  out <- profile_sector_upstream(
    companies,
    scenarios,
    inputs,
    europages_companies = europages_companies,
    ecoinvent_activities = read_csv(toy_ecoinvent_activities()),
    ecoinvent_inputs = read_csv(toy_ecoinvent_inputs()),
    ecoinvent_europages = ecoinvent_europages,
    isic_name
  )

  product <- unnest_product(out)
  expect_true(any(matches_name(product, "isic")))
  expect_true(any(matches_name(product, "sector")))
})

test_that("doesn't pad `*isic*`", {
  local_options(readr.show_col_types = FALSE)

  companies <- read_csv(toy_sector_profile_upstream_companies())
  scenarios <- read_csv(toy_sector_profile_any_scenarios())
  inputs <- read_csv(toy_sector_profile_upstream_products())
  inputs$input_isic_4digit <- "1"

  europages_companies <- read_csv(toy_europages_companies())
  ecoinvent_activities <- read_csv(toy_ecoinvent_activities())
  ecoinvent_europages <- read_csv(toy_ecoinvent_europages())
  ecoinvent_inputs <- read_csv(toy_ecoinvent_inputs())
  isic_name <- read_csv(toy_isic_name())

  out <- profile_sector_upstream(
    companies,
    scenarios,
    inputs,
    europages_companies = europages_companies,
    ecoinvent_activities = read_csv(toy_ecoinvent_activities()),
    ecoinvent_inputs = read_csv(toy_ecoinvent_inputs()),
    ecoinvent_europages = ecoinvent_europages,
    isic_name
  )

  actual <- rm_na(unique(unnest_product(out)$input_isic_4digit))
  expect_equal(actual, "1")
})

test_that("`ei_geography` and `input_ei_grougraphy` columns are present at product level output", {
  local_options(readr.show_col_types = FALSE)

  companies <- read_csv(toy_sector_profile_upstream_companies())
  scenarios <- read_csv(toy_sector_profile_any_scenarios())
  inputs <- read_csv(toy_sector_profile_upstream_products())
  europages_companies <- read_csv(toy_europages_companies())
  ecoinvent_activities <- read_csv(toy_ecoinvent_activities())
  ecoinvent_europages <- read_csv(toy_ecoinvent_europages())
  ecoinvent_inputs <- read_csv(toy_ecoinvent_inputs())
  isic_name <- read_csv(toy_isic_name())

  out <- profile_sector_upstream(
    companies,
    scenarios,
    inputs,
    europages_companies,
    ecoinvent_activities,
    ecoinvent_inputs,
    ecoinvent_europages,
    isic_name
  ) |> unnest_product()

  expect_true(all(c("ei_geography", "ei_input_geography") %in% names(out)))
})
