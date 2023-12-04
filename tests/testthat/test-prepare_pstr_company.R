test_that("total number of rows for a comapny is either 1 or 3", {
  company <- unnest_company(toy_sector_profile_output())
  product <- unnest_product(toy_sector_profile_output())

  out <- prepare_pstr_company(
    company,
    product,
    ep_companies,
    ecoinvent_activities,
    small_matches_mapper,
    isic_tilt_mapper
  ) |>
    group_by(companies_id, scenario, year) |>
    summarise(count = n())

  expect_true(all(unique(out$count) %in% c(1, 3)))
})

test_that("handles tiltIndicator output", {
  company <- unnest_company(toy_sector_profile_output())
  product <- unnest_product(toy_sector_profile_output())

  expect_no_error(
    prepare_pstr_company(
      company |> head(3),
      product |> head(3),
      ep_companies |> head(3),
      ecoinvent_activities |> head(3),
      matches_mapper |> head(3),
      isic_tilt_mapper |> head(3)
    )
  )
})

test_that("'empty' tiltIndicator results yield at most 1 NA in *risk_category", {
  product <- unnest_product(toy_sector_profile_output())
  product_empty <- product[1, ]
  product_empty[1, "companies_id"] <- "a"
  product_empty[1, "risk_category"] <- NA_character_

  company_empty <- tibble(
    companies_id = "a",
    grouped_by = NA_character_,
    risk_category = NA_character_,
    value = NA_real_
  )

  result <- prepare_pstr_company(
    company_empty,
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
