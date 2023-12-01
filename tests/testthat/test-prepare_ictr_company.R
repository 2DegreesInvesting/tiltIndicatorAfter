test_that("total number of rows for a comapny is either 1 or 3", {
  local_options(readr.show_col_types = FALSE)

  companies <- read_csv(toy_emissions_profile_any_companies())
  co2 <- read_csv(toy_emissions_profile_upstream_products()) |>
    # FIXME: Handle this in tiltIndicator
    rowid_to_column("co2_rowid")
  output <- emissions_profile_upstream(companies, co2)


  company <- unnest_company(output)
  product <- unnest_product(output) |>
    # FIXME: Handle this inside the new interface
    left_join(select(co2, matches(extra_cols_pattern())), by = "co2_rowid")

  out <- prepare_ictr_company(
    company,
    product,
    ep_companies,
    ecoinvent_activities,
    small_matches_mapper,
    ecoinvent_inputs,
    isic_tilt_mapper
  ) |>
    group_by(companies_id, benchmark) |>
    summarise(count = n())
  expect_true(all(unique(out$count) %in% c(1, 3)))
})

test_that("handles numeric `isic*`", {
  local_options(readr.show_col_types = FALSE)

  companies <- read_csv(toy_emissions_profile_any_companies())
  co2 <- read_csv(toy_emissions_profile_upstream_products()) |>
    # FIXME: Handle this in tiltIndicator
    rowid_to_column("co2_rowid")
  output <- emissions_profile_upstream(companies, co2)


  company <- unnest_company(output)
  product <- unnest_product(output) |>
    # FIXME: Handle this inside the new interface
    left_join(select(co2, matches(extra_cols_pattern())), by = "co2_rowid")

  expect_no_error(
    prepare_ictr_company(
      company |> head(3),
      product |> head(3) |> modify_col("isic", as.numeric),
      ep_companies |> head(3),
      ecoinvent_activities |> head(3),
      small_matches_mapper |> head(3),
      ecoinvent_inputs |> head(3),
      isic_tilt_mapper |> head(3)
    )
  )
})

test_that("takes the outpus of tiltIndicator", {
  local_options(readr.show_col_types = FALSE)

  companies <- read_csv(toy_emissions_profile_any_companies())
  co2 <- read_csv(toy_emissions_profile_upstream_products()) |>
    # FIXME: Handle this in tiltIndicator
    rowid_to_column("co2_rowid")
  output <- emissions_profile_upstream(companies, co2)


  company <- unnest_company(output)
  product <- unnest_product(output) |>
    # FIXME: Handle this inside the new interface
    left_join(select(co2, matches(extra_cols_pattern())), by = "co2_rowid")

  expect_no_error(
    prepare_ictr_company(
      company |> head(3),
      product |> head(3),
      ep_companies |> head(3),
      ecoinvent_activities |> head(3),
      small_matches_mapper |> head(3),
      ecoinvent_inputs |> head(3),
      isic_tilt_mapper |> head(3)
    )
  )
})
