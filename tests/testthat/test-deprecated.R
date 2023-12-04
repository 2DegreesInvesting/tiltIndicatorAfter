test_that("prepare_ictr_company() is deprecated", {
  expect_snapshot_warning(
    prepare_ictr_company(
      ictr_company |> head(3),
      ictr_product |> head(3),
      ep_companies |> head(3),
      ecoinvent_activities |> head(3),
      matches_mapper |> head(3),
      ecoinvent_inputs |> head(3),
      isic_tilt_mapper |> head(3)
    )
  )
})

test_that("prepare_ictr_product() is deprecated", {
  expect_snapshot_warning(
    prepare_ictr_product(
      ictr_product |> head(3),
      ep_companies |> head(3),
      ecoinvent_activities |> head(3),
      matches_mapper |> head(3),
      ecoinvent_inputs |> head(3),
      isic_tilt_mapper |> head(3)
    )
  )
})

test_that("prepare_istr_company() is deprecated", {
  company <- unnest_company(toy_sector_profile_upstream_output())
  product <- unnest_product(toy_sector_profile_upstream_output())

  expect_snapshot_warning(
    prepare_istr_company(
      company |> head(3),
      product |> head(3),
      ep_companies |> head(3),
      ecoinvent_activities |> head(3),
      matches_mapper |> head(3),
      ecoinvent_inputs |> head(3)
    )
  )
})

test_that("prepare_istr_product() is deprecated", {
  product <- unnest_product(toy_sector_profile_upstream_output())

  expect_snapshot_warning(
    prepare_istr_product(
      product |> head(3),
      ep_companies |> head(3),
      ecoinvent_activities |> head(3),
      matches_mapper |> head(3),
      ecoinvent_inputs |> head(3)
    )
  )
})

test_that("prepare_pctr_company() is deprecated", {
  expect_snapshot_warning(
    prepare_pctr_company(
      pctr_company |> head(3),
      pctr_product |> head(3),
      ep_companies |> head(3),
      ecoinvent_activities |> head(3),
      matches_mapper |> head(3),
      isic_tilt_mapper |> head(3)
    )
  )
})

test_that("prepare_pctr_product() is deprecated", {
  expect_snapshot_warning(
    prepare_pctr_product(
      pctr_product |> head(3),
      ep_companies |> head(3),
      ecoinvent_activities |> head(3),
      matches_mapper |> head(3),
      isic_tilt_mapper |> head(3)
    )
  )
})

test_that("prepare_pstr_company() is deprecated", {
  company <- unnest_company(toy_sector_profile_upstream_output())
  product <- unnest_product(toy_sector_profile_upstream_output())

  expect_snapshot_warning(
    prepare_pstr_company(
      company |> head(3),
      product |> head(3),
      ep_companies |> head(3),
      ecoinvent_activities |> head(3),
      matches_mapper |> head(3)
    )
  )
})

test_that("prepare_pstr_product() is deprecated", {
  expect_snapshot_warning(
    prepare_pstr_product(
      pstr_product |> head(3),
      ep_companies |> head(3),
      ecoinvent_activities |> head(3),
      matches_mapper |> head(3)
    )
  )
})
