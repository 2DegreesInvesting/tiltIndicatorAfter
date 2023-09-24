test_that("total number of rows for a comapny is either 1 or 6", {
  out <- prepare_pctr_product(pctr_product, ep_companies, ecoinvent_activities, small_matches_mapper, isic_tilt_mapper) |>
    group_by(companies_id, ep_product, activity_uuid_product_uuid) |>
    summarise(count = n())
  expect_true(all(unique(out$count) %in% c(1, 6)))
})

test_that("handles numeric `isic*`", {
  expect_no_error(
    prepare_pctr_product(
      pctr_product |> head(1) |> modify_col("isic", as.numeric),
      ep_companies |> head(1),
      ecoinvent_activities |> head(1),
      small_matches_mapper |> head(1),
      isic_tilt_mapper |> head(1)
    )
  )
})

test_that("doesn't throw error: 'Column unit doesn't exist' (#26)", {
  emissions_profile_product <- tibble(
    companies_id = "a",
    grouped_by = "all",
    risk_category = "high",
    co2_footprint = 1,
    tilt_sector = "Industry",
    tilt_subsector = "Other",
    isic_4digit = "2560"
  )

  expect_no_error(
    prepare_pctr_product(
      emissions_profile_product,
      ep_companies |> head(1),
      ecoinvent_activities |> head(1),
      small_matches_mapper |> head(1),
      isic_tilt_mapper |> head(1)
    )
  )
})
