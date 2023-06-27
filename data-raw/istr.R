library(here)
library(readr)
library(usethis)
devtools::load_all()

# Source:

istr_product <- read_csv(here("data-raw", "sample_input_datasets", "istr_product_level_sample.csv"))
istr_company <- read_csv(here("data-raw", "sample_input_datasets", "istr_company_level_sample.csv"))

use_data(istr_product, overwrite = TRUE)
use_data(istr_company, overwrite = TRUE)
