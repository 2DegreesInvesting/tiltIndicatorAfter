# FIME: Add meaningful test

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

  # product <- unnest_product(toy_sector_profile_upstream_output())
  expect_no_error(
    prepare_istr_product(
      product |> head(3),
      ep_companies |> head(3),
      ecoinvent_activities |> head(3),
      matches_mapper |> head(3),
      ecoinvent_inputs |> head(3),
      isic_tilt_mapper |> head(3)
    )
  )
})
