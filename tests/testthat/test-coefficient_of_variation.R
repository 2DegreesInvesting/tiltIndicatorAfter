test_that("`add_coefficient_of_variation_transition_risk()` outputs correct `cov_transition_risk`", {
  transition_risk_input <- tibble(
    avg_transition_risk_equal_weight = c(1, 2, 5, NA_real_),
    avg_transition_risk_best_case = c(1, 3, 7, NA_real_),
    avg_transition_risk_worst_case = c(1, 4, 9, NA_real_)
  )

  out <- add_coefficient_of_variation_transition_risk(transition_risk_input)

  check_no_dispersion <- filter(out, avg_transition_risk_equal_weight == 1.0)
  expected_coefficient_of_variation <- 0
  expect_true(check_no_dispersion$cov_transition_risk ==
    expected_coefficient_of_variation)

  check_na <- filter(out, is.na(avg_transition_risk_equal_weight))
  expect_true(is.na(check_na$cov_transition_risk))
})

test_that("`add_coefficient_of_variation_emission_rank()` outputs correct `cov_emission_rank`", {
  emission_rank_input <- tibble(
    profile_ranking_avg = c(1, 2, 5, NA_real_),
    avg_profile_ranking_best_case = c(1, 3, 7, NA_real_),
    avg_profile_ranking_worst_case = c(1, 4, 9, NA_real_)
  )

  out <- add_coefficient_of_variation_emission_rank(emission_rank_input)

  check_no_dispersion <- filter(out, profile_ranking_avg == 1.0)
  expected_coefficient_of_variation <- 0
  expect_true(check_no_dispersion$cov_emission_rank ==
                expected_coefficient_of_variation)

  check_na <- filter(out, is.na(profile_ranking_avg))
  expect_true(is.na(check_na$cov_emission_rank))
})

test_that("`add_coefficient_of_variation_sector_target()` outputs correct `cov_sector_target`", {
  sector_target_input <- tibble(
    reduction_targets_avg = c(1, 2, 5, NA_real_),
    avg_reduction_targets_best_case = c(1, 3, 7, NA_real_),
    avg_reduction_targets_worst_case = c(1, 4, 9, NA_real_)
  )

  out <- add_coefficient_of_variation_sector_target(sector_target_input)

  check_no_dispersion <- filter(out, reduction_targets_avg == 1.0)
  expected_coefficient_of_variation <- 0
  expect_true(check_no_dispersion$cov_sector_target ==
                expected_coefficient_of_variation)

  check_na <- filter(out, is.na(reduction_targets_avg))
  expect_true(is.na(check_na$cov_sector_target))
})

test_that("`add_coefficient_of_variation_sector_target()` outputs NA `cov_sector_target` for zero mean", {
  sector_target_input <- tibble(
    reduction_targets_avg = -1,
    avg_reduction_targets_best_case = 1,
    avg_reduction_targets_worst_case = 0
  )
  out <- add_coefficient_of_variation_sector_target(sector_target_input)

  expect_true(is.na(out$cov_sector_target))
})

test_that("`add_coefficient_of_variation_emission_rank()` outputs NA `cov_emission_rank` for zero mean", {
  emission_rank_input <- tibble(
    profile_ranking_avg = -1,
    avg_profile_ranking_best_case = 1,
    avg_profile_ranking_worst_case = 0
  )
  out <- add_coefficient_of_variation_emission_rank(emission_rank_input)

  expect_true(is.na(out$cov_emission_rank))
})

test_that("`add_coefficient_of_variation_transition_risk()` outputs NA `cov_transition_risk` for zero mean", {
  transition_risk_input <- tibble(
    avg_transition_risk_equal_weight = -1,
    avg_transition_risk_best_case = 1,
    avg_transition_risk_worst_case = 0
  )
  out <- add_coefficient_of_variation_transition_risk(transition_risk_input)

  expect_true(is.na(out$cov_transition_risk))
})
