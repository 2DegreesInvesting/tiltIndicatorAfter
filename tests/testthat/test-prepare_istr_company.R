test_that("total number of rows for a comapny is either 1 or 3", {
  company <- unnest_company(toy_sector_profile_upstream_output())
  product <- unnest_product(toy_sector_profile_upstream_output())

  out <- prepare_istr_company(
    company,
    product,
    ep_companies,
    ecoinvent_activities,
    small_matches_mapper,
    ecoinvent_inputs
  ) |>
    group_by(companies_id, scenario, year) |>
    summarise(count = n())
  expect_true(all(unique(out$count) %in% c(1, 3)))
})

test_that("handles tiltIndicator output", {
  company <- unnest_company(toy_sector_profile_upstream_output()) |> head(3)
  product <- unnest_product(toy_sector_profile_upstream_output()) |> head(3)

  expect_no_error(
    prepare_istr_company(
      company,
      product,
      ep_companies |> head(3),
      ecoinvent_activities |> head(3),
      matches_mapper |> head(3),
      ecoinvent_inputs |> head(3)
    )
  )
})
