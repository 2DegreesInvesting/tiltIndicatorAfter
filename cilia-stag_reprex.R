#' ---
#' output: reprex::reprex_document
#' ---

library(readr)
library(dplyr)
devtools::load_all(".")
options(width = 500)

options(readr.show_col_types = FALSE)
toy_emissions_profile_products_ecoinvent <- read_csv(toy_emissions_profile_products_ecoinvent())
toy_emissions_profile_upstream_products_ecoinvent <- read_csv(toy_emissions_profile_upstream_products_ecoinvent())
toy_emissions_profile_any_companies <- read_csv(toy_emissions_profile_any_companies())
toy_europages_companies <- read_csv(toy_europages_companies())
toy_ecoinvent_activities <- read_csv(toy_ecoinvent_activities())
toy_ecoinvent_europages <- read_csv(toy_ecoinvent_europages())
toy_ecoinvent_inputs <- read_csv(toy_ecoinvent_inputs())
toy_isic_name <- read_csv(toy_isic_name())

emissions_profile <- profile_emissions(
  companies = toy_emissions_profile_any_companies,
  co2 = toy_emissions_profile_products_ecoinvent,
  europages_companies = toy_europages_companies,
  ecoinvent_activities = toy_ecoinvent_activities,
  ecoinvent_europages = toy_ecoinvent_europages,
  isic = toy_isic_name)

emissions_profile_upstream <- profile_emissions_upstream(
  companies = toy_emissions_profile_any_companies,
  co2 = toy_emissions_profile_upstream_products_ecoinvent,
  europages_companies = toy_europages_companies,
  ecoinvent_activities = toy_ecoinvent_activities,
  ecoinvent_inputs = toy_ecoinvent_inputs,
  ecoinvent_europages = toy_ecoinvent_europages,
  isic = toy_isic_name)

emissions_profile_at_product_level <- unnest_product(emissions_profile)
emissions_profile_at_company_level <- unnest_company(emissions_profile)
emissions_profile_upstream_at_product_level <- unnest_product(emissions_profile_upstream)
emissions_profile_upstream_at_company_level <- unnest_company(emissions_profile_upstream)

emissions_profile_at_product_level

emissions_profile_at_company_level

emissions_profile_upstream_at_product_level

emissions_profile_upstream_at_company_level
