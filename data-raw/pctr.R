library(here)
library(readr)
library(usethis)
devtools::load_all()

# Source:

pctr_product <- read_csv(here("data-raw", "sample_input_datasets", "pctr_product_level_sample.csv"),
                         col_types = cols(isic_4digit = col_character()))
pctr_company <- read_csv(here("data-raw", "sample_input_datasets", "pctr_company_level_sample.csv"))

use_data(pctr_product, overwrite = TRUE)
use_data(pctr_company, overwrite = TRUE)
