test_that("`NA` in `emission_profile` and `profile_ranking` gives correct values for `avg_profile_ranking_best_case` and `avg_profile_ranking_worst_case`", {
  example_data <- example_best_case_worst_case_profile_ranking_product_level(
    emission_profile = c("low", "low", NA_character_),
    profile_ranking = c(1.0, 2.0, NA)
  )

  out <- create_avg_profile_ranking_best_case_worst_case_at_product_level(example_data)

  expected_best_case <- c(3 / 2, NA)
  expected_worst_case <- c(3 / 2, NA)
  expect_equal(unique(out$avg_profile_ranking_best_case), expected_best_case)
  expect_equal(unique(out$avg_profile_ranking_worst_case), expected_worst_case)
})

test_that("only `NA` in `emission_profile` and `profile_ranking` gives `NA` value for `avg_profile_ranking_best_case` and `avg_profile_ranking_worst_case`", {
  example_data <- example_best_case_worst_case_profile_ranking_product_level(
    emission_profile = NA_character_,
    profile_ranking = NA_character_
  )

  out <- create_avg_profile_ranking_best_case_worst_case_at_product_level(example_data)

  expected_best_case <- NA
  expected_worst_case <- NA
  expect_equal(unique(out$avg_profile_ranking_best_case), expected_best_case)
  expect_equal(unique(out$avg_profile_ranking_worst_case), expected_worst_case)
})


test_that("if `avg_profile_ranking_best_case_worst_case_at_product_level` lacks crucial columns, errors gracefully", {
  example_data <- example_best_case_worst_case_profile_ranking_product_level()

  crucial <- col_companies_id()
  bad <- select(example_data, -all_of(crucial))
  expect_error(
    create_avg_profile_ranking_best_case_worst_case_at_product_level(bad),
    crucial
  )

  crucial <- col_europages_product()
  bad <- select(example_data, -all_of(crucial))
  expect_error(
    create_avg_profile_ranking_best_case_worst_case_at_product_level(bad),
    crucial
  )

  crucial <- col_emission_grouped_by()
  bad <- select(example_data, -all_of(crucial))
  expect_error(
    create_avg_profile_ranking_best_case_worst_case_at_product_level(bad),
    crucial
  )

  crucial <- col_emission_profile()
  bad <- select(example_data, -all_of(crucial))
  expect_error(
    create_avg_profile_ranking_best_case_worst_case_at_product_level(bad),
    crucial
  )

  crucial <- "profile_ranking"
  bad <- select(example_data, -all_of(crucial))
  expect_error(
    create_avg_profile_ranking_best_case_worst_case_at_product_level(bad),
    crucial
  )
})
