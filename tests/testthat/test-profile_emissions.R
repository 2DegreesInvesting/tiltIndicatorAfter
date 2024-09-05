test_that("yields a 'tilt_profile'", {
  companies <- read_csv(toy_emissions_profile_any_companies())
  co2 <- read_csv(toy_emissions_profile_products_ecoinvent())
  europages_companies <- read_csv(toy_europages_companies())
  ecoinvent_activities <- read_csv(toy_ecoinvent_activities())
  ecoinvent_europages <- read_csv(toy_ecoinvent_europages())
  isic_name <- read_csv(toy_isic_name())

  out <- profile_emissions(
    companies,
    co2,
    europages_companies = europages_companies,
    ecoinvent_activities = ecoinvent_activities,
    ecoinvent_europages = ecoinvent_europages,
    isic = isic_name
  )

  expect_s3_class(out, "tilt_profile")
})

test_that("characterize columns", {
  companies <- read_csv(toy_emissions_profile_any_companies())
  co2 <- read_csv(toy_emissions_profile_products_ecoinvent())
  europages_companies <- read_csv(toy_europages_companies())
  ecoinvent_activities <- read_csv(toy_ecoinvent_activities())
  ecoinvent_europages <- read_csv(toy_ecoinvent_europages())
  isic_name <- read_csv(toy_isic_name())

  out <- profile_emissions(
    companies,
    co2,
    europages_companies = europages_companies,
    ecoinvent_activities = ecoinvent_activities,
    ecoinvent_europages = ecoinvent_europages,
    isic = isic_name
  )

  expect_snapshot(names(unnest_product(out)))

  expect_snapshot(names(unnest_company(out)))
})

test_that("the output at product level has columns matching isic and sector", {
  companies <- read_csv(toy_emissions_profile_any_companies())
  co2 <- read_csv(toy_emissions_profile_products_ecoinvent())
  europages_companies <- read_csv(toy_europages_companies())
  ecoinvent_activities <- read_csv(toy_ecoinvent_activities())
  ecoinvent_europages <- read_csv(toy_ecoinvent_europages())
  isic_name <- read_csv(toy_isic_name())

  out <- profile_emissions(
    companies,
    co2,
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
  skip_unless_toy_data_is_newer_than(toy_data_version())
  local_options(readr.show_col_types = FALSE)

  companies <- read_csv(toy_emissions_profile_any_companies())
  co2 <- read_csv(toy_emissions_profile_products_ecoinvent())
  co2$isic_4digit <- "1"

  europages_companies <- read_csv(toy_europages_companies())
  ecoinvent_activities <- read_csv(toy_ecoinvent_activities())
  ecoinvent_europages <- read_csv(toy_ecoinvent_europages())
  isic_name <- read_csv(toy_isic_name())

  out <- profile_emissions(
    companies,
    co2,
    europages_companies,
    ecoinvent_activities,
    ecoinvent_europages,
    isic_name
  )

  actual <- rm_na(unique(unnest_product(out)$isic_4digit))
  expect_equal(actual, "1")
})

test_that("`ei_geography` column is present at product level output", {
  companies <- read_csv(toy_emissions_profile_any_companies())
  co2 <- read_csv(toy_emissions_profile_products_ecoinvent())
  europages_companies <- read_csv(toy_europages_companies())
  ecoinvent_activities <- read_csv(toy_ecoinvent_activities())
  ecoinvent_europages <- read_csv(toy_ecoinvent_europages())
  isic_name <- read_csv(toy_isic_name())

  out <- profile_emissions(
    companies,
    co2,
    europages_companies,
    ecoinvent_activities,
    ecoinvent_europages,
    isic_name
  ) |> unnest_product()

  expect_true(all(c("ei_geography") %in% names(out)))
})

test_that("doesn't throw error: 'Column unit doesn't exist' (#26)", {
  companies <- read_csv(toy_emissions_profile_any_companies())
  co2 <- read_csv(toy_emissions_profile_products_ecoinvent())

  europages_companies <- read_csv(toy_europages_companies())
  ecoinvent_activities <- read_csv(toy_ecoinvent_activities())
  ecoinvent_europages <- read_csv(toy_ecoinvent_europages())
  isic_name <- read_csv(toy_isic_name())

  expect_no_error(
    profile_emissions(
      companies,
      co2,
      europages_companies = europages_companies,
      ecoinvent_activities = ecoinvent_activities,
      ecoinvent_europages = ecoinvent_europages,
      isic = isic_name
    )
  )
})

test_that("yields a single distinct value of `*matching_certainty_company_average` per company", {
  companies <- read_csv(toy_emissions_profile_any_companies())
  co2 <- read_csv(toy_emissions_profile_products_ecoinvent())
  europages_companies <- read_csv(toy_europages_companies())
  ecoinvent_activities <- read_csv(toy_ecoinvent_activities())
  ecoinvent_europages <- read_csv(toy_ecoinvent_europages())
  isic_name <- read_csv(toy_isic_name())

  product <- profile_emissions(
    companies,
    co2,
    europages_companies = europages_companies,
    ecoinvent_activities = ecoinvent_activities,
    ecoinvent_europages = ecoinvent_europages,
    isic = isic_name
  ) |>
    unnest_product()

  count <- product |>
    summarise(
      n_distinct_matching_certainity_per_company = n_distinct(matching_certainty_company_average),
      .by = companies_id
    )

  expect_equal(unique(count$n_distinct_matching_certainity_per_company), 1.0)
})

test_that("handles numeric `isic*` in `co2`", {
  companies <- read_csv(toy_emissions_profile_any_companies())
  co2 <- read_csv(toy_emissions_profile_products_ecoinvent())

  europages_companies <- read_csv(toy_europages_companies())
  ecoinvent_activities <- read_csv(toy_ecoinvent_activities())
  ecoinvent_europages <- read_csv(toy_ecoinvent_europages())
  isic_name <- read_csv(toy_isic_name())

  expect_no_error(
    profile_emissions(
      companies,
      co2 |> modify_col("isic", unquote) |> modify_col("isic", as.numeric),
      europages_companies = europages_companies,
      ecoinvent_activities = ecoinvent_activities,
      ecoinvent_europages = ecoinvent_europages,
      isic = isic_name
    )
  )
})

test_that("yields a single distinct value of `*matching_certainty_company_average` per company", {
  companies <- read_csv(toy_emissions_profile_any_companies())
  co2 <- read_csv(toy_emissions_profile_products_ecoinvent())
  europages_companies <- read_csv(toy_europages_companies())
  ecoinvent_activities <- read_csv(toy_ecoinvent_activities())
  ecoinvent_europages <- read_csv(toy_ecoinvent_europages())
  isic_name <- read_csv(toy_isic_name())

  company <- profile_emissions(
    companies,
    co2,
    europages_companies = europages_companies,
    ecoinvent_activities = ecoinvent_activities,
    ecoinvent_europages = ecoinvent_europages,
    isic = isic_name
  ) |>
    unnest_company()

  count <- company |>
    summarise(
      n_distinct_matching_certainity_per_company = n_distinct(matching_certainty_company_average),
      .by = companies_id
    )

  expect_equal(unique(count$n_distinct_matching_certainity_per_company), 1.0)
})

test_that("the output at product level has columns `co2e_lower` and `co2e_upper`", {
  companies <- read_csv(toy_emissions_profile_any_companies())
  co2 <- read_csv(toy_emissions_profile_products_ecoinvent())
  europages_companies <- read_csv(toy_europages_companies())
  ecoinvent_activities <- read_csv(toy_ecoinvent_activities())
  ecoinvent_europages <- read_csv(toy_ecoinvent_europages())
  isic_name <- read_csv(toy_isic_name())

  out <- profile_emissions(
    companies,
    co2,
    europages_companies,
    ecoinvent_activities,
    ecoinvent_europages,
    isic_name
  )

  product <- unnest_product(out)
  expect_true(any(matches_name(product, "co2e_lower")))
  expect_true(any(matches_name(product, "co2e_upper")))
})

test_that("the output at company level lacks columns `co2e_lower` and `co2e_upper` (#230)", {
  companies <- read_csv(toy_emissions_profile_any_companies())
  co2 <- read_csv(toy_emissions_profile_products_ecoinvent())
  europages_companies <- read_csv(toy_europages_companies())
  ecoinvent_activities <- read_csv(toy_ecoinvent_activities())
  ecoinvent_europages <- read_csv(toy_ecoinvent_europages())
  isic_name <- read_csv(toy_isic_name())

  out <- profile_emissions(
    companies,
    co2,
    europages_companies,
    ecoinvent_activities,
    ecoinvent_europages,
    isic_name
  )

  company <- unnest_company(out)
  expect_false(any(matches_name(company, "co2e_lower")))
  expect_false(any(matches_name(company, "co2e_upper")))
})

test_that("columns `co2e_lower` and `co2e_upper` give reproducible results after setting the seed", {
  companies <- read_csv(toy_emissions_profile_any_companies())
  co2 <- read_csv(toy_emissions_profile_products_ecoinvent())
  europages_companies <- read_csv(toy_europages_companies())
  ecoinvent_activities <- read_csv(toy_ecoinvent_activities())
  ecoinvent_europages <- read_csv(toy_ecoinvent_europages())
  isic_name <- read_csv(toy_isic_name())

  local_seed(111)
  out_first <- profile_emissions(
    companies,
    co2,
    europages_companies,
    ecoinvent_activities,
    ecoinvent_europages,
    isic_name
  )

  product_first <- unnest_product(out_first)
  company_first <- unnest_company(out_first)

  local_seed(111)
  out_second <- profile_emissions(
    companies,
    co2,
    europages_companies,
    ecoinvent_activities,
    ecoinvent_europages,
    isic_name
  )

  product_second <- unnest_product(out_second)
  company_second <- unnest_company(out_second)

  expect_equal(product_first, product_second)
  expect_equal(company_first, company_second)
})

test_that("allows controlling the amount of noise", {
  companies <- read_csv(toy_emissions_profile_any_companies())
  co2 <- read_csv(toy_emissions_profile_products_ecoinvent())
  europages_companies <- read_csv(toy_europages_companies())
  ecoinvent_activities <- read_csv(toy_ecoinvent_activities())
  ecoinvent_europages <- read_csv(toy_ecoinvent_europages())
  isic_name <- read_csv(toy_isic_name())

  local_seed(111)
  local_options(tiltIndicatorAfter.set_jitter_amount = 0.1)
  out1 <- profile_emissions(
    companies,
    co2,
    europages_companies,
    ecoinvent_activities,
    ecoinvent_europages,
    isic_name
  )

  local_seed(111)
  local_options(tiltIndicatorAfter.set_jitter_amount = 0.9)
  out2 <- profile_emissions(
    companies,
    co2,
    europages_companies,
    ecoinvent_activities,
    ecoinvent_europages,
    isic_name
  )

  expect_false(identical(out1, out2))
})

test_that("at product level, can optionally output `min` and `max` but not at company level", {
  companies <- read_csv(toy_emissions_profile_any_companies())
  co2 <- read_csv(toy_emissions_profile_products_ecoinvent())
  europages_companies <- read_csv(toy_europages_companies())
  ecoinvent_activities <- read_csv(toy_ecoinvent_activities())
  ecoinvent_europages <- read_csv(toy_ecoinvent_europages())
  isic_name <- read_csv(toy_isic_name())

  local_seed(111)
  local_options(tiltIndicatorAfter.output_co2_footprint_min_max = TRUE)
  out <- profile_emissions(
    companies,
    co2,
    europages_companies,
    ecoinvent_activities,
    ecoinvent_europages,
    isic_name
  )

  expect_true(hasName(unnest_product(out), "min"))
  expect_true(hasName(unnest_product(out), "max"))
  expect_false(hasName(unnest_company(out), "min"))
  expect_false(hasName(unnest_company(out), "max"))
})

test_that("at product level, can optionally output `co2_footprint` but not at company level", {
  companies <- read_csv(toy_emissions_profile_any_companies())
  co2 <- read_csv(toy_emissions_profile_products_ecoinvent())
  europages_companies <- read_csv(toy_europages_companies())
  ecoinvent_activities <- read_csv(toy_ecoinvent_activities())
  ecoinvent_europages <- read_csv(toy_ecoinvent_europages())
  isic_name <- read_csv(toy_isic_name())

  local_options(tiltIndicatorAfter.output_co2_footprint = TRUE)
  out <- profile_emissions(
    companies,
    co2,
    europages_companies,
    ecoinvent_activities,
    ecoinvent_europages,
    isic_name
  )

  expect_true(hasName(unnest_product(out), "co2_footprint"))
  expect_false(hasName(unnest_company(out), "co2_footprint"))
})

test_that("with some match preserves unmatched products (#193)", {
  companies <- read_csv(toy_emissions_profile_any_companies())
  id <- unique(companies$companies_id)[[1]]
  uuid <- unique(companies$activity_uuid_product_uuid)[[1]]
  companies <- companies |>
    filter(companies_id == id) |>
    filter(activity_uuid_product_uuid == uuid)
  companies <- bind_rows(companies, companies)
  companies[1, "activity_uuid_product_uuid"] <- "unmatched"

  co2 <- read_csv(toy_emissions_profile_products_ecoinvent()) |>
    filter(activity_uuid_product_uuid == uuid)

  europages_companies <- read_csv(toy_europages_companies()) |>
    filter(companies_id == id)

  ecoinvent_activities <- read_csv(toy_ecoinvent_activities()) |>
    filter(activity_uuid_product_uuid == uuid)

  ecoinvent_europages <- read_csv(toy_ecoinvent_europages()) |>
    filter(activity_uuid_product_uuid == uuid)

  isic_name <- read_csv(toy_isic_name()) |>
    filter(isic_4digit == co2$isic_4digit)

  out <- profile_emissions(
    companies,
    co2,
    europages_companies,
    ecoinvent_activities,
    ecoinvent_europages,
    isic_name
  )

  product <- unnest_product(out)
  expect_equal(unique(product$activity_uuid_product_uuid), c(uuid, "unmatched"))
})

test_that("with no match errors gracefully", {
  companies <- read_csv(toy_emissions_profile_any_companies()) |>
    filter(companies_id %in% dplyr::first(companies_id)) |>
    mutate(activity_uuid_product_uuid = "unmatched")
  co2 <- read_csv(toy_emissions_profile_products_ecoinvent())

  europages_companies <- read_csv(toy_europages_companies())
  ecoinvent_activities <- read_csv(toy_ecoinvent_activities())
  ecoinvent_europages <- read_csv(toy_ecoinvent_europages())
  isic_name <- read_csv(toy_isic_name())

  expect_error(profile_emissions(
    companies,
    co2,
    europages_companies,
    ecoinvent_activities,
    ecoinvent_europages,
    isic_name
  ), class = "all_benchmark_is_na")
})

test_that("at product level, preserves missing benchmarks (#153#issuecomment-2010043596)", {
  companies <- read_csv(toy_emissions_profile_any_companies())
  id <- unique(companies$companies_id)[[1]]
  uuid <- unique(companies$activity_uuid_product_uuid)[[1]]
  companies <- companies |>
    filter(companies_id == id) |>
    filter(activity_uuid_product_uuid == uuid)

  co2 <- read_csv(toy_emissions_profile_products_ecoinvent()) |>
    filter(activity_uuid_product_uuid == uuid)
  # Introduce a "missing benchmark"
  co2$isic_4digit <- NA

  europages_companies <- read_csv(toy_europages_companies()) |>
    filter(companies_id == id)
  ecoinvent_activities <- read_csv(toy_ecoinvent_activities()) |>
    filter(activity_uuid_product_uuid == uuid)
  ecoinvent_europages <- read_csv(toy_ecoinvent_europages()) |>
    filter(activity_uuid_product_uuid == uuid)
  isic_name <- read_csv(toy_isic_name()) |>
    filter(isic_4digit == co2$isic_4digit)

  out <- profile_emissions(
    companies,
    co2,
    europages_companies,
    ecoinvent_activities,
    ecoinvent_europages,
    isic_name
  )

  expect_true(any(grepl("isic", unnest_product(out)$benchmark)))
})

test_that("can optionally output `co2_avg` at company level", {
  companies <- read_csv(toy_emissions_profile_any_companies())
  co2 <- read_csv(toy_emissions_profile_products_ecoinvent())
  europages_companies <- read_csv(toy_europages_companies())
  ecoinvent_activities <- read_csv(toy_ecoinvent_activities())
  ecoinvent_europages <- read_csv(toy_ecoinvent_europages())
  isic_name <- read_csv(toy_isic_name())

  local_options(tiltIndicatorAfter.output_co2_footprint = TRUE)
  out <- profile_emissions(
    companies,
    co2,
    europages_companies,
    ecoinvent_activities,
    ecoinvent_europages,
    isic_name
  )

  expect_true(hasName(unnest_company(out), "co2_avg"))
})

test_that("outputs `profile_ranking_avg` at company level", {
  companies <- read_csv(toy_emissions_profile_any_companies())
  co2 <- read_csv(toy_emissions_profile_products_ecoinvent())
  europages_companies <- read_csv(toy_europages_companies())
  ecoinvent_activities <- read_csv(toy_ecoinvent_activities())
  ecoinvent_europages <- read_csv(toy_ecoinvent_europages())
  isic_name <- read_csv(toy_isic_name())

  out <- profile_emissions(
    companies,
    co2,
    europages_companies,
    ecoinvent_activities,
    ecoinvent_europages,
    isic_name
  )

  company <- unnest_company(out)
  expect_true(hasName(company, "profile_ranking_avg"))
})

test_that("`profile_ranking_avg` is calculated correctly for benchmark `all`", {
  companies <- read_csv(toy_emissions_profile_any_companies()) |>
    filter(companies_id %in% c("nonphilosophical_llama"))
  co2 <- read_csv(toy_emissions_profile_products_ecoinvent())
  europages_companies <- read_csv(toy_europages_companies())
  ecoinvent_activities <- read_csv(toy_ecoinvent_activities())
  ecoinvent_europages <- read_csv(toy_ecoinvent_europages())
  isic_name <- read_csv(toy_isic_name())

  out <- profile_emissions(
    companies,
    co2,
    europages_companies,
    ecoinvent_activities,
    ecoinvent_europages,
    isic_name
  )

  product <- unnest_product(out) |>
    filter(benchmark == "all")
  company <- unnest_company(out) |>
    filter(benchmark == "all")

  expected_value <- round(mean(product$profile_ranking, na.rm = TRUE), 4)
  expect_equal(round(unique(company$profile_ranking_avg), 4), expected_value)
})

test_that("if `*profile$` column has NA then `tilt_sector` and `tilt_subsector` should always have NA", {
  companies <- read_csv(toy_emissions_profile_any_companies())
  id <- unique(companies$companies_id)[[1]]
  uuid <- unique(companies$activity_uuid_product_uuid)[[1]]
  companies <- companies |>
    filter(companies_id == id) |>
    filter(activity_uuid_product_uuid == uuid)
  companies <- bind_rows(companies, companies)
  companies[1, "activity_uuid_product_uuid"] <- "unmatched"

  co2 <- read_csv(toy_emissions_profile_products_ecoinvent()) |>
    filter(activity_uuid_product_uuid == uuid)

  europages_companies <- read_csv(toy_europages_companies()) |>
    filter(companies_id == id)

  ecoinvent_activities <- read_csv(toy_ecoinvent_activities()) |>
    filter(activity_uuid_product_uuid == uuid)

  ecoinvent_europages <- read_csv(toy_ecoinvent_europages()) |>
    filter(activity_uuid_product_uuid == uuid)

  isic_name <- read_csv(toy_isic_name()) |>
    filter(isic_4digit == co2$isic_4digit)

  out <- profile_emissions(
    companies,
    co2,
    europages_companies,
    ecoinvent_activities,
    ecoinvent_europages,
    isic_name
  )

  product <- unnest_product(out)
  where_risk_category_is_na <- product |>
    filter(is.na(get_column(product, "profile$")))

  tilt_sector <- where_risk_category_is_na |> get_column("tilt_sector")
  expect_true(all(is.na(tilt_sector)))

  tilt_subsector <- where_risk_category_is_na |> get_column("tilt_subsector")
  expect_true(all(is.na(tilt_subsector)))
})

test_that("the output at product level has columns matching `amount_of_distinct_products`, `equal_weight`, `best_case`, and `worst_case`", {
  companies <- read_csv(toy_emissions_profile_any_companies())
  co2 <- read_csv(toy_emissions_profile_products_ecoinvent())
  europages_companies <- read_csv(toy_europages_companies())
  ecoinvent_activities <- read_csv(toy_ecoinvent_activities())
  ecoinvent_europages <- read_csv(toy_ecoinvent_europages())
  isic_name <- read_csv(toy_isic_name())
  out <- profile_emissions(
    companies,
    co2,
    europages_companies = europages_companies,
    ecoinvent_activities = ecoinvent_activities,
    ecoinvent_europages = ecoinvent_europages,
    isic = isic_name
  ) |>
    unnest_product()

  expect_true(any(matches_name(out, "amount_of_distinct_products")))
  expect_true(any(matches_name(out, "equal_weight")))
  expect_true(any(matches_name(out, "best_case")))
  expect_true(any(matches_name(out, "worst_case")))
})
