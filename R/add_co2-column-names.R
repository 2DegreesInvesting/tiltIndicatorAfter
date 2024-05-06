col_company_id <- function() {
  "companies_id"
}

col_product_id <- function() {
  "activity_uuid_product_uuid"
}

col_benchmark <- function() {
  "benchmark"
}

col_risk_category_emissions_profile <- function() {
  "emission_profile"
}

col_risk_category_emissions_profile_upstream <- function() {
  "emission_upstream_profile"
}

pattern_risk_category_emissions_profile_any <- function() {
  "^emission.*profile$"
}

col_max_jitter <- function() {
  "co2e_upper"
}

col_min_jitter <- function() {
  "co2e_lower"
}

col_footprint <- function() {
  "co2_footprint"
}

col_footprint_mean <- function() {
  "co2_avg"
}
