tiltToyData::toy_europages_companies() |>
  readr::read_csv(show_col_types = FALSE) |>
  # Fake headcount data
  mutate(min_headcount = 1, max_headcount = 10) |>
  readr::write_csv(here::here("inst/extdata/toy_europages_companies.csv.gz"))
