test_that("handles numeric `isic*`", {
  expect_no_error(
    prepare_ictr_product(
      ictr_product |> head(1) |> modify_col("isic", as.numeric),
      ep_companies |> head(1),
      ecoinvent_activities |> head(1),
      matches_mapper |> head(1),
      ecoinvent_inputs |> head(1),
      isic_tilt_mapper |> head(1)
    )
  )
})
