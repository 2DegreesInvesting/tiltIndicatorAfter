test_that("total number of rows for a comapny is either 1 or 3", {
  skip("FIXME the result is unexpected")

  local_options(readr.show_col_types = FALSE)

  companies <- read_csv(toy_emissions_profile_any_companies())
  co2 <- read_csv(toy_emissions_profile_products()) |>
    # FIXME: Handle this in tiltIndicator
    rowid_to_column("co2_rowid")
  output <- emissions_profile(companies, co2)

  extra_cols_pattern <- c("rowid", "isic")
  company <- unnest_company(output)
  product <- unnest_product(output) |>
    # FIXME: Handle this inside the new interface
    left_join(select(co2, matches(extra_cols_pattern)), by = "co2_rowid")

  out <- prepare_pctr_company(
    company,
    product,
    ep_companies,
    ecoinvent_activities,
    small_matches_mapper,
    isic_tilt_mapper
  ) |>
    group_by(companies_id, benchmark) |>
    summarise(count = n())
  expect_true(all(unique(out$count) %in% c(1, 3)))
})

test_that("handles numeric `isic*`", {
  local_options(readr.show_col_types = FALSE)

  companies <- read_csv(toy_emissions_profile_any_companies())
  co2 <- read_csv(toy_emissions_profile_products()) |>
    # FIXME: Handle this in tiltIndicator
    rowid_to_column("co2_rowid")
  output <- emissions_profile(companies, co2)

  extra_cols_pattern <- c("rowid", "isic")
  company <- unnest_company(output)
  product <- unnest_product(output) |>
    # FIXME: Handle this inside the new interface
    left_join(select(co2, matches(extra_cols_pattern)), by = "co2_rowid")

  expect_no_error(
    prepare_pctr_company(
      company |> head(3),
      product |> head(3) |> modify_col("isic", as.numeric),
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

  extra_cols_pattern <- c("rowid", "isic")
  company <- unnest_company(output)
  product <- unnest_product(output) |>
    # FIXME: Handle this inside the new interface
    left_join(select(co2, matches(extra_cols_pattern)), by = "co2_rowid")

  expect_no_error(
    prepare_pctr_company(
      company,
      product,
      ep_companies,
      ecoinvent_activities,
      small_matches_mapper,
      isic_tilt_mapper
    )
  )
})

test_that("yields a single distinct value of `*matching_certainty_company_average` per company", {
  id <- "id3"
  clustered_one <- "alarm system"
  clustered_two <- "aluminium"
  uuid_one <- "3d731062-1960-5a36-bd19-6ab2b0bf67c2_245732f4-a5ce-4881-816b-a207ba8df4c8; 3b11f419-2204-5b7c-8cf5-70650f0555ca_245732f4-a5ce-4881-816b-a207ba8df4c8"
  uuid_two <- "ff4fd9d9-7dcb-5a50-926f-76ae31fa454d_618bf4eb-bee5-4d38-8e4f-78cfebf779be; 73f37024-063b-507c-a976-5bc8e1ee469f_618bf4eb-bee5-4d38-8e4f-78cfebf779be"

  product <- tibble(
    companies_id = id,
    grouped_by = "a",
    risk_category = "a",
    clustered = c(clustered_one, clustered_one, clustered_two),
    activity_uuid_product_uuid = c(uuid_one, uuid_one, uuid_two),
    co2_footprint = "a",
    tilt_sector = "a",
    tilt_subsector = "a",
    isic_4digit = "a"
  )

  company <- tibble(
    companies_id = id,
    grouped_by = "a",
    risk_category = c("high", "medium"),
    value = 1.0
  )

  result <- prepare_pctr_company(
    company,
    product,
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
