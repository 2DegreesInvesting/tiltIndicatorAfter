test_that("Three `ep_products` with the same `benchmark` but with different
          `emission_profile` will have `best_case` only for the low `emission_profile`
          product and have `worst_case` only for the high `emission_profile` product", {
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

  # Expected best case for "high" emission_profile
  expected_worst_case <- 1
  expect_equal(filter(out, emission_profile == "high")$worst_case, expected_worst_case)
})
