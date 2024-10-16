test_that("Three `ep_products` with the same `scenario_year` but with different `reduction_targets` will have `best_case` only for the lowest-target product and have `worst_case` only for the highest-target product", {
  example_data <- example_best_case_worst_case_reduction_targets_product_level()
  out <- best_case_worst_case_impl(example_data,
    col_group_by = "scenario_year",
    col_risk = "sector_profile",
    col_rank = "reduction_targets"
  )

  only_one_best_case <- 1
  expect_equal(nrow(filter(out, best_case == 1.0)), only_one_best_case)

  only_one_worst_case <- 1
  expect_equal(nrow(filter(out, worst_case == 3.0)), only_one_worst_case)

  # Expected best case for lowest-target product
  expected_best_case <- 1
  expect_equal(filter(out, reduction_targets == 1.0)$best_case, expected_best_case)

  # Expected worst case for highest-target product
  expected_worst_case <- 3
  expect_equal(filter(out, reduction_targets == 3.0)$worst_case, expected_worst_case)
})

test_that("`NA` in `reduction_targets` for a single product gives `NA` in `best_case` and `worst_case` for that product", {
  example_data <- example_best_case_worst_case_reduction_targets_product_level(
    reduction_targets = c(1.0, 2.0, NA_real_)
  )
  out <- best_case_worst_case_impl(example_data,
    col_group_by = "scenario_year",
    col_risk = "sector_profile",
    col_rank = "reduction_targets"
  )

  # Expected best case for NA in `reduction_targets`
  expected_best_case <- NA_real_
  expect_equal(filter(out, is.na(reduction_targets))$best_case, expected_best_case)

  # Expected worst case for NA in `reduction_targets`
  expected_worst_case <- NA_real_
  expect_equal(filter(out, is.na(reduction_targets))$worst_case, expected_worst_case)
})

test_that("`NA` in `reduction_targets` for all products gives `NA` in `best_case` and `worst_case` for all products", {
  example_data <- example_best_case_worst_case_reduction_targets_product_level(
    reduction_targets = c(NA_real_, NA_real_, NA_real_)
  )
  out <- best_case_worst_case_impl(example_data,
    col_group_by = "scenario_year",
    col_risk = "sector_profile",
    col_rank = "reduction_targets"
  )

  # Expected best case for NA in `reduction_targets`
  expected_best_case <- NA_real_
  expect_equal(unique(filter(out, is.na(reduction_targets))$best_case), expected_best_case)

  # Expected worst case for NA in `reduction_targets`
  expected_worst_case <- NA_real_
  expect_equal(unique(filter(out, is.na(reduction_targets))$worst_case), expected_worst_case)
})

test_that("gives `NA` in `equal_weight` if a company has missing `ep_product`", {
  example_data <- example_best_case_worst_case_reduction_targets_product_level(
    sector_profile = NA_character_,
    ep_product = NA_character_
  )
  out <- best_case_worst_case_impl(example_data,
    col_group_by = "scenario_year",
    col_risk = "sector_profile",
    col_rank = "reduction_targets"
  )

  expect_true(all(is.na(out$equal_weight)))
})

test_that("if input to `best_case_worst_case_impl` lacks crucial columns, errors gracefully", {
  example_data <- example_best_case_worst_case_reduction_targets_product_level()

  crucial <- col_companies_id()
  bad <- select(example_data, -all_of(crucial))
  expect_error(
    best_case_worst_case_impl(bad,
      col_group_by = "scenario_year",
      col_risk = "sector_profile",
      col_rank = "reduction_targets"
    ),
    crucial
  )

  crucial <- col_europages_product()
  bad <- select(example_data, -all_of(crucial))
  expect_error(
    best_case_worst_case_impl(bad,
      col_group_by = "scenario_year",
      col_risk = "sector_profile",
      col_rank = "reduction_targets"
    ),
    crucial
  )

  crucial <- "scenario_year"
  bad <- select(example_data, -all_of(crucial))
  expect_error(
    best_case_worst_case_impl(bad,
      col_group_by = "scenario_year",
      col_risk = "sector_profile",
      col_rank = "reduction_targets"
    ),
    crucial
  )

  crucial <- col_sector_profile()
  bad <- select(example_data, -all_of(crucial))
  expect_error(
    best_case_worst_case_impl(bad,
      col_group_by = "scenario_year",
      col_risk = "sector_profile",
      col_rank = "reduction_targets"
    ),
    crucial
  )
})

test_that("`equal_weight` does not count unmatched `ep_product` after grouping by `companies_id` and `benchmark`", {
  example_data <- example_best_case_worst_case_reduction_targets_product_level(
    companies_id = c("any", "any", "any", "any", "any"),
    ep_product = c("one", "two", "three", "four", "five"),
    scenario_year = c("1.5C RPS_2030", "1.5C RPS_2030", "1.5C RPS_2030", "1.5C RPS_2050", NA_character_),
    sector_profile = c("low", "medium", NA_character_, "low", NA_character_),
    reduction_targets = c(1.0, 2.0, 3.0, 4.0, 5.0)
  )

  out <- best_case_worst_case_impl(example_data,
    col_group_by = "scenario_year",
    col_risk = "sector_profile",
    col_rank = "reduction_targets"
  )

  out_1.5C_RPS_2030 <- filter(out, scenario_year == "1.5C RPS_2030")
  expected_equal_weight_1.5C_RPS_2030 <- 0.5
  expect_equal(unique(out_1.5C_RPS_2030$equal_weight), expected_equal_weight_1.5C_RPS_2030)

  out_1.5C_RPS_2050 <- filter(out, scenario_year == "1.5C RPS_2050")
  expected_equal_weight_1.5C_RPS_2050 <- 1.0
  expect_equal(unique(out_1.5C_RPS_2050$equal_weight), expected_equal_weight_1.5C_RPS_2050)

  out_NA <- filter(out, is.na(scenario_year))
  expected_equal_weight_NA <- NA_real_
  expect_equal(unique(out_NA$equal_weight), expected_equal_weight_NA)
})
