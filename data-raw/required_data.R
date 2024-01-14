library(here)
library(readr)
library(usethis)
devtools::load_all()

# Source:

isic_name <- read_csv(here("data-raw", "230712_ISIC_tilt_mapper.csv")) |>
  select("isic_4digit", "isic_4digit_name_ecoinvent")

use_data(isic_name, overwrite = TRUE)
