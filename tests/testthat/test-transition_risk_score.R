test_that("`transition_risk_score` and `benchmark_tr_score` has NA due to
          NA in either column `profile_ranking` or `reduction_targets`", {
  emissions_profile_at_product_level <- example_emissions_profile_at_product_level() |>
    filter(companies_id %in% c("antimonarchy_canine", "nonphilosophical_llama"))
  sector_profile_at_product_level <- example_sector_profile_at_product_level() |>
    filter(companies_id %in% c("celestial_lovebird", "nonphilosophical_llama"))

  out <- transition_risk_score(emissions_profile_at_product_level, sector_profile_at_product_level) |>
    unnest_product()

  tr_score_na <- out |>
    filter(is.na(transition_risk_score))

  benchmark_tr_score_na <- out |>
    filter(is.na(benchmark_tr_score))

  ranking_reduction_na <- out |>
    filter(is.na(profile_ranking) | is.na(reduction_targets))

  expect_equal(tr_score_na, ranking_reduction_na)
  expect_equal(benchmark_tr_score_na, ranking_reduction_na)
})
