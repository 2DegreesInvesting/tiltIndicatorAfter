test_that("total number of rows for a comapny is either 1, 2 or 4", {
  skip("FIXME unexpected result")

  out <- prepare_pstr_product(
    unnest_product(toy_sector_profile_output()),
    ep_companies,
    ecoinvent_activities,
    small_matches_mapper
  ) |>
    group_by(companies_id, ep_product, activity_uuid_product_uuid) |>
    summarise(count = n())
  expect_true(all(unique(out$count) %in% c(1, 2, 4)))
})

test_that("handles tiltIndicator output", {
  expect_no_error(
    prepare_pstr_product(
      unnest_product(toy_sector_profile_output()) |> head(3),
      ep_companies |> head(3),
      ecoinvent_activities |> head(3),
      matches_mapper |> head(3)
    )
  )
})
