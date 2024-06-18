test_that("single `NA` in `transition_risk_category` gives correct values for `avg_transition_risk_best_case` and `avg_transition_risk_worst_case`", {
  example_data <- example_best_case_worst_case_transition_risk_profile_product_level(
    transition_risk_category = c("low", "low", NA_character_)
  )

  out <- create_avg_best_case_worst_case_at_product_level(example_data)

  expected_best_case <- 2 / 3
  expected_worst_case <- 2 / 3
  expect_equal(unique(out$avg_transition_risk_best_case), expected_best_case)
  expect_equal(unique(out$avg_transition_risk_worst_case), expected_worst_case)
})

test_that("only `NA` in `transition_risk_category` gives `0` value for `avg_transition_risk_best_case` and `avg_transition_risk_worst_case`", {
  example_data <- example_best_case_worst_case_transition_risk_profile_product_level(
    transition_risk_category = NA_character_
  )

  out <- create_avg_best_case_worst_case_at_product_level(example_data)

  expected_best_case <- 0
  expected_worst_case <- 0
  expect_equal(unique(out$avg_transition_risk_best_case), expected_best_case)
  expect_equal(unique(out$avg_transition_risk_worst_case), expected_worst_case)
})


test_that("if `transition_profile_at_product_level` lacks crucial columns, errors gracefully", {
  example_data <- example_best_case_worst_case_transition_risk_profile_product_level()

  crucial <- col_companies_id()
  bad <- select(example_data, -all_of(crucial))
  expect_error(create_avg_best_case_worst_case_at_product_level(bad), crucial)

  crucial <- col_europages_product()
  bad <- select(example_data, -all_of(crucial))
  expect_error(create_avg_best_case_worst_case_at_product_level(bad), crucial)

  crucial <- col_transition_risk_grouped_by()
  bad <- select(example_data, -all_of(crucial))
  expect_error(create_avg_best_case_worst_case_at_product_level(bad), crucial)

  crucial <- col_transition_risk_category()
  bad <- select(example_data, -all_of(crucial))
  expect_error(create_avg_best_case_worst_case_at_product_level(bad), crucial)

  crucial <- "amount_of_distinct_products"
  bad <- select(example_data, -all_of(crucial))
  expect_error(create_avg_best_case_worst_case_at_product_level(bad), crucial)
})
