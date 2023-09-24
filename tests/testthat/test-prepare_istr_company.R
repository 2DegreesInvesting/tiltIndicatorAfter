test_that("total number of rows for a comapny is either 1 or 3", {
  out <- prepare_istr_company(
    unnest_company(sector_profile_upstream_result()),
    unnest_product(sector_profile_upstream_result()),
    ep_companies,
    ecoinvent_activities,
    small_matches_mapper,
    ecoinvent_inputs
  ) |>
    group_by(companies_id, scenario, year) |>
    summarise(count = n())
  expect_true(all(unique(out$count) %in% c(1, 3)))
})

test_that("throws no error", {
  expect_no_error(
    prepare_istr_company(
      unnest_company(sector_profile_upstream_result()) |> head(1),
      unnest_product(sector_profile_upstream_result()) |> head(1),
      ep_companies |> head(1),
      ecoinvent_activities |> head(1),
      matches_mapper |> head(1),
      ecoinvent_inputs |> head(1)
    )
  )
})
