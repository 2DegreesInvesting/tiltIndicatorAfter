# Reuse stable, consistent names from higher level components

# Reuse ubiquitous column names, and the pattern <indicator>_profile[_upstream]
# (see tiltIndicator::document_default_value())
col_grouped_by <- function() {
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

# Reuse min, max, and jitter from `tiltIndicator::summarize_range()` and
# `tiltIndicator::summarize_range()` -- which in turn reuses:
# * min and max from `base::min()` and `base::max()`
# * jitter from `base::jitter()`
col_max_jitter <- function() {
  "co2e_upper"
}

col_min_jitter <- function() {
  "co2e_lower"
}

# Other adapters to reduce fragility
col_footprint <- function() {
  "co2_footprint"
}

col_footprint_mean <- function()  {
  "co2_avg"
}
