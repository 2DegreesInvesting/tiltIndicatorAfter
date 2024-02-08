test_that("outputs expected columns at product level", {
  emissions_profile_at_product_level <-
    example_emissions_profile_at_product_level() |>
    filter(companies_id == "antimonarchy_canine")
  sector_profile_at_product_level <-
    example_sector_profile_at_product_level() |>
    filter(companies_id == "antimonarchy_canine")

  out <-
    score_transition_risk(emissions_profile_at_product_level,
                          sector_profile_at_product_level) |>
    unnest_product()

  expect_equal(sort(names(out)), sort(trs_product_output_columns()))
})

test_that("outputs expected columns at company level", {
  emissions_profile_at_product_level <-
    example_emissions_profile_at_product_level() |>
    filter(companies_id == "antimonarchy_canine")
  sector_profile_at_product_level <-
    example_sector_profile_at_product_level() |>
    filter(companies_id == "antimonarchy_canine")

  out <-
    score_transition_risk(emissions_profile_at_product_level,
                          sector_profile_at_product_level) |>
    unnest_company()

  expect_equal(sort(names(out)), sort(trs_company_output_columns()))
})


test_that(
  "`transition_risk_score` and `benchmark_tr_score` has NA due to
          NA in either column `profile_ranking` or `reduction_targets`",
  {
    emissions_profile_at_product_level <-
      example_emissions_profile_at_product_level() |>
      filter(companies_id %in% c("antimonarchy_canine", "nonphilosophical_llama"))
    sector_profile_at_product_level <-
      example_sector_profile_at_product_level() |>
      filter(companies_id %in% c("celestial_lovebird", "nonphilosophical_llama"))

    out <-
      score_transition_risk(emissions_profile_at_product_level,
                            sector_profile_at_product_level) |>
      unnest_product()

    tr_score_na <- out |>
      filter(is.na(transition_risk_score))

    benchmark_tr_score_na <- out |>
      filter(is.na(benchmark_tr_score))

    ranking_reduction_na <- out |>
      filter(is.na(profile_ranking) | is.na(reduction_targets))

    expect_equal(tr_score_na, ranking_reduction_na)
    expect_equal(benchmark_tr_score_na, ranking_reduction_na)
  }
)

test_that(
  "product level and company level outputs contain additional info of all
  uncommon/unmatched companies after joining emissions companies with sector companies",
  {
    emissions_profile_at_product_level <-
      example_emissions_profile_at_product_level() |>
      filter(companies_id %in% c("antimonarchy_canine", "nonphilosophical_llama"))
    sector_profile_at_product_level <-
      example_sector_profile_at_product_level() |>
      filter(companies_id %in% c("celestial_lovebird", "nonphilosophical_llama"))

    trs_product <-
      score_transition_risk(emissions_profile_at_product_level,
                            sector_profile_at_product_level) |>
      unnest_product()

    trs_company <-
      score_transition_risk(emissions_profile_at_product_level,
                            sector_profile_at_product_level) |>
      unnest_company()

    # NA values in `profile_ranking` and `reduction_targets` columns due to unmatched companies
    unmatched_product_output <- trs_product |>
      filter(is.na(profile_ranking) | is.na(reduction_targets))
    unmatched_company_output <- trs_company |>
      filter(is.na(profile_ranking_avg) |
               is.na(reduction_targets_avg))

    # Select NA values in common columns of unmatched companies (except columns
    # computed by `score_transition_risk` function)
    null_common_cols_product <- unmatched_product_output |>
      select(common_columns_emissions_sector_at_product_level()) |>
      filter(if_any(everything(), is.na))
    null_common_cols_company <- unmatched_company_output |>
      select(common_columns_emissions_sector_at_company_level()) |>
      filter(if_any(everything(), is.na))

    # These checks ensures that there is not even a single NA in common columns
    # of unmatched companies at both product and company level
    expect_true(nrow(null_common_cols_product) == 0)
    expect_true(nrow(null_common_cols_company) == 0)
  }
)
