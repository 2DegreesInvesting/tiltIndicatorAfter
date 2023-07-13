# ## tiltIndicatorAfter-Runner for ISTR with real data
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
# istr_comp <- read_csv("/path/to/input/istr_companies.csv") |>
#   rename(company_id = "companies_id") |>
#   xstr_prune_companies()
#
# istr_inputs_raw <- read_csv("/path/to/input/istr_products_v2.csv", col_types = cols(input_isic_4digit = col_character())) |>
#   rename(weo_product = "input_weo_sector", weo_flow = "input_weo_subsector", ipr_sector = "input_ipr_sector", ipr_subsector = "input_ipr_subsector") |>
#   xstr_pivot_type_sector_subsector()
#
# scenario_years <- c(2030, 2050)
# ipr <- read_csv("/path/to/input/str_ipr_targets.csv")
# weo <- read_csv("/path/to/input/str_weo_targets.csv")
# scenarios_new <- list(ipr = ipr, weo = weo) |>
#   xstr_prepare_scenario() |>
#   filter(year %in% scenario_years)
#
# ep_campanies_mapper <- read_csv("/path/to/input/ep_companies_2.csv") |>
#   select("company_name", "country", "company_city", "postcode", "address", "main_activity", "companies_id") |>
#   distinct()
#
# # ecoinvent_activities
# eco_act <- read_csv("/path/to/input/ei_activities_overview_2.csv")
#
# # matches_mapper
# match_map <- read_csv("/path/to/input/mapper_ep_ei.csv")
#
# # ecoinvent_inputs
# eco_inputs_raw <- read_csv("/path/to/input/ei_input_data_2.csv") |>
#   select("input_activity_uuid_product_uuid", "exchange_name", "exchange_unit_name") |>
#   distinct()
#
# istr_job <- istr_comp |>
#   nest_chunk(.by = "company_id", chunks = 1000) |>
#   add_file(parent_product = cache_path("istr/product"), parent_company = cache_path("istr/company"))
#
# istr_rds <- function(data, file_product, file_company) {
#   out <- istr(data, scenarios_new, istr_inputs_raw)
#
#   out |>
#     unnest_product() |>
#     prepare_istr_product(ep_campanies_mapper, eco_act, match_map, eco_inputs_raw) |>
#     write_rds(file_product)
#
#   out |>
#     unnest_company() |>
#     xstr_polish_output_at_company_level() |>
#     prepare_istr_company(unnest_product(out), ep_campanies_mapper, eco_act, match_map, eco_inputs_raw) |>
#     write_rds(file_company)
# }
#
# istr_job |>
#   pick_undone() |>
#   select(data, file_product, file_company) |>
#   future_pwalk(istr_rds, .progress = TRUE)
#
# istr_product_result <- map_df(istr_job$file_product, read_rds)
# istr_product_result
# # TODO: `... |> write_csv("/path/to/output/istr_product_result.csv")`
#
# istr_company_result <- map_df(istr_job$file_company, read_rds)
# istr_company_result
# # TODO: `... |> write_csv("/path/to/output/istr_company_result.csv")`
#
# # Each chunk result was saved to a file
# dir_tree(cache_path("istr/product"))
# dir_tree(cache_path("istr/company"))
