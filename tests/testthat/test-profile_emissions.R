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
  withr::local_options(tiltIndicatorAfter.output_co2_footprint = TRUE)

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

  out <- profile_emissions_impl(
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

  out <- profile_emissions_impl(
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

  out <- profile_emissions_impl(
    companies,
    co2,
    europages_companies,
    ecoinvent_activities,
    ecoinvent_europages,
    isic_name
  ) |> unnest_product()

  expect_true(all(c("ei_geography") %in% names(out)))
})

test_that("total number of rows for a comapny is either 1 or 6", {
  companies <- read_csv(toy_emissions_profile_any_companies())
  co2 <- read_csv(toy_emissions_profile_products_ecoinvent())

  europages_companies <- read_csv(toy_europages_companies())
  ecoinvent_activities <- read_csv(toy_ecoinvent_activities())
  ecoinvent_europages <- read_csv(toy_ecoinvent_europages())
  isic_name <- read_csv(toy_isic_name())

  out <- profile_emissions_impl(
    companies,
    co2,
    europages_companies = europages_companies,
    ecoinvent_activities = ecoinvent_activities,
    ecoinvent_europages = ecoinvent_europages,
    isic = isic_name
  ) |>
    unnest_product() |>
    group_by(companies_id, ep_product, activity_uuid_product_uuid) |>
    summarise(count = n())
  expect_true(all(unique(out$count) %in% c(1, 6)))
})

test_that("doesn't throw error: 'Column unit doesn't exist' (#26)", {
  companies <- read_csv(toy_emissions_profile_any_companies())
  co2 <- read_csv(toy_emissions_profile_products_ecoinvent())

  europages_companies <- read_csv(toy_europages_companies())
  ecoinvent_activities <- read_csv(toy_ecoinvent_activities())
  ecoinvent_europages <- read_csv(toy_ecoinvent_europages())
  isic_name <- read_csv(toy_isic_name())

  expect_no_error(
    profile_emissions_impl(
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

  product <- profile_emissions_impl(
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

test_that("total number of rows for a comapny is either 1 or 4", {
  skip_unless_tilt_indicator_is_newer_than("0.0.0.9206")

  companies <- read_csv(toy_emissions_profile_any_companies())
  co2 <- read_csv(toy_emissions_profile_products_ecoinvent())
  europages_companies <- read_csv(toy_europages_companies())
  ecoinvent_activities <- read_csv(toy_ecoinvent_activities())
  ecoinvent_europages <- read_csv(toy_ecoinvent_europages())
  isic_name <- read_csv(toy_isic_name())

  out <- profile_emissions_impl(
    companies,
    co2,
    europages_companies = europages_companies,
    ecoinvent_activities = ecoinvent_activities,
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
  co2 <- read_csv(toy_emissions_profile_products_ecoinvent())

  europages_companies <- read_csv(toy_europages_companies())
  ecoinvent_activities <- read_csv(toy_ecoinvent_activities())
  ecoinvent_europages <- read_csv(toy_ecoinvent_europages())
  isic_name <- read_csv(toy_isic_name())

  expect_no_error(
    profile_emissions_impl(
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

  company <- profile_emissions_impl(
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

test_that("the output at product and company level has columns `co2e_lower` and `co2e_upper`", {
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
  company <- unnest_company(out)
  expect_true(any(matches_name(product, "co2e_lower")))
  expect_true(any(matches_name(product, "co2e_upper")))
  expect_true(any(matches_name(company, "co2e_lower")))
  expect_true(any(matches_name(company, "co2e_upper")))
})

test_that("columns `co2e_lower` and `co2e_upper` give reproducible results after setting the seed", {
  companies <- read_csv(toy_emissions_profile_any_companies())
  co2 <- read_csv(toy_emissions_profile_products_ecoinvent())
  europages_companies <- read_csv(toy_europages_companies())
  ecoinvent_activities <- read_csv(toy_ecoinvent_activities())
  ecoinvent_europages <- read_csv(toy_ecoinvent_europages())
  isic_name <- read_csv(toy_isic_name())

  local_seed(111)
  out_first <- profile_emissions_impl(
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
  out_second <- profile_emissions_impl(
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
  local_options(tiltIndicatorAfter.get_jitter_amount = 0.1)
  out1 <- profile_emissions(
    companies,
    co2,
    europages_companies,
    ecoinvent_activities,
    ecoinvent_europages,
    isic_name
  )

  local_seed(111)
  local_options(tiltIndicatorAfter.get_jitter_amount = 0.9)
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

test_that("informs the mean noise percent", {
  local_seed(1)
  local_options(tiltIndicatorAfter.verbose = TRUE)
  local_options(tiltIndicatorAfter.get_jitter_amount = 2)

  companies <- read_csv(toy_emissions_profile_any_companies())
  co2 <- read_csv(toy_emissions_profile_products_ecoinvent())
  europages_companies <- read_csv(toy_europages_companies())
  ecoinvent_activities <- read_csv(toy_ecoinvent_activities())
  ecoinvent_europages <- read_csv(toy_ecoinvent_europages())
  isic_name <- read_csv(toy_isic_name())

  expect_snapshot(
    invisible <- profile_emissions(
      companies,
      co2,
      europages_companies,
      ecoinvent_activities,
      ecoinvent_europages,
      isic_name
    )
  )
})

test_that("can optionally output `min` and `max`", {
  companies <- read_csv(toy_emissions_profile_any_companies())
  co2 <- read_csv(toy_emissions_profile_products_ecoinvent())
  europages_companies <- read_csv(toy_europages_companies())
  ecoinvent_activities <- read_csv(toy_ecoinvent_activities())
  ecoinvent_europages <- read_csv(toy_ecoinvent_europages())
  isic_name <- read_csv(toy_isic_name())

  local_seed(111)
  local_options(tiltIndicatorAfter.output_co2_footprint_min_max = TRUE)
  out <- profile_emissions_impl(
    companies,
    co2,
    europages_companies,
    ecoinvent_activities,
    ecoinvent_europages,
    isic_name
  )

  expect_true(hasName(unnest_product(out), "min"))
  expect_true(hasName(unnest_product(out), "max"))
  expect_true(hasName(unnest_company(out), "min"))
  expect_true(hasName(unnest_company(out), "max"))
})

test_that("can optionally output `co2_footprint` at product level", {
  companies <- read_csv(toy_emissions_profile_any_companies())
  co2 <- read_csv(toy_emissions_profile_products_ecoinvent())
  europages_companies <- read_csv(toy_europages_companies())
  ecoinvent_activities <- read_csv(toy_ecoinvent_activities())
  ecoinvent_europages <- read_csv(toy_ecoinvent_europages())
  isic_name <- read_csv(toy_isic_name())

  local_options(tiltIndicatorAfter.output_co2_footprint = TRUE)
  out <- profile_emissions_impl(
    companies,
    co2,
    europages_companies,
    ecoinvent_activities,
    ecoinvent_europages,
    isic_name
  )

  expect_true(hasName(unnest_product(out), "co2_footprint"))
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

  out <- profile_emissions_impl(
    companies,
    co2,
    europages_companies,
    ecoinvent_activities,
    ecoinvent_europages,
    isic_name
  )

  product <- unnest_product(out)
  expect_equal(unique(product$activity_uuid_product_uuid), c("unmatched", uuid))
})

test_that("with no match preserves unmatched products (#193)", {
  companies <- read_csv(toy_emissions_profile_any_companies()) |>
    filter(companies_id %in% dplyr::first(companies_id)) |>
    mutate(activity_uuid_product_uuid = "unmatched")
  co2 <- read_csv(toy_emissions_profile_products_ecoinvent())

  europages_companies <- read_csv(toy_europages_companies())
  ecoinvent_activities <- read_csv(toy_ecoinvent_activities())
  ecoinvent_europages <- read_csv(toy_ecoinvent_europages())
  isic_name <- read_csv(toy_isic_name())

  out <- profile_emissions_impl(
    companies,
    co2,
    europages_companies,
    ecoinvent_activities,
    ecoinvent_europages,
    isic_name
  )

  expect_equal(out$companies_id, unique(companies$companies_id))

  product <- unnest_product(out)
  expect_true("unmatched" %in% product$activity_uuid_product_uuid)
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

  out <- profile_emissions_impl(
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
  out <- profile_emissions_impl(
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

  out <- profile_emissions_impl(
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

  out <- profile_emissions_impl(
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

  expected_value <- round(mean(product$profile_ranking, na.rm = TRUE), 3)
  expect_equal(unique(company$profile_ranking_avg), expected_value)
})

test_that("yield NA in `*tilt_sector` and `*tilt_subsector` in *profile$ risk column", {
  withr::local_options()
  companies <- read_csv(toy_emissions_profile_any_companies()) |>
    filter(companies_id %in% c("nonphilosophical_llama"))
  co2 <- read_csv(toy_emissions_profile_products_ecoinvent()) |>
    filter(activity_uuid_product_uuid == "bf94b5a7-b7a2-46d1-bb95-84bc560b12fb")

  europages_companies <- read_csv(toy_europages_companies())
  ecoinvent_activities <- read_csv(toy_ecoinvent_activities())
  ecoinvent_europages <- read_csv(toy_ecoinvent_europages())
  isic_name <- read_csv(toy_isic_name())

  result <- profile_emissions_impl(
    companies,
    co2,
    europages_companies,
    ecoinvent_activities,
    ecoinvent_europages,
    isic_name
  ) |>
    unnest_product() |>
    suppressWarnings()

  na <- filter(result, is.na(get_column(result, "profile$")))
  these_cols_are_full_of_na <- all(is.na(select(na, tilt_sector, tilt_subsector)))
  expect_true(these_cols_are_full_of_na)
})

test_that("informs a useful percent noise (not 'Adding NA% ... noise') (#188)", {
  withr::local_options(tiltIndicatorAfter.verbose = TRUE)

  companies <- read_csv(toy_emissions_profile_any_companies(), n_max = 1)
  companies <- bind_rows(companies, companies)
  companies$activity_uuid_product_uuid[[1]] <- "unmatched"
  uuid <- unique(companies$activity_uuid_product_uuid)
  products <- read_csv(toy_emissions_profile_products_ecoinvent()) |>
    filter(activity_uuid_product_uuid %in% uuid)

  europages_companies <- read_csv(toy_europages_companies())
  ecoinvent_activities <- read_csv(toy_ecoinvent_activities())
  ecoinvent_europages <- read_csv(toy_ecoinvent_europages())
  isic_name <- read_csv(toy_isic_name())

  withr::local_seed(1)
  # Before this fix the message was "NA% and NA%"
  expect_snapshot(
    profile_emissions_impl(
      companies,
      products,
      europages_companies = europages_companies,
      ecoinvent_activities = ecoinvent_activities,
      ecoinvent_europages = ecoinvent_europages,
      isic = isic_name
    )
  )
})
