test_that("total number of rows for a comapny is either 1, 2 or 4", {
  skip("FIXME unexpected result")

  product <- unnest_product(toy_sector_profile_output())

  out <- prepare_pstr_product(
    product,
    ep_companies,
    ecoinvent_activities,
    small_matches_mapper,
    isic_tilt_mapper
  ) |>
    group_by(companies_id, ep_product, activity_uuid_product_uuid) |>
    summarise(count = n())
  expect_true(all(unique(out$count) %in% c(1, 2, 4)))
})

test_that("handles tiltIndicator output", {
  product <- unnest_product(toy_sector_profile_output())

  expect_no_error(
    prepare_pstr_product(
      product |> head(3),
      ep_companies |> head(3),
      ecoinvent_activities |> head(3),
      matches_mapper |> head(3),
      isic_tilt_mapper |> head(3)
    )
  )
})

test_that("'empty' tiltIndicator results yield at most 1 NA in *risk_category", {
  product <- unnest_product(toy_sector_profile_output()) |>
    FIXME_add(isic_4digit =  "1234")
  product_empty <- product[1, ]
  product_empty[1, "companies_id"] <- "a"
  product_empty[1, "risk_category"] <- NA_character_

  result <- prepare_pstr_product(
    product_empty,
    ep_companies,
    ecoinvent_activities,
    small_matches_mapper,
    isic_tilt_mapper
  )
  out <- result |>
    filter(is.na(get_column(result, "risk_category"))) |>
    group_by(companies_id) |>
    summarise(count = n())

  expect_lte(unique(out$count), 1)
})

test_that("yield NA in `*tilt_sector` and `*tilt_subsector` for no risk category", {
  product <- unnest_product(toy_sector_profile_output()) |>
    FIXME_add(isic_4digit =  "1234")
  product_empty <- product[1, ]
  product_empty[1, "risk_category"] <- NA_character_

  result <- prepare_pstr_product(
    product_empty,
    ep_companies,
    ecoinvent_activities,
    small_matches_mapper,
    isic_tilt_mapper
  )

  expect_true(all(is.na(select(result, tilt_sector, tilt_subsector))))
})

