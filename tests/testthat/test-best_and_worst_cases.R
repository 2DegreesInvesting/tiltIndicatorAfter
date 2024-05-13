test_that("Three `ep_products` with the same `benchmark` but with different `emission_profile` will have `best_case` only for the low `emission_profile` product and have `worst_case` only for the high `emission_profile` product", {
  emission_profile_at_product_level_sample <- tibble::tibble(
    companies_id = "any",
    ep_product = c("one", "two", "three"),
    benchmark = "all",
    emission_profile = c("low", "medium", "high")
  )

  out <- best_and_worst_cases(emission_profile_at_product_level_sample)

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
  emission_profile_at_product_level_sample <- tibble::tibble(
    companies_id = "any",
    ep_product = c("one", "two", "three"),
    benchmark = "all",
    emission_profile = c("low", "medium", NA_character_)
  )

  out <- best_and_worst_cases(emission_profile_at_product_level_sample)

  # Expected best case for NA in `emission_profile`
  expected_best_case <- 0
  expect_equal(filter(out, is.na(emission_profile))$best_case, expected_best_case)

  # Expected worst case for NA in `emission_profile`
  expected_worst_case <- 0
  expect_equal(filter(out, is.na(emission_profile))$worst_case, expected_worst_case)
})

test_that("gives `NA` in `equal_weight`, `best_case`, and `worst_case` if a company has missing `ep_product`", {
  emission_profile_at_product_level_sample <- tibble::tibble(
    companies_id = "any",
    ep_product = NA_character_,
    benchmark = "all",
    emission_profile = NA_character_
  )

  out <- best_and_worst_cases(emission_profile_at_product_level_sample)

  expect_true(is.na(out$equal_weight))
  expect_true(is.na(out$best_case))
  expect_true(is.na(out$worst_case))
})

test_that("if `emission_profile_at_product_level` lacks crucial columns, errors gracefully", {
  emission_profile_at_product_level_sample <- tibble::tibble(
    companies_id = "any",
    ep_product = c("one", "two", "three"),
    benchmark = "all",
    emission_profile = c("low", "medium", "high")
  )

  crucial <- c("companies_id")
  bad <- select(emission_profile_at_product_level_sample, -all_of(crucial))
  expect_error(best_and_worst_cases(bad), crucial)

  crucial <- c("ep_product")
  bad <- select(emission_profile_at_product_level_sample, -all_of(crucial))
  expect_error(best_and_worst_cases(bad), crucial)

  crucial <- c("benchmark")
  bad <- select(emission_profile_at_product_level_sample, -all_of(crucial))
  expect_error(best_and_worst_cases(bad), crucial)

  crucial <- c("emission_profile")
  bad <- select(emission_profile_at_product_level_sample, -all_of(crucial))
  expect_error(best_and_worst_cases(bad), crucial)
})
