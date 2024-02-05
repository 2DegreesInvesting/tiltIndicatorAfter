test_that("`transition_risk_score` and `benchmark_tr_score` has NA due to
          NA in either column `profile_ranking` or `reduction_targets`", {
  local_options(readr.show_col_types = FALSE)
  toy_emissions_profile_products_ecoinvent <- read_csv(toy_emissions_profile_products_ecoinvent())
  toy_emissions_profile_any_companies <- read_csv(toy_emissions_profile_any_companies())
  toy_sector_profile_any_scenarios <- read_csv(toy_sector_profile_any_scenarios())
  toy_sector_profile_companies <- read_csv(toy_sector_profile_companies())
  toy_europages_companies <- read_csv(toy_europages_companies())
  toy_ecoinvent_activities <- read_csv(toy_ecoinvent_activities())
  toy_ecoinvent_europages <- read_csv(toy_ecoinvent_europages())
  toy_ecoinvent_inputs <- read_csv(toy_ecoinvent_inputs())
  toy_isic_name <- read_csv(toy_isic_name())

  emissions_profile_at_product_level <- profile_emissions(
    companies = toy_emissions_profile_any_companies,
    co2 = toy_emissions_profile_products_ecoinvent,
    europages_companies = toy_europages_companies,
    ecoinvent_activities = toy_ecoinvent_activities,
    ecoinvent_europages = toy_ecoinvent_europages,
    isic = toy_isic_name
  ) |>
    unnest_product() |>
    filter(companies_id %in% c("antimonarchy_canine", "nonphilosophical_llama"))

  sector_profile_at_product_level <- profile_sector(
    companies = toy_sector_profile_companies,
    scenarios = toy_sector_profile_any_scenarios,
    europages_companies = toy_europages_companies,
    ecoinvent_activities = toy_ecoinvent_activities,
    ecoinvent_europages = toy_ecoinvent_europages,
    isic = toy_isic_name
  ) |>
    unnest_product()|>
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
