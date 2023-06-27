library(here)
library(readr)
library(usethis)
devtools::load_all()

# Source:

pctr_product_level_sample <- read_csv(here("data-raw", "sample_input_datasets", "pctr_product_level_sample.csv"))
pctr_company_level_sample <- read_csv(here("data-raw", "sample_input_datasets", "pctr_company_level_sample.csv"))

use_data(pctr_product_level_sample, overwrite = TRUE)
use_data(pctr_company_level_sample, overwrite = TRUE)
