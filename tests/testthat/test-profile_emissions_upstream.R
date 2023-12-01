test_that("the new API is equivalent to the old API", {
  local_options(readr.show_col_types = FALSE)

  companies <- read_csv(toy_emissions_profile_any_companies())
  co2 <- read_csv(toy_emissions_profile_upstream_products())
  europages_companies <- ep_companies |> head(3)
  ecoinvent_activities <- ecoinvent_activities |> head(3)
  ecoinvent_inputs <- ecoinvent_inputs |> head(3)
  ecoinvent_europages <- small_matches_mapper |> head(3)
  isic_tilt <- isic_tilt_mapper |> head(3)

  # New API
  out <- profile_emissions_upstream(
    companies,
    co2,
    europages_companies = europages_companies,
    ecoinvent_activities = ecoinvent_activities,
    ecoinvent_europages = ecoinvent_europages,
    ecoinvent_inputs = ecoinvent_inputs,
    isic_tilt = isic_tilt
  )

  # Old API
  .co2 <- rowid_to_column(co2, "co2_rowid")
  output <- emissions_profile_upstream(companies, .co2)

  extra_cols_pattern <- c("rowid", "isic", "sector")
  company <- unnest_company(output)
  product <- unnest_product(output) |>
    left_join(select(.co2, matches(extra_cols_pattern)), by = "co2_rowid")

  out_product <- prepare_ictr_product(
    product,
    europages_companies,
    ecoinvent_activities,
    ecoinvent_europages,
    ecoinvent_inputs,
    isic_tilt
  )

  out_company <- prepare_ictr_company(
    company,
    product,
    europages_companies,
    ecoinvent_activities,
    ecoinvent_europages,
    ecoinvent_inputs,
    isic_tilt
  )

  expect_equal(
    out |> unnest_product() |> arrange(companies_id),
    out_product |> arrange(companies_id)
  )
  expect_equal(
    out |> unnest_company() |> arrange(companies_id),
    out_company |> arrange(companies_id)
  )
})

test_that("the output at product level has columns matching isic and sector", {
  local_options(readr.show_col_types = FALSE)

  companies <- read_csv(toy_emissions_profile_any_companies())
  co2 <- read_csv(toy_emissions_profile_upstream_products())
  europages_companies <- ep_companies |> head(3)
  ecoinvent_activities <- ecoinvent_activities |> head(3)
  ecoinvent_inputs <- ecoinvent_inputs |> head(3)
  ecoinvent_europages <- small_matches_mapper |> head(3)
  isic_tilt <- isic_tilt_mapper |> head(3)

  out <- profile_emissions_upstream(
    companies,
    co2,
    europages_companies = europages_companies,
    ecoinvent_activities = ecoinvent_activities,
    ecoinvent_europages = ecoinvent_europages,
    ecoinvent_inputs = ecoinvent_inputs,
    isic_tilt = isic_tilt
  )

  product <- unnest_product(out)
  expect_true(any(matches_name(product, "isic")))
  expect_true(any(matches_name(product, "sector")))
})
