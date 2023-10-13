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

test_that("yields a single distinct value of `*matching_certainty_company_average` per company", {
  product <- tibble(
    companies_id = c("id1", "id1", "id1"),
    grouped_by = c("a", "a", "a"),
    risk_category = c("a", "a", "a"),
    clustered = c("building construction", "building construction", "machining"),
    activity_uuid_product_uuid = c(
      "ebd4dddf-9f74-5fd1-89ce-197b60cb8d06_006863b7-d736-4eb6-bbf8-648d292184ad",
      "ebd4dddf-9f74-5fd1-89ce-197b60cb8d06_006863b7-d736-4eb6-bbf8-648d292184ad",
      "6fcaa508-05b7-5a7b-981a-c9145f5e5dc4_a1de1103-7e58-4fe9-bd26-b86ebd3211b3"
    ),
    co2_footprint = c("a", "a", "a"),
    tilt_sector = c("a", "a", "a"),
    tilt_subsector = c("a", "a", "a"),
    isic_4digit = c("a", "a", "a")
  )

  result <- prepare_pctr_product(
    product,
    ep_companies,
    ecoinvent_activities,
    matches_mapper,
    isic_tilt_mapper
  )
  out <- result |>
    group_by(companies_id) |>
    summarise(count = n_distinct(matching_certainty_company_average))

  expect_lte(unique(out$count), 1)
})
