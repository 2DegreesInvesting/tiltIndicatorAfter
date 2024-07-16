test_that("`NA` in `sector_profile` and `reduction_targets` gives correct values for `avg_reduction_targets_best_case` and `avg_reduction_targets_worst_case`", {
  example_data <- example_best_case_worst_case_reduction_targets_product_level(
    sector_profile = c("low", "low", NA_character_),
    reduction_targets = c(1.0, 2.0, NA)
  )

  out <- create_avg_reduction_targets_best_case_worst_case_at_product_level(example_data)

  expected_best_case <- c(3 / 2, NA)
  expected_worst_case <- c(3 / 2, NA)
  expect_equal(unique(out$avg_reduction_targets_best_case), expected_best_case)
  expect_equal(unique(out$avg_reduction_targets_worst_case), expected_worst_case)
})

test_that("only `NA` in `sector_profile` and `reduction_targets` gives `NA` value for `avg_reduction_targets_best_case` and `avg_reduction_targets_worst_case`", {
  example_data <- example_best_case_worst_case_reduction_targets_product_level(
    sector_profile = NA_character_,
    reduction_targets = NA_character_
  )

  out <- create_avg_reduction_targets_best_case_worst_case_at_product_level(example_data)

  expected_best_case <- NA
  expected_worst_case <- NA
  expect_equal(unique(out$avg_reduction_targets_best_case), expected_best_case)
  expect_equal(unique(out$avg_reduction_targets_worst_case), expected_worst_case)
})


test_that("if `avg_profile_ranking_best_case_worst_case_at_product_level` lacks crucial columns, errors gracefully", {
  example_data <- example_best_case_worst_case_reduction_targets_product_level()

  crucial <- col_companies_id()
  bad <- select(example_data, -all_of(crucial))
  expect_error(
    create_avg_reduction_targets_best_case_worst_case_at_product_level(bad),
    crucial
  )

  crucial <- col_europages_product()
  bad <- select(example_data, -all_of(crucial))
  expect_error(
    create_avg_reduction_targets_best_case_worst_case_at_product_level(bad),
    crucial
  )

  crucial <- col_scenario()
  bad <- select(example_data, -all_of(crucial))
  expect_error(
    create_avg_reduction_targets_best_case_worst_case_at_product_level(bad),
    crucial
  )

  crucial <- col_year()
  bad <- select(example_data, -all_of(crucial))
  expect_error(
    create_avg_reduction_targets_best_case_worst_case_at_product_level(bad),
    crucial
  )

  crucial <- col_sector_profile()
  bad <- select(example_data, -all_of(crucial))
  expect_error(
    create_avg_reduction_targets_best_case_worst_case_at_product_level(bad),
    crucial
  )

  crucial <- "reduction_targets"
  bad <- select(example_data, -all_of(crucial))
  expect_error(
    create_avg_reduction_targets_best_case_worst_case_at_product_level(bad),
    crucial
  )
})
