test_that("total number of rows for a comapny is either 1 or 3", {
  local_options(readr.show_col_types = FALSE)

  companies <- read_csv(toy_sector_profile_upstream_companies())
  scenarios <- read_csv(toy_sector_profile_any_scenarios())
  inputs <- read_csv(toy_sector_profile_upstream_products())
  .inputs <- add_rowid(inputs)
  output <- sector_profile_upstream(companies, scenarios, .inputs)
  .product <- unnest_product(output)

  y <- select(.inputs, matches(extra_cols_pattern()))
  x <- select(.product, -any_of(names(y)), extra_rowid())
  product <- left_join(x, y, relationship = "many-to-many", by = extra_rowid())
  company <- unnest_company(output)

  out <- prepare_istr_company(
    company,
    product,
    ep_companies,
    ecoinvent_activities,
    small_matches_mapper,
    ecoinvent_inputs,
    isic_tilt_mapper
  ) |>
    group_by(companies_id, scenario, year) |>
    summarise(count = n())
  expect_true(all(unique(out$count) %in% c(1, 3)))
})

test_that("handles tiltIndicator output", {
  local_options(readr.show_col_types = FALSE)

  companies <- read_csv(toy_sector_profile_upstream_companies())
  scenarios <- read_csv(toy_sector_profile_any_scenarios())
  inputs <- read_csv(toy_sector_profile_upstream_products())
  .inputs <- add_rowid(inputs)
  output <- sector_profile_upstream(companies, scenarios, .inputs)
  .product <- unnest_product(output)

  y <- select(.inputs, matches(extra_cols_pattern()))
  x <- select(.product, -any_of(names(y)), extra_rowid())
  product <- left_join(x, y, relationship = "many-to-many", by = extra_rowid())
  company <- unnest_company(output)

  expect_no_error(
    prepare_istr_company(
      company |> head(3),
      product |> head(3),
      ep_companies |> head(3),
      ecoinvent_activities |> head(3),
      matches_mapper |> head(3),
      ecoinvent_inputs |> head(3),
      isic_tilt_mapper |> head(3)
    )
  )
})
