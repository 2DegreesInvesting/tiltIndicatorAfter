test_that("total number of rows for a comapny is either 1 or 6", {
  local_options(readr.show_col_types = FALSE)

  companies <- read_csv(toy_emissions_profile_any_companies())
  co2 <- read_csv(toy_emissions_profile_products()) |>
    # FIXME: Handle this in tiltIndicator
    rowid_to_column("co2_rowid")
  output <- emissions_profile(companies, co2)

  extra_cols_pattern <- c("rowid", "isic", "sector")
  product <- unnest_product(output) |>
    # FIXME: Handle this inside the new interface
    left_join(select(co2, matches(extra_cols_pattern)), by = "co2_rowid")

  out <- prepare_pctr_product(
    product,
    ep_companies,
    ecoinvent_activities,
    small_matches_mapper,
    isic_tilt_mapper
  ) |>
    group_by(companies_id, ep_product, activity_uuid_product_uuid) |>
    summarise(count = n())
  expect_true(all(unique(out$count) %in% c(1, 6)))
})

test_that("handles numeric `isic*`", {
  local_options(readr.show_col_types = FALSE)

  companies <- read_csv(toy_emissions_profile_any_companies())
  co2 <- read_csv(toy_emissions_profile_products()) |>
    # FIXME: Handle this in tiltIndicator
    rowid_to_column("co2_rowid")
  output <- emissions_profile(companies, co2)

  extra_cols_pattern <- c("rowid", "isic", "sector")
  product <- unnest_product(output) |>
    # FIXME: Handle this inside the new interface
    left_join(select(co2, matches(extra_cols_pattern)), by = "co2_rowid")

  expect_no_error(
    prepare_pctr_product(
      pctr_product |> head(3) |> modify_col("isic", as.numeric),
      ep_companies |> head(3),
      ecoinvent_activities |> head(3),
      small_matches_mapper |> head(3),
      isic_tilt_mapper |> head(3)
    )
  )
})

test_that("doesn't throw error: 'Column unit doesn't exist' (#26)", {
  local_options(readr.show_col_types = FALSE)

  companies <- read_csv(toy_emissions_profile_any_companies())
  co2 <- read_csv(toy_emissions_profile_products()) |>
    # FIXME: Handle this in tiltIndicator
    rowid_to_column("co2_rowid")
  output <- emissions_profile(companies, co2)

  extra_cols_pattern <- c("rowid", "isic", "sector")
  product <- unnest_product(output) |>
    # FIXME: Handle this inside the new interface
    left_join(select(co2, matches(extra_cols_pattern)), by = "co2_rowid")

  expect_no_error(
    prepare_pctr_product(
      product,
      ep_companies |> head(3),
      ecoinvent_activities |> head(3),
      small_matches_mapper |> head(3),
      isic_tilt_mapper |> head(3)
    )
  )
})

test_that("handles tiltIndicator output", {
  local_options(readr.show_col_types = FALSE)

  companies <- read_csv(toy_emissions_profile_any_companies())
  co2 <- read_csv(toy_emissions_profile_products()) |>
    # FIXME: Handle this in tiltIndicator
    rowid_to_column("co2_rowid")
  output <- emissions_profile(companies, co2)

  extra_cols_pattern <- c("rowid", "isic", "sector")
  product <- unnest_product(output) |>
    # FIXME: Handle this inside the new interface
    left_join(select(co2, matches(extra_cols_pattern)), by = "co2_rowid")

  expect_no_error(
    prepare_pctr_product(
      product |> head(3),
      ep_companies |> head(3),
      ecoinvent_activities |> head(3),
      small_matches_mapper |> head(3),
      isic_tilt_mapper |> head(3)
    )
  )
})

test_that("*matching_certainty_company_average column yield only 1 unique value", {

  product_empty <- pctr_product |>
    filter(clustered %in% c("building construction", "machining"))

  result <- prepare_pctr_product(
    product_empty,
    ep_companies,
    ecoinvent_activities,
    small_matches_mapper,
    isic_tilt_mapper
  )
  out <- result |>
    group_by(companies_id) |>
    summarise(count = n_distinct(matching_certainty_company_average))

  expect_lte(unique(out$count), 1)
})

