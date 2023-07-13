# ## tiltIndicatorAfter-Runner for PCTR with real data

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
# # PCTR
# pctr_comp <- read_csv("/path/to/input/xctr_companies.csv") |>
#   rename(company_id = "companies_id") |>
#   select(all_of(c(
#     "activity_uuid_product_uuid",
#     "clustered",
#     "company_id",
#     "unit"
#   )))
#
# pctr_prod <- read_csv("/path/to/input/pctr_products_v2.csv", col_types = cols(isic_4digit = col_character()), show_col_types = FALSE) |>
#   select(all_of(c(
#     "co2_footprint",
#     "tilt_sector",
#     "unit",
#     "isic_4digit",
#     "activity_uuid_product_uuid",
#     "ei_activity_name"
#   ))) |>
#   filter(row_number() == 1L, .by = "activity_uuid_product_uuid")
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
# # Create a "job" data frame where each row is a chunk of data
# pctr_job <- pctr_comp |>
#   nest_chunk(.by = "company_id", chunks = 1000) |>
#   add_file(parent_product = cache_path("pctr/product"), parent_company = cache_path("pctr/company"))
#
# pctr_rds <- function(data, file_product, file_company) {
#   out <- xctr(data, pctr_prod)
#
#   out |>
#     unnest_product() |>
#     prepare_pctr_product(ep_campanies_mapper, eco_act, match_map) |>
#     write_rds(file_product)
#
#   out |>
#     unnest_company() |>
#     prepare_pctr_company(unnest_product(out), ep_campanies_mapper, eco_act, match_map) |>
#     write_rds(file_company)
# }
#
# pctr_job |>
#   pick_undone() |>
#   select(data, file_product, file_company) |>
#   future_pwalk(pctr_rds, .progress = TRUE)
#
# pctr_product_result <- map_df(pctr_job$file_product, read_rds)
# pctr_product_result
# # TODO: `... |> write_csv("/path/to/output/pctr_product_result.csv")`
#
# pctr_company_result <- map_df(pctr_job$file_company, read_rds)
# pctr_company_result
# # TODO: `... |> write_csv("/path/to/output/pctr_company_result.csv")`
#
# # Each chunk result was saved to a file
# dir_tree(cache_path("pctr/product"))
# dir_tree(cache_path("pctr/company"))
