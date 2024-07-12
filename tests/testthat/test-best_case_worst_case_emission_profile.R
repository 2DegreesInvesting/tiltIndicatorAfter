test_that("Three `ep_products` with the same `benchmark` but with different `emission_profile` will have `best_case` only for the low `emission_profile` product and have `worst_case` only for the high `emission_profile` product", {
  example_data <- example_best_case_worst_case_emission_profile()
  out <- best_case_worst_case_emission_profile(example_data)

  only_one_best_case <- 1
  expect_equal(nrow(filter(out, best_case == 1)), only_one_best_case)

  only_one_worst_case <- 1
  expect_equal(nrow(filter(out, worst_case == 1)), only_one_worst_case)

  # Expected best case for "low" emission_profile
  expected_best_case <- 1
  expect_equal(filter(out, emission_profile == "low")$best_case, expected_best_case)

  # Expected worst case for "high" emission_profile
  expected_worst_case <- 1
  expect_equal(filter(out, emission_profile == "high")$worst_case, expected_worst_case)
})

test_that("`NA` in `emission_profile` gives `0` in `best_case` and `worst_case`", {
  example_data <- example_best_case_worst_case_emission_profile(
    emission_profile = c("low", "medium", NA_character_)
  )
  out <- best_case_worst_case_emission_profile(example_data)

  # Expected best case for NA in `emission_profile`
  expected_best_case <- 0
  expect_equal(filter(out, is.na(emission_profile))$best_case, expected_best_case)

  # Expected worst case for NA in `emission_profile`
  expected_worst_case <- 0
  expect_equal(filter(out, is.na(emission_profile))$worst_case, expected_worst_case)
})

test_that("gives `NA` in `equal_weight`, `best_case`, and `worst_case` if a company has missing `ep_product`", {
  example_data <- example_best_case_worst_case_emission_profile(
    emission_profile = NA_character_,
    ep_product = NA_character_
  )
  out <- best_case_worst_case_emission_profile(distinct(example_data))

  expect_true(is.na(out$equal_weight))
  expect_true(is.na(out$best_case))
  expect_true(is.na(out$worst_case))
})

test_that("if `emission_profile_at_product_level` lacks crucial columns, errors gracefully", {
  example_data <- example_best_case_worst_case_emission_profile()

  crucial <- col_companies_id()
  bad <- select(example_data, -all_of(crucial))
  expect_error(best_case_worst_case_emission_profile(bad), crucial)

  crucial <- col_europages_product()
  bad <- select(example_data, -all_of(crucial))
  expect_error(best_case_worst_case_emission_profile(bad), crucial)

  crucial <- col_emission_grouped_by()
  bad <- select(example_data, -all_of(crucial))
  expect_error(best_case_worst_case_emission_profile(bad), crucial)

  crucial <- col_emission_profile()
  bad <- select(example_data, -all_of(crucial))
  expect_error(best_case_worst_case_emission_profile(bad), crucial)
})

test_that("gives `NA` in `best_case` and `worst_case` if count of best and worst cases is `0`", {
  example_data <- example_best_case_worst_case_emission_profile(
    emission_profile = NA_character_,
    ep_product = NA_character_
  )

  out <- best_case_worst_case_emission_profile(distinct(example_data))

  # Expected best case for `0` in `count_best_case_products_per_company_benchmark`
  expected_best_case <- NA
  expect_equal(
    filter(out, count_best_case_products_per_company_benchmark == 0)$best_case,
    expected_best_case
  )

  # Expected best case for `0` in `count_best_case_products_per_company_benchmark`
  expected_worst_case <- NA
  expect_equal(
    filter(out, count_worst_case_products_per_company_benchmark == 0)$worst_case,
    expected_worst_case
  )
})

test_that("`equal_weight` does not count unmatched `ep_product` after grouping by `companies_id` and `benchmark`", {
  example_data <- example_best_case_worst_case_emission_profile(
    companies_id = c("any", "any", "any", "any", "any"),
    ep_product = c("one", "two", "three", "four", "five"),
    benchmark = c("all", "all", "all", "tilt_sector", NA_character_),
    emission_profile = c("low", "medium", NA_character_, "low", NA_character_)
  )

  out <- best_case_worst_case_emission_profile(example_data)

  out_all <- filter(out, benchmark == "all")
  expected_equal_weight_all <- 0.5
  expect_equal(unique(out_all$equal_weight), expected_equal_weight_all)

  out_tilt_sec <- filter(out, benchmark == "tilt_sector")
  expected_equal_weight_tilt_sec <- 1.0
  expect_equal(unique(out_tilt_sec$equal_weight), expected_equal_weight_tilt_sec)

  out_NA <- filter(out, is.na(benchmark))
  expected_equal_weight_NA <- NA_real_
  expect_equal(unique(out_NA$equal_weight), expected_equal_weight_NA)
})
