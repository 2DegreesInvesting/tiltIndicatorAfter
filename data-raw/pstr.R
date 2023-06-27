library(here)
library(readr)
library(usethis)
devtools::load_all()

# Source:

pstr_product <- read_csv(here("data-raw", "sample_input_datasets", "pstr_product_level_sample.csv"))
pstr_company <- read_csv(here("data-raw", "sample_input_datasets", "pstr_company_level_sample.csv"))

use_data(pstr_product, overwrite = TRUE)
use_data(pstr_company, overwrite = TRUE)
