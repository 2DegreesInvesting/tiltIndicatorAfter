ep_companies <- tiltToyData::toy_europages_companies() |>
  readr::read_csv(show_col_types = FALSE)

ecoinvent_activities <- tiltToyData::toy_ecoinvent_activities() |>
  readr::read_csv(show_col_types = FALSE)

ecoinvent_inputs <- tiltToyData::toy_ecoinvent_inputs() |>
  readr::read_csv(show_col_types = FALSE)

matches_mapper <- tiltToyData::toy_ecoinvent_europages() |>
  readr::read_csv(show_col_types = FALSE)

# tiltIndicatorAfter::isic_name |>
#   readr::write_csv("inst/extdata/isic_name.csv.gz")
