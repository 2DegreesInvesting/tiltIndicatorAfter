test_that("the new API is equivalent to the old API except for extra columns", {
  local_options(readr.show_col_types = FALSE)

  companies <- read_csv(toy_sector_profile_upstream_companies())
  scenarios <- read_csv(toy_sector_profile_any_scenarios())
  inputs <- read_csv(toy_sector_profile_upstream_products())
  europages_companies <- ep_companies |> head(3)
  ecoinvent_activities <- ecoinvent_activities |> head(3)
  ecoinvent_europages <- small_matches_mapper |> head(3)
  ecoinvent_inputs <- ecoinvent_inputs |> head(3)
  isic_tilt <- isic_tilt_mapper |> head(3)

  # New API
  out <- profile_sector_upstream(
    companies,
    scenarios,
    inputs,
    europages_companies,
    ecoinvent_activities,
    ecoinvent_inputs,
    ecoinvent_europages,
    isic_tilt
  )

  # Old API
  .inputs <- add_rowid(inputs)
  output <- sector_profile_upstream(companies, scenarios, .inputs)
  .product <- unnest_product(output)

  y <- select(.inputs, matches(extra_cols_pattern()))
  x <- select(.product, -any_of(names(y)), extra_rowid())
  product <- left_join(x, y, relationship = "many-to-many", by = extra_rowid())
  company <- unnest_company(output)

  out_product <- prepare_istr_product(
    product,
    europages_companies,
    ecoinvent_activities,
    ecoinvent_europages,
    ecoinvent_inputs,
    isic_tilt
  )

  out_company <- prepare_istr_company(
    company,
    product,
    europages_companies,
    ecoinvent_activities,
    ecoinvent_europages,
    ecoinvent_inputs,
    isic_tilt
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
  europages_companies <- ep_companies |> head(3)
  ecoinvent_activities <- ecoinvent_activities |> head(3)
  ecoinvent_europages <- small_matches_mapper |> head(3)
  ecoinvent_inputs <- ecoinvent_inputs |> head(3)
  isic_tilt <- isic_tilt_mapper |> head(3)

  out <- profile_sector_upstream(
    companies,
    scenarios,
    inputs,
    europages_companies = europages_companies,
    ecoinvent_activities = ecoinvent_activities,
    ecoinvent_inputs = ecoinvent_inputs,
    ecoinvent_europages = ecoinvent_europages,
    isic_tilt
  )

  product <- unnest_product(out)
  expect_true(any(matches_name(product, "isic")))
  expect_true(any(matches_name(product, "sector")))
})
