# Avoid depending on volatile names. Instead reuse more stable, consistent names
# from higher level components

# Exist in the return value of all indicators at all levels (see
# ?document_default_value()):
# * grouped_by
# * risk_category
#
# Exist in function names:
# * emissions_profile
# * emissions_profile_upstream
col_grouped_by <- function() {
  "benchmark"
}

col_risk_category_emissions_profile <- function() {
  "emission_profile"
}

col_risk_category_emissions_profile_profile_upstream <- function() {
  "emission_upstream_profile"
}


pattern_risk_category_emissions_profile_any <- function() {
  "^emission.*profile$"
}

# Other adaptors in the same spirit

col_footprint <- function() {
  "co2_footprint"
}

col_footprint_mean <- function()  {
  "co2_avg"
}

# Reuse min, max, and jitter from `summarize_range()` which in turn reuses:
# * min and max from `base::min()` and `base::max()`
# * jitter from `base::jitter()`
col_max_jitter <- function() {
  "co2e_upper"
}

col_min_jitter <- function() {
  "co2e_lower"
}
