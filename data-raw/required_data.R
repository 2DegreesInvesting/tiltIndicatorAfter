library(here)
library(readr)
library(usethis)
devtools::load_all()

# Source:

ep_companies <- read_csv(here("data-raw", "sample_input_datasets", "ep_companies_2_sample.csv")) |>
  select("company_name", "country", "company_city", "postcode", "address", "main_activity", "companies_id") |>
  distinct()

ecoinvent_inputs <- read_csv(here("data-raw", "sample_input_datasets", "ei_input_data_2_sample.csv")) |>
  select("input_activity_uuid_product_uuid", "exchange_name", "exchange_unit_name") |>
  distinct()

matches_mapper <- read_csv(here("data-raw", "mapper_ep_ei.csv"))

ecoinvent_activities <- read_csv(here("data-raw", "ei_activities_overview.csv"))

isic <- read_csv(here("data-raw", "230712_ISIC_tilt_mapper.csv")) |>
  select("isic_4digit", "isic_4digit_name_ecoinvent")

use_data(ep_companies, overwrite = TRUE)
use_data(matches_mapper, overwrite = TRUE)
use_data(ecoinvent_activities, overwrite = TRUE)
use_data(ecoinvent_inputs, overwrite = TRUE)
use_data(isic, overwrite = TRUE)
