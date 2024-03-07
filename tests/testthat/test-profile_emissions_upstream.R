test_that("irrelevant columns in `ecoinvent_inputs` aren't in the output", {
  companies <- read_csv(toy_emissions_profile_any_companies())
  co2 <- read_csv(toy_emissions_profile_upstream_products_ecoinvent())
  europages_companies <- read_csv(toy_europages_companies())
  ecoinvent_activities <- read_csv(toy_ecoinvent_activities())

  ecoinvent_inputs <- read_csv(toy_ecoinvent_inputs())
  ecoinvent_inputs$new <- "test"

  ecoinvent_europages <- read_csv(toy_ecoinvent_europages())
  isic_name <- read_csv(toy_isic_name())

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

test_that("the output at product level has columns matching isic and sector", {
  companies <- read_csv(toy_emissions_profile_any_companies())
  co2 <- read_csv(toy_emissions_profile_upstream_products_ecoinvent())
  europages_companies <- read_csv(toy_europages_companies())
  ecoinvent_activities <- read_csv(toy_ecoinvent_activities())
  ecoinvent_inputs <- read_csv(toy_ecoinvent_inputs())
  ecoinvent_europages <- read_csv(toy_ecoinvent_europages())
  isic_name <- read_csv(toy_isic_name())

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

  companies <- read_csv(toy_emissions_profile_any_companies())
  co2 <- read_csv(toy_emissions_profile_upstream_products_ecoinvent())
  co2$input_isic_4digit <- "1"

  europages_companies <- read_csv(toy_europages_companies())
  ecoinvent_activities <- read_csv(toy_ecoinvent_activities())
  ecoinvent_inputs <- read_csv(toy_ecoinvent_inputs())
  ecoinvent_europages <- read_csv(toy_ecoinvent_europages())
  isic_name <- read_csv(toy_isic_name())

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

test_that("`ei_geography` and `input_ei_grougraphy` columns are present at product level output", {
  companies <- read_csv(toy_emissions_profile_any_companies())
  co2 <- read_csv(toy_emissions_profile_upstream_products_ecoinvent())
  europages_companies <- read_csv(toy_europages_companies())
  ecoinvent_activities <- read_csv(toy_ecoinvent_activities())
  ecoinvent_europages <- read_csv(toy_ecoinvent_europages())
  ecoinvent_inputs <- read_csv(toy_ecoinvent_inputs())
  isic_name <- read_csv(toy_isic_name())

  out <- profile_emissions_upstream(
    companies,
    co2,
    europages_companies,
    ecoinvent_activities,
    ecoinvent_inputs,
    ecoinvent_europages,
    isic_name
  ) |> unnest_product()

  expect_true(all(c("ei_geography", "ei_input_geography") %in% names(out)))
})

test_that("total number of rows for a comapny is either 1 or 4", {
  skip_unless_tilt_indicator_is_newer_than("0.0.0.9206")

  companies <- read_csv(toy_emissions_profile_any_companies())
  co2 <- read_csv(toy_emissions_profile_upstream_products_ecoinvent())

  europages_companies <- read_csv(toy_europages_companies())
  ecoinvent_activities <- read_csv(toy_ecoinvent_activities())
  ecoinvent_inputs <- read_csv(toy_ecoinvent_inputs())
  ecoinvent_europages <- read_csv(toy_ecoinvent_europages())
  isic_name <- read_csv(toy_isic_name())

  out <- profile_emissions_upstream(
    companies,
    co2,
    europages_companies = europages_companies,
    ecoinvent_activities = ecoinvent_activities,
    ecoinvent_inputs = ecoinvent_inputs,
    ecoinvent_europages = ecoinvent_europages,
    isic = isic_name
  ) |>
    unnest_company() |>
    group_by(companies_id, benchmark) |>
    summarise(count = n())

  expect_true(all(unique(out$count) %in% c(1, 4)))
})

test_that("handles numeric `isic*` in `co2`", {
  companies <- read_csv(toy_emissions_profile_any_companies())
  co2 <- read_csv(toy_emissions_profile_upstream_products_ecoinvent())

  europages_companies <- read_csv(toy_europages_companies())
  ecoinvent_activities <- read_csv(toy_ecoinvent_activities())
  ecoinvent_inputs <- read_csv(toy_ecoinvent_inputs())
  ecoinvent_europages <- read_csv(toy_ecoinvent_europages())
  isic_name <- read_csv(toy_isic_name())

  expect_no_error(
    profile_emissions_upstream(
      companies,
      co2 |> modify_col("isic", unquote) |> modify_col("isic", as.numeric),
      europages_companies = europages_companies,
      ecoinvent_activities = ecoinvent_activities,
      ecoinvent_inputs = ecoinvent_inputs,
      ecoinvent_europages = ecoinvent_europages,
      isic = isic_name
    )
  )
})

test_that("the output at product and company level has columns `co2e_lower` and `co2e_upper`", {
  companies <- read_csv(toy_emissions_profile_any_companies())
  co2 <- read_csv(toy_emissions_profile_upstream_products_ecoinvent())
  europages_companies <- read_csv(toy_europages_companies())
  ecoinvent_activities <- read_csv(toy_ecoinvent_activities())
  ecoinvent_inputs <- read_csv(toy_ecoinvent_inputs())
  ecoinvent_europages <- read_csv(toy_ecoinvent_europages())
  isic_name <- read_csv(toy_isic_name())

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
  company <- unnest_company(out)
  expect_true(any(matches_name(product, "co2e_lower")))
  expect_true(any(matches_name(product, "co2e_upper")))
  expect_true(any(matches_name(company, "co2e_lower")))
  expect_true(any(matches_name(company, "co2e_upper")))
})

test_that("columns `co2e_lower` and `co2e_upper` give reproducible results after setting the seed", {
  companies <- read_csv(toy_emissions_profile_any_companies())
  co2 <- read_csv(toy_emissions_profile_upstream_products_ecoinvent())
  europages_companies <- read_csv(toy_europages_companies())
  ecoinvent_activities <- read_csv(toy_ecoinvent_activities())
  ecoinvent_inputs <- read_csv(toy_ecoinvent_inputs())
  ecoinvent_europages <- read_csv(toy_ecoinvent_europages())
  isic_name <- read_csv(toy_isic_name())

  local_seed(111)
  out_first <- profile_emissions_upstream(
    companies,
    co2,
    europages_companies = europages_companies,
    ecoinvent_activities = ecoinvent_activities,
    ecoinvent_inputs = ecoinvent_inputs,
    ecoinvent_europages = ecoinvent_europages,
    isic = isic_name
  )

  product_first <- unnest_product(out_first)
  company_first <- unnest_company(out_first)

  local_seed(111)
  out_second <- profile_emissions_upstream(
    companies,
    co2,
    europages_companies = europages_companies,
    ecoinvent_activities = ecoinvent_activities,
    ecoinvent_inputs = ecoinvent_inputs,
    ecoinvent_europages = ecoinvent_europages,
    isic = isic_name
  )

  product_second <- unnest_product(out_second)
  company_second <- unnest_company(out_second)

  expect_equal(product_first, product_second)
  expect_equal(company_first, company_second)
})

test_that("allows controlling the amount of noise", {
  companies <- read_csv(toy_emissions_profile_any_companies())
  co2 <- read_csv(toy_emissions_profile_upstream_products_ecoinvent())
  europages_companies <- read_csv(toy_europages_companies())
  ecoinvent_activities <- read_csv(toy_ecoinvent_activities())
  ecoinvent_inputs <- read_csv(toy_ecoinvent_inputs())
  ecoinvent_europages <- read_csv(toy_ecoinvent_europages())
  isic_name <- read_csv(toy_isic_name())

  local_seed(111)
  local_options(tiltIndicatorAfter.co2_jitter_amount = 0.1)
  out1 <- profile_emissions_upstream(
    companies,
    co2,
    europages_companies = europages_companies,
    ecoinvent_activities = ecoinvent_activities,
    ecoinvent_inputs = ecoinvent_inputs,
    ecoinvent_europages = ecoinvent_europages,
    isic = isic_name
  )

  local_seed(111)
  local_options(tiltIndicatorAfter.co2_jitter_amount = 0.9)
  out2 <- profile_emissions_upstream(
    companies,
    co2,
    europages_companies = europages_companies,
    ecoinvent_activities = ecoinvent_activities,
    ecoinvent_inputs = ecoinvent_inputs,
    ecoinvent_europages = ecoinvent_europages,
    isic = isic_name
  )

  expect_false(identical(out1, out2))
})

test_that("informs the mean noise percent", {
  local_seed(1)
  local_options(tiltIndicatorAfter.verbose = TRUE)
  local_options(tiltIndicatorAfter.co2_jitter_amount = 2)

  companies <- read_csv(toy_emissions_profile_any_companies())
  co2 <- read_csv(toy_emissions_profile_upstream_products_ecoinvent())
  europages_companies <- read_csv(toy_europages_companies())
  ecoinvent_activities <- read_csv(toy_ecoinvent_activities())
  ecoinvent_inputs <- read_csv(toy_ecoinvent_inputs())
  ecoinvent_europages <- read_csv(toy_ecoinvent_europages())
  isic_name <- read_csv(toy_isic_name())

  expect_snapshot(
    invisible <- profile_emissions_upstream(
      companies,
      co2,
      europages_companies = europages_companies,
      ecoinvent_activities = ecoinvent_activities,
      ecoinvent_inputs = ecoinvent_inputs,
      ecoinvent_europages = ecoinvent_europages,
      isic = isic_name
    )
  )
})

test_that("can optionally output `min` and `max`", {
  companies <- read_csv(toy_emissions_profile_any_companies())
  co2 <- read_csv(toy_emissions_profile_upstream_products_ecoinvent())
  europages_companies <- read_csv(toy_europages_companies())
  ecoinvent_activities <- read_csv(toy_ecoinvent_activities())
  ecoinvent_inputs <- read_csv(toy_ecoinvent_inputs())
  ecoinvent_europages <- read_csv(toy_ecoinvent_europages())
  isic_name <- read_csv(toy_isic_name())


  local_seed(111)
  local_options(tiltIndicatorAfter.co2_keep_licensed_min_max = TRUE)
  out <- profile_emissions_upstream(
    companies,
    co2,
    europages_companies = europages_companies,
    ecoinvent_activities = ecoinvent_activities,
    ecoinvent_inputs = ecoinvent_inputs,
    ecoinvent_europages = ecoinvent_europages,
    isic = isic_name
  )

  expect_true(hasName(unnest_product(out), "min"))
  expect_true(hasName(unnest_product(out), "max"))
  expect_true(hasName(unnest_company(out), "min"))
  expect_true(hasName(unnest_company(out), "max"))
})

test_that("outputs `profile_ranking_avg` at company level", {
  companies <- read_csv(toy_emissions_profile_any_companies())
  co2 <- read_csv(toy_emissions_profile_upstream_products_ecoinvent())
  europages_companies <- read_csv(toy_europages_companies())
  ecoinvent_activities <- read_csv(toy_ecoinvent_activities())
  ecoinvent_inputs <- read_csv(toy_ecoinvent_inputs())
  ecoinvent_europages <- read_csv(toy_ecoinvent_europages())
  isic_name <- read_csv(toy_isic_name())

  out <- profile_emissions_upstream(
    companies,
    co2,
    europages_companies = europages_companies,
    ecoinvent_activities = ecoinvent_activities,
    ecoinvent_inputs = ecoinvent_inputs,
    ecoinvent_europages = ecoinvent_europages,
    isic = isic_name
  )

  company <- unnest_company(out)
  expect_true(hasName(company, "profile_ranking_avg"))
})
