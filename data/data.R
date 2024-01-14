ecoinvent_inputs <- tiltToyData::toy_ecoinvent_inputs() |>
  readr::read_csv(show_col_types = FALSE)

matches_mapper <- tiltToyData::toy_ecoinvent_europages() |>
  readr::read_csv(show_col_types = FALSE)

isic_name <- tiltToyData::toy_isic_name() |>
  readr::read_csv(show_col_types = FALSE)
