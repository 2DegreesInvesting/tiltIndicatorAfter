# Avoid depending on volatile names. Instead reuse names in crucial entities
# that are stable and consistent across indicators.

# Exist in the return value of all indicators at all levels (see
# ?document_default_value()):
# * grouped_by
# * risk_category
#
# Exist in function names:
# * emissions_profile
# * emissions_profile_upstream
col_grouped_by <- function() "benchmark"
col_risk_category_emissions_profile <- function() "emission_profile"
col_risk_category_emissions_profile_profile_upstream <- function() "emission_upstream_profile"


# Lower level components can define more
# volatile lower level names, but the code is easier to maintain if it accesses
# theh lower-level names using higher-level interfaces. For example, access the
# lower-level column name "emission_profile" through the higher-level interface
# `col_risk_category_emissions_profile`

col_footprint <- function() "co2_footprint"
col_footprint_mean <- function()  "co2_avg"


col_max_jitter <- function() "co2e_upper"
col_min_jitter <- function() "co2e_lower"

pattern_risk_category_emissions_profile_any <- function() "^emission.*profile$"
