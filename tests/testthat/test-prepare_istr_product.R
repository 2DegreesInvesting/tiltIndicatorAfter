# FIME: Add meaningful test

test_that("handles tiltIndicator output", {
  product <- unnest_product(toy_sector_profile_upstream_output())
  expect_no_error(
    prepare_istr_product(
      product |> head(3),
      ep_companies |> head(3),
      ecoinvent_activities |> head(3),
      matches_mapper |> head(3),
      ecoinvent_inputs |> head(3)
    )
  )
})
