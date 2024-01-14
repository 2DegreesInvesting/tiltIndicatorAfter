test_that("total number of rows for a comapny is either 1 or 3", {
  skip("FIXME the result is unexpected")

  local_options(readr.show_col_types = FALSE)

  companies <- read_csv(toy_emissions_profile_any_companies())
  co2 <- read_csv(toy_emissions_profile_products())

  out <- profile_emissions(
    companies,
    co2,
    europages_companies = read_csv(toy_europages_companies()),
    ecoinvent_activities = read_csv(toy_ecoinvent_activities()),
    ecoinvent_europages = read_csv(toy_ecoinvent_europages()),
    isic = isic_name
  ) |>
    unnest_company() |>
    group_by(companies_id, benchmark) |>
    summarise(count = n())
  expect_true(all(unique(out$count) %in% c(1, 3)))
})

test_that("handles numeric `isic*` in `co2`", {
  local_options(readr.show_col_types = FALSE)

  companies <- read_csv(toy_emissions_profile_any_companies())
  co2 <- read_csv(toy_emissions_profile_products())

  expect_no_error(
    profile_emissions(
      companies,
      co2 |> modify_col("isic", unquote) |> modify_col("isic", as.numeric),
      europages_companies = read_csv(toy_europages_companies()),
      ecoinvent_activities = read_csv(toy_ecoinvent_activities()),
      ecoinvent_europages = read_csv(toy_ecoinvent_europages()),
      isic = isic_name
    )
  )
})

test_that("yields a single distinct value of `*matching_certainty_company_average` per company", {
  # TODO: Rewrite to call the new API
  id <- "id3"
  clustered <- "alarm system"
  uuid <- "3d731062-1960-5a36-bd19-6ab2b0bf67c2_245732f4-a5ce-4881-816b-a207ba8df4c8"

  product <- tibble(
    companies_id = id,
    grouped_by = "a",
    risk_category = "a",
    clustered = clustered,
    activity_uuid_product_uuid = uuid,
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
    read_csv(toy_europages_companies()),
    read_csv(toy_ecoinvent_activities()),
    matches_mapper,
    isic_name
  )

  expect_equal(unique(result$matching_certainty_company_average), "low")
})
