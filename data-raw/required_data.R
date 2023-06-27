library(here)
library(readr)
library(usethis)
devtools::load_all()

# Source:

companies <- read_csv(here("data-raw", "sample_input_datasets", "ep_companies_2_sample.csv"))
matches_mapper <- read_csv(here("data-raw", "mapper_ep_ei.csv"))
ecoinvent_activities <- read_csv(here("data-raw", "ei_activities_overview_2.csv"))
ecoinvent_inputs <- read_csv(here("data-raw", "ei_input_data_2.csv"))

use_data(companies, overwrite = TRUE)
use_data(matches_mapper, overwrite = TRUE)
use_data(ecoinvent_activities, overwrite = TRUE)
use_data(ecoinvent_inputs, overwrite = TRUE)
