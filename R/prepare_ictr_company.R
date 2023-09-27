#' Creates final output of ictr company level results
#'
#' @param match_mapper A dataframe like [matches_mapper]
#' @param eco_activities A dataframe like [ecoinvent_activities]
#' @param ictr_prod A dataframe like [ictr_product]
#' @param comp A dataframe like [ep_companies]
#' @param ictr_comp A dataframe like [ictr_company]
#' @param eco_inputs A dataframe like [ecoinvent_inputs]
#' @param isic_tilt_map A dataframe like [isic_tilt_mapper]
#'
#' @return A dataframe that prepares the final output of ictr_company
#'
#' @export
#'
#' @examples
#' prepare_ictr_company(
#'   ictr_company |> head(3),
#'   ictr_product |> head(3),
#'   ep_companies |> head(3),
#'   ecoinvent_activities |> head(3),
#'   matches_mapper |> head(3),
#'   ecoinvent_inputs |> head(3),
#'   isic_tilt_mapper |> head(3)
#' )
prepare_ictr_company <- function(ictr_comp, ictr_prod, comp, eco_activities, match_mapper, eco_inputs, isic_tilt_map) {
  ictr_prod <- sanitize_isic(ictr_prod)

  inter_result <- prepare_ictr_product(ictr_prod, comp, eco_activities, match_mapper, eco_inputs, isic_tilt_map) |>
    select(
      "companies_id", "company_name", "company_city", "country", "postcode",
      "address", "main_activity", "matching_certainty_company_average"
    ) |>
    distinct()

  ictr_comp |>
    left_join(inter_result, by = "companies_id") |>
    rename_ictr_company() |>
    # To check: here ICTR_share is used instead of matching_certainty_company_average
    mutate(
      benchmark = ifelse(is.na(.data$ICTR_share), NA, .data$benchmark),
      ICTR_risk_category = ifelse(is.na(.data$ICTR_share), NA, .data$ICTR_risk_category)
    ) |>
    relocate_ictr_company() |>
    arrange(.data$companies_id) |>
    distinct()
}

rename_ictr_company <- function(data) {
  data |>
    rename(
      ICTR_risk_category = "risk_category",
      benchmark = "grouped_by",
      ICTR_share = "value"
    )
}

relocate_ictr_company <- function(data) {
  data |>
    relocate(
      "companies_id", "company_name", "company_city", "country", "ICTR_share",
      "ICTR_risk_category", "benchmark", "matching_certainty_company_average",
      "postcode", "address", "main_activity"
    )
}
