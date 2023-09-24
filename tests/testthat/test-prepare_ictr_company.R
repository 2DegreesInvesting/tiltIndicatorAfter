test_that("total number of rows for a comapny is either 1 or 3", {
  out <- prepare_ictr_company(ictr_company, ictr_product, ep_companies, ecoinvent_activities, small_matches_mapper, ecoinvent_inputs, isic_tilt_mapper) |>
    group_by(companies_id, benchmark) |>
    summarise(count = n())
  expect_true(all(unique(out$count) %in% c(1, 3)))
})

test_that("handles numeric `isic*`", {
  expect_no_error(
    prepare_ictr_company(
      ictr_company |> head(1),
      ictr_product |> head(1) |> modify_col("isic", as.numeric),
      ep_companies |> head(1),
      ecoinvent_activities |> head(1),
      small_matches_mapper |> head(1),
      ecoinvent_inputs |> head(1),
      isic_tilt_mapper |> head(1)
    )
  )
})
