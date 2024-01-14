small_matches_mapper <- head(read_csv(toy_ecoinvent_europages()), 100)

toy_emissions_profile_products <- function() {
  withr::local_options(lifecycle_verbosity = "quiet")
  tiltToyData::toy_emissions_profile_products()
}

toy_emissions_profile_upstream_products <- function() {
  withr::local_options(lifecycle_verbosity = "quiet")
  tiltToyData::toy_emissions_profile_upstream_products()
}
