library(here)
library(readr)
library(usethis)
devtools::load_all()

# Source:

ictr_product <- read_csv(here("data-raw", "sample_input_datasets", "ictr_product_level_sample.csv"))
ictr_company <- read_csv(here("data-raw", "sample_input_datasets", "ictr_company_level_sample.csv"))

use_data(ictr_product, overwrite = TRUE)
use_data(ictr_company, overwrite = TRUE)
