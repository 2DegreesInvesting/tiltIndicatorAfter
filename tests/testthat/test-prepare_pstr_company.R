test_that("total number of rows for a comapny is either 1 or 3", {
  out <- prepare_pstr_company(
    unnest_company(toy_sector_profile_output()),
    unnest_product(toy_sector_profile_output()),
    ep_companies,
    ecoinvent_activities,
    small_matches_mapper
  ) |>
    group_by(companies_id, scenario, year) |>
    summarise(count = n())

  expect_true(all(unique(out$count) %in% c(1, 3)))
})

test_that("handles tiltIndicator output", {
  expect_no_error(
    prepare_pstr_company(
      unnest_company(toy_sector_profile_output()) |> head(3),
      unnest_product(toy_sector_profile_output()) |> head(3),
      ep_companies |> head(3),
      ecoinvent_activities |> head(3),
      matches_mapper |> head(3)
    )
  )
})
