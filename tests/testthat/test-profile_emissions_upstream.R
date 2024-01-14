test_that("irrelevant columns in `ecoinvent_inputs` aren't in the output", {
  local_options(readr.show_col_types = FALSE)

  companies <- read_csv(toy_emissions_profile_any_companies())
  co2 <- read_csv(toy_emissions_profile_upstream_products())
  europages_companies <- read_csv(toy_europages_companies()) |> head(3)
  ecoinvent_activities <- ecoinvent_activities |> head(3)

  ecoinvent_inputs <- ecoinvent_inputs |> head(3)
  ecoinvent_inputs$new <- "test"

  ecoinvent_europages <- small_matches_mapper |> head(3)
  isic <- isic_name |> head(3)

  out <- profile_emissions_upstream(
    companies,
    co2,
    europages_companies = europages_companies,
    ecoinvent_activities = ecoinvent_activities,
    ecoinvent_inputs = ecoinvent_inputs,
    ecoinvent_europages = ecoinvent_europages,
    isic = isic_name
  )

  expect_false(hasName(unnest_product(out), "new"))
  expect_false(hasName(unnest_company(out), "new"))
})

test_that("the new API is equivalent to the old API except for extra columns", {
  local_options(readr.show_col_types = FALSE)

  companies <- read_csv(toy_emissions_profile_any_companies())
  co2 <- read_csv(toy_emissions_profile_upstream_products())
  europages_companies <- read_csv(toy_europages_companies()) |> head(3)
  ecoinvent_activities <- ecoinvent_activities |> head(3)
  ecoinvent_inputs <- ecoinvent_inputs |> head(3)
  ecoinvent_europages <- small_matches_mapper |> head(3)
  isic <- isic_name |> head(3)

  # New API
  out <- profile_emissions_upstream(
    companies,
    co2,
    europages_companies = europages_companies,
    ecoinvent_activities = ecoinvent_activities,
    ecoinvent_inputs = ecoinvent_inputs,
    ecoinvent_europages = ecoinvent_europages,
    isic = isic_name
  )

  # Old API
  .co2 <- add_rowid(co2)
  output <- emissions_profile_upstream(companies, .co2)


  company <- unnest_company(output)
  product <- unnest_product(output) |>
    left_join(select(.co2, matches(extra_cols_pattern())), by = extra_rowid())

  out_product <- prepare_ictr_product(
    product,
    europages_companies,
    ecoinvent_activities,
    ecoinvent_europages,
    ecoinvent_inputs,
    isic
  )

  out_company <- prepare_ictr_company(
    company,
    product,
    europages_companies,
    ecoinvent_activities,
    ecoinvent_europages,
    ecoinvent_inputs,
    isic
  )

  new <- arrange(unnest_product(out), companies_id)
  old <- arrange(out_product, companies_id)
  expect_equal(relocate(new, sort(names(new))), relocate(old, sort(names(old))))

  expect_equal(
    out |> unnest_company() |> arrange(companies_id),
    out_company |> arrange(companies_id)
  )
})

test_that("the output at product level has columns matching isic and sector", {
  local_options(readr.show_col_types = FALSE)

  companies <- read_csv(toy_emissions_profile_any_companies())
  co2 <- read_csv(toy_emissions_profile_upstream_products())
  europages_companies <- read_csv(toy_europages_companies()) |> head(3)
  ecoinvent_activities <- ecoinvent_activities |> head(3)
  ecoinvent_inputs <- ecoinvent_inputs |> head(3)
  ecoinvent_europages <- small_matches_mapper |> head(3)
  isic <- isic_name |> head(3)

  out <- profile_emissions_upstream(
    companies,
    co2,
    europages_companies = europages_companies,
    ecoinvent_activities = ecoinvent_activities,
    ecoinvent_inputs = ecoinvent_inputs,
    ecoinvent_europages = ecoinvent_europages,
    isic = isic_name
  )

  product <- unnest_product(out)
  expect_true(any(matches_name(product, "isic")))
  expect_true(any(matches_name(product, "sector")))
})

test_that("doesn't pad `*isic*`", {
  skip_unless_toy_data_is_newer_than(toy_data_version())
  local_options(readr.show_col_types = FALSE)

  companies <- read_csv(toy_emissions_profile_any_companies())
  co2 <- read_csv(tiltToyData::toy_emissions_profile_upstream_products_ecoinvent())
  co2$input_isic_4digit <- "1"

  europages_companies <- read_csv(toy_europages_companies()) |> head(3)
  ecoinvent_activities <- ecoinvent_activities |> head(3)
  ecoinvent_inputs <- ecoinvent_inputs |> head(3)
  ecoinvent_europages <- small_matches_mapper |> head(3)
  isic <- isic_name |> head(3)

  out <- profile_emissions_upstream(
    companies,
    co2,
    europages_companies = europages_companies,
    ecoinvent_activities = ecoinvent_activities,
    ecoinvent_inputs = ecoinvent_inputs,
    ecoinvent_europages = ecoinvent_europages,
    isic = isic_name
  )

  actual <- rm_na(unique(unnest_product(out)$input_isic_4digit))
  expect_equal(actual, "1")
})
