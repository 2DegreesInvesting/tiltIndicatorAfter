test_that("Three `ep_products` with the same `benchmark` but with different `profile_ranking` will have `best_case` only for the lowest-ranked product and have `worst_case` only for the highest-ranked product", {
  example_data <- example_best_case_worst_case_profile_ranking_product_level()
  out <- best_case_worst_case_impl(example_data,
    col_group_by = col_emission_grouped_by(),
    col_risk = col_emission_profile(),
    col_rank = "profile_ranking"
  )

  only_one_best_case <- 1
  expect_equal(nrow(filter(out, best_case == 1.0)), only_one_best_case)

  only_one_worst_case <- 1
  expect_equal(nrow(filter(out, worst_case == 3.0)), only_one_worst_case)

  # Expected best case for lowest-ranked product
  expected_best_case <- 1
  expect_equal(filter(out, profile_ranking == 1.0)$best_case, expected_best_case)

  # Expected worst case for highest-ranked product
  expected_worst_case <- 3
  expect_equal(filter(out, profile_ranking == 3.0)$worst_case, expected_worst_case)
})

test_that("`NA` in `profile_ranking` for a single product gives `NA` in `best_case` and `worst_case` for that product", {
  example_data <- example_best_case_worst_case_profile_ranking_product_level(
    profile_ranking = c(1.0, 2.0, NA_real_)
  )
  out <- best_case_worst_case_impl(example_data,
    col_group_by = col_emission_grouped_by(),
    col_risk = col_emission_profile(),
    col_rank = "profile_ranking"
  )

  # Expected best case for NA in `profile_ranking`
  expected_best_case <- NA_real_
  expect_equal(filter(out, is.na(profile_ranking))$best_case, expected_best_case)

  # Expected worst case for NA in `profile_ranking`
  expected_worst_case <- NA_real_
  expect_equal(filter(out, is.na(profile_ranking))$worst_case, expected_worst_case)
})

test_that("`NA` in `profile_ranking` for all products gives `NA` in `best_case` and `worst_case` for all products", {
  example_data <- example_best_case_worst_case_profile_ranking_product_level(
    profile_ranking = c(NA_real_, NA_real_, NA_real_)
  )
  out <- best_case_worst_case_impl(example_data,
                                   col_group_by = col_emission_grouped_by(),
                                   col_risk = col_emission_profile(),
                                   col_rank = "profile_ranking"
  )

  # Expected best case for NA in `profile_ranking`
  expected_best_case <- NA_real_
  expect_equal(unique(filter(out, is.na(profile_ranking))$best_case), expected_best_case)

  # Expected worst case for NA in `profile_ranking`
  expected_worst_case <- NA_real_
  expect_equal(unique(filter(out, is.na(profile_ranking))$worst_case), expected_worst_case)
})

test_that("gives `NA` in `equal_weight` if a company has missing `ep_product`", {
  example_data <- example_best_case_worst_case_profile_ranking_product_level(
    emission_profile = NA_character_,
    ep_product = NA_character_
  )
  out <- best_case_worst_case_impl(example_data,
    col_group_by = col_emission_grouped_by(),
    col_risk = col_emission_profile(),
    col_rank = "profile_ranking"
  )

  expect_true(all(is.na(out$equal_weight)))
})

test_that("if input to `best_case_worst_case_impl` lacks crucial columns, errors gracefully", {
  example_data <- example_best_case_worst_case_profile_ranking_product_level()

  crucial <- col_companies_id()
  bad <- select(example_data, -all_of(crucial))
  expect_error(
    best_case_worst_case_impl(bad,
      col_group_by = col_emission_grouped_by(),
      col_risk = col_emission_profile(),
      col_rank = "profile_ranking"
    ),
    crucial
  )

  crucial <- col_europages_product()
  bad <- select(example_data, -all_of(crucial))
  expect_error(
    best_case_worst_case_impl(bad,
      col_group_by = col_emission_grouped_by(),
      col_risk = col_emission_profile(),
      col_rank = "profile_ranking"
    ),
    crucial
  )

  crucial <- col_emission_grouped_by()
  bad <- select(example_data, -all_of(crucial))
  expect_error(
    best_case_worst_case_impl(bad,
      col_group_by = col_emission_grouped_by(),
      col_risk = col_emission_profile(),
      col_rank = "profile_ranking"
    ),
    crucial
  )

  crucial <- col_emission_profile()
  bad <- select(example_data, -all_of(crucial))
  expect_error(
    best_case_worst_case_impl(bad,
      col_group_by = col_emission_grouped_by(),
      col_risk = col_emission_profile(),
      col_rank = "profile_ranking"
    ),
    crucial
  )
})

test_that("`equal_weight` does not count unmatched `ep_product` after grouping by `companies_id` and `benchmark`", {
  example_data <- example_best_case_worst_case_profile_ranking_product_level(
    companies_id = c("any", "any", "any", "any", "any"),
    ep_product = c("one", "two", "three", "four", "five"),
    benchmark = c("all", "all", "all", "tilt_sector", NA_character_),
    emission_profile = c("low", "medium", NA_character_, "low", NA_character_),
    profile_ranking = c(1.0, 2.0, 3.0, 4.0, 5.0)
  )

  out <- best_case_worst_case_impl(example_data,
    col_group_by = col_emission_grouped_by(),
    col_risk = col_emission_profile(),
    col_rank = "profile_ranking"
  )

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
