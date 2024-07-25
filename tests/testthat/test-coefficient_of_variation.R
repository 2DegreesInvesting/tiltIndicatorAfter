test_that("`add_coefficient_of_variation_transition_risk_company()` outputs correct `coefficient_of_variation_transition_risk`", {
  transition_risk_input <- tibble(
    avg_transition_risk_equal_weight = c(1, 2, 5, NA_real_),
    avg_transition_risk_best_case = c(1, 3, 7, NA_real_),
    avg_transition_risk_worst_case = c(1, 4, 9, NA_real_)
  )

  out <- add_coefficient_of_variation_transition_risk_impl(transition_risk_input)

  check_no_dispersion <- filter(out, avg_transition_risk_equal_weight == 1.0)
  expected_coefficient_of_variation <- 0
  expect_true(check_no_dispersion$coefficient_of_variation_transition_risk ==
    expected_coefficient_of_variation)

  check_na <- filter(out, is.na(avg_transition_risk_equal_weight))
  expect_true(is.na(check_na$coefficient_of_variation_transition_risk))
})
