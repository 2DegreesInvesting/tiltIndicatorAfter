#' Add transition risk score and polish the output for delivery
#'
#' @param emissions_profile The output of [emissions_profile()].
#' @param sector_profile The output of [sector_profile()].
#' @param pivot_wider Pivot the output at company level to a wide format?
#'
#' @return A data frame with the column `companies_id`, and the nested
#'   columns`product` and `company` holding the outputs at product and company
#'   level.
#' @export
#' @keywords internal
#'
#' @examples
#' library(readr, warn.conflicts = FALSE)
#' library(dplyr, warn.conflicts = FALSE)
#' library(tiltToyData)
#' withr::local_options(readr.show_col_types = FALSE)
#'
#' toy_emissions_profile_products_ecoinvent <- read_csv(toy_emissions_profile_products_ecoinvent())
#' toy_emissions_profile_any_companies <- read_csv(toy_emissions_profile_any_companies())
#' toy_sector_profile_any_scenarios <- read_csv(toy_sector_profile_any_scenarios())
#' toy_sector_profile_companies <- read_csv(toy_sector_profile_companies())
#' toy_europages_companies <- read_csv(toy_europages_companies())
#' toy_ecoinvent_activities <- read_csv(toy_ecoinvent_activities())
#' toy_ecoinvent_europages <- read_csv(toy_ecoinvent_europages())
#' toy_ecoinvent_inputs <- read_csv(toy_ecoinvent_inputs())
#' toy_isic_name <- read_csv(toy_isic_name())
#'
#' emissions_profile <- profile_emissions(
#'   companies = toy_emissions_profile_any_companies,
#'   co2 = toy_emissions_profile_products_ecoinvent,
#'   europages_companies = toy_europages_companies,
#'   ecoinvent_activities = toy_ecoinvent_activities,
#'   ecoinvent_europages = toy_ecoinvent_europages,
#'   isic = toy_isic_name)
#'
#'  # FIXME Use options to output co2_footprint and co2_avg
#'  emissions_profile$product <- emissions_profile$product |>
#'    lapply(mutate, co2_footprint = 1)
#'  emissions_profile$company <- emissions_profile$product |>
#'    lapply(mutate, co2_avg = 1)
#'
#' sector_profile <- profile_sector(
#'   companies = toy_sector_profile_companies,
#'   scenarios = toy_sector_profile_any_scenarios,
#'   europages_companies = toy_europages_companies,
#'   ecoinvent_activities = toy_ecoinvent_activities,
#'   ecoinvent_europages = toy_ecoinvent_europages,
#'   isic = toy_isic_name)
#'
#' result <- score_transition_risk_and_polish(emissions_profile, sector_profile)
#' result |> unnest_product()
#' result |> unnest_company()
#'
#' # Some banks need a wide format for the output at company level
#' # FIXME: Why this fails?
#' try(score_transition_risk_and_polish(
#'   emissions_profile,
#'   sector_profile,
#'   pivot_wider = TRUE
#'  ))
score_transition_risk_and_polish <- function(emissions_profile, sector_profile, pivot_wider = FALSE) {
  emissions_profile_at_product_level <- unnest_product(emissions_profile)
  emissions_profile_at_company_level <- unnest_company(emissions_profile)
  # sector_profile_at_product_level <- read_csv("xx-sector-profile/sector_profile_at_product_level.csv")
  sector_profile_at_product_level <- unnest_product(sector_profile)
  # sector_profile_at_company_level <- read_csv("xx-sector-profile/sector_profile_at_company_level.csv")
  sector_profile_at_company_level <- unnest_company(sector_profile)

  # New stuff starts here -----------------------------------------------------

  transition_risk_score <- score_transition_risk(emissions_profile_at_product_level, sector_profile_at_product_level)
  transition_risk_score_at_product_level <- unnest_product(transition_risk_score)
  transition_risk_score_at_company_level <- unnest_company(transition_risk_score)

  select_emissions_profile_at_product_level <- emissions_profile_at_product_level |>
    select(
      c(
        "companies_id",
        "country",
        "main_activity",
        "ep_product",
        "activity_uuid_product_uuid",
        "matched_activity_name",
        "matched_reference_product",
        "unit",
        "co2e_lower",
        "co2e_upper",
        "emission_profile",
        "benchmark",
        "profile_ranking",
        "tilt_sector",
        "tilt_subsector",
        "co2_footprint"
      )
    )
  select_sector_profile_at_product_level <- sector_profile_at_product_level |>
    select(
      c(
        "companies_id",
        "ep_product",
        "sector_profile",
        "scenario",
        "year",
        "reduction_targets"
      )
    )

  select_transition_risk_score_at_product_level <- transition_risk_score_at_product_level |>
    select(c(
      "companies_id",
      "ep_product",
      "benchmark_tr_score",
      "transition_risk_score"
    ))

  bundesbank_data_at_product_level <- select_emissions_profile_at_product_level |>
    left_join(
      select_sector_profile_at_product_level,
      relationship = "many-to-many",
      by = c("companies_id", "ep_product")
    ) |>
    mutate(benchmark_tr_score = paste(scenario, year, benchmark, sep = "_")) |>
    left_join(select_transition_risk_score_at_product_level, by = c("companies_id", "ep_product", "benchmark_tr_score")) |>
    distinct()
    # TODO: `europages_companies` should include headcount. tiltIndicatorBefore
    # left_join(headcount, by = c("companies_id")) |>
    # This is specific to the latest bundesbank delivery
    # filter(country == "germany", benchmark %in% c("unit", "unit_tilt_sector") | is.na(benchmark))




  select_emissions_profile_at_company_level <- emissions_profile_at_company_level |>
    select(
      c(
        "companies_id",
        "country",
        "main_activity",
        "co2e_lower",
        "co2e_upper",
        "benchmark",
        "emission_profile",
        matches("emission_profile_share"),
        matches("profile_ranking_avg"),
        "co2_avg"
      )
    )

  select_sector_profile_at_company_level <- sector_profile_at_company_level |>
    select(c("companies_id", "scenario", "year", "reduction_targets_avg"))

  select_transition_risk_score_at_company_level <- transition_risk_score_at_company_level |>
    select(
      c(
        "companies_id",
        # `benchmark_tr_score` was renamed to `benchmark_tr_score_avg`
        # https://2degreesinvesting.github.io/tiltIndicatorAfter/news/index.html#tiltindicatorafter-0009026-2024-04-04
        matches("benchmark_tr_score"),
        "transition_risk_score_avg"
      )
    )

  tmp <- select_emissions_profile_at_company_level
  if (pivot_wider) {
    tmp <- tmp |>
      # FIXME: Run this conditionally since it's only necessary for Bunedesbank
      exclude_cols_then_pivot_wider(
        exclude_cols = "co2e",
        id_cols = c(
          companies_id,
          country,
          main_activity,
          benchmark,
          profile_ranking_avg,
          co2_avg
        ),
        names_from = emission_profile,
        names_prefix = "emission_category_",
        values_from = emission_profile_share
      )
  }
  bundesbank_data_at_company_level <- tmp |>
    left_join(
      select_sector_profile_at_company_level,
      relationship = "many-to-many",
      by = c("companies_id")
    ) |>
    mutate(benchmark_tr_score_avg = paste(scenario, year, benchmark, sep = "_")) |>
    left_join(select_transition_risk_score_at_company_level, by = c("companies_id", "benchmark_tr_score_avg")) |>
    distinct()
    # TODO: `europages_companies` should include headcount. tiltIndicatorBefore
    # left_join(headcount, by = c("companies_id")) |>
    # This is specific to the latest bundesbank delivery
    # filter(country == "germany", benchmark %in% c("all", "unit_tilt_sector"))

  nest_levels(
    bundesbank_data_at_product_level,
    bundesbank_data_at_company_level
  )
}

