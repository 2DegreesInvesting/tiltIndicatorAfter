# ## tiltIndicatorAfter-Runner for ICTR with real data
#
# library(dplyr, warn.conflicts = FALSE)
# library(readr, warn.conflicts = FALSE)
# library(tidyr, warn.conflicts = FALSE)
# library(purrr, warn.conflicts = FALSE)
# library(rappdirs)
# library(future)
# library(furrr)
# library(fs)
# library(tiltIndicator)
# ## devtools::install_github("2DegreesInvesting/tiltIndicatorAfter")
# library(tiltIndicatorAfter)
#
# options(readr.show_col_types = FALSE)
# # Enable computing over multiple workers in parallel
# plan(multisession)
#
# # Helpers ----
#
# cache_path <- function(..., parent = cache_dir()) {
#   path(parent, ...)
# }
#
# cache_dir <- function() {
#   user_cache_dir(appname = "tiltIndicatorAfter")
# }
#
# nest_chunk <- function(data, .by, chunks) {
#   data |>
#     nest(.by = all_of(.by)) |>
#     mutate(data, chunk = as.integer(cut(row_number(), chunks))) |>
#     unnest(data) |>
#     nest(.by = chunk)
# }
#
# add_file <- function(data, parent_product, parent_company, ext = ".rds") {
#   dir_create(parent_product)
#   dir_create(parent_company)
#   mutate(data, file_product = path(parent_product, paste0(chunk, ext)), file_company = path(parent_company, paste0(chunk, ext)))
# }
#
# pick_undone <- function(data) {
#   data |>
#     add_done() |>
#     filter(!done_product | !done_company)
# }
#
# add_done <- function(data, file_product, file_company) {
#   mutate(data, done_product = file_exists(file_product), done_company = file_exists(file_company))
# }
#
# # ICTR
#
# ictr_comp <- read_csv("/path/to/input/xctr_companies.csv") |>
#   rename(company_id = "companies_id") |>
#   select(all_of(c(
#     "activity_uuid_product_uuid",
#     "clustered",
#     "company_id",
#     "unit"
#   )))
#
# ictr_prod <- read_csv("/path/to/input/ictr_products.csv", col_types = cols(input_isic_4digit = col_character())) |>
#   select(all_of(c(
#     "input_co2_footprint",
#     "input_tilt_sector",
#     "input_unit",
#     "input_isic_4digit",
#     "input_activity_uuid_product_uuid",
#     "activity_uuid_product_uuid"
#   )))
#
# is_na_free <- !anyNA(ictr_prod$input_co2_footprint)
# stopifnot(is_na_free)
#
# # ep_companies
# ep_campanies_mapper <- read_csv("/path/to/input/ep_companies.csv") |>
#   select("company_name", "country", "company_city", "postcode", "address", "main_activity", "companies_id") |>
#   distinct()
#
# # ecoinvent_activities
# eco_act <- read_csv("/path/to/input/ei_activities_overview.csv")
#
# # matches_mapper
# match_map <- read_csv("/path/to/input/mapper_ep_ei.csv")
#
# # ecoinvent_inputs
# eco_inputs_raw <- read_csv("/path/to/input/ei_input_data.csv") |>
#   select("input_activity_uuid_product_uuid", "exchange_name", "exchange_unit_name") |>
#   distinct()
#
# ictr_job <- ictr_comp |>
#   nest_chunk(.by = "company_id", chunks = 1000) |>
#   add_file(parent_product = cache_path("ictr/product"), parent_company = cache_path("ictr/company"))
#
# ictr_rds <- function(data, file_product, file_company) {
#   out <- xctr(data, ictr_prod)
#
#   out |>
#     unnest_product() |>
#     prepare_ictr_product(ep_campanies_mapper, eco_act, match_map, eco_inputs_raw) |>
#     write_rds(file_product)
#
#   out |>
#     unnest_company() |>
#     prepare_ictr_company(unnest_product(out), ep_campanies_mapper, eco_act, match_map, eco_inputs_raw) |>
#     write_rds(file_company)
# }
#
# ictr_job |>
#   pick_undone() |>
#   select(data, file_product, file_company) |>
#   future_pwalk(ictr_rds, .progress = TRUE)
#
# ictr_product_result <- map_df(ictr_job$file_product, read_rds)
# # ictr_product_result |>
# #   write_csv("/path/to/output/ictr_product_result.csv")
#
# ictr_company_result <- map_df(ictr_job$file_company, read_rds)
# # ictr_company_result |>
# #   write_csv("/path/to/output/ictr_company_result.csv")
#
# # Each chunk result was saved to a file
# dir_tree(cache_path("ictr/product"))
# dir_tree(cache_path("ictr/company"))
