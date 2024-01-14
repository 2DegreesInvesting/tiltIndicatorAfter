#' Profile sector and upstream sector
#'
#' @inherit profile_emissions_upstream
#' @inheritParams tiltIndicator::sector_profile_upstream
#'
#' @family top-level functions
#'
#' @export
#'
#' @examples
#' library(tiltToyData)
#' library(readr, warn.conflicts = FALSE)
#'
#' options(readr.show_col_types = FALSE)
#'
#' companies <- read_csv(toy_sector_profile_companies())
#' scenarios <- read_csv(toy_sector_profile_any_scenarios())
#'
#' result <- profile_sector(
#'   companies,
#'   scenarios,
#'   # TODO: Move to tiltToyData
#'   europages_companies = read_csv(toy_europages_companies()) |> head(3),
#'   ecoinvent_activities = read_csv(toy_ecoinvent_activities()) |> head(3),
#'   ecoinvent_europages = matches_mapper |> head(3),
#'   isic = isic_name |> head(3)
#' )
#'
#' result |> unnest_product()
#'
#' result |> unnest_company()
#'
#'
#'
#' companies <- read_csv(toy_sector_profile_upstream_companies())
#' scenarios <- read_csv(toy_sector_profile_any_scenarios())
#' inputs <- read_csv(toy_sector_profile_upstream_products())
#' ecoinvent_inputs <- read_csv(toy_ecoinvent_inputs()) |> head(3)
#'
#' result <- profile_sector_upstream(
#'   companies,
#'   scenarios,
#'   inputs,
#'   # TODO: Move to tiltToyData
#'   europages_companies = read_csv(toy_europages_companies()) |> head(3),
#'   ecoinvent_activities = read_csv(toy_ecoinvent_activities()) |> head(3),
#'   ecoinvent_inputs = read_csv(toy_ecoinvent_inputs()) |> head(3),
#'   ecoinvent_europages = matches_mapper |> head(3),
#'   isic = isic_name |> head(3)
#' )
#'
#' result |> unnest_product()
#'
#' result |> unnest_company()
profile_sector_upstream <- function(companies,
                                    scenarios,
                                    inputs,
                                    europages_companies,
                                    ecoinvent_activities,
                                    ecoinvent_inputs,
                                    ecoinvent_europages,
                                    isic,
                                    isic_tilt = lifecycle::deprecated(),
                                    low_threshold = ifelse(scenarios$year == 2030, 1 / 9, 1 / 3),
                                    high_threshold = ifelse(scenarios$year == 2030, 2 / 9, 2 / 3)) {
  if (lifecycle::is_present(isic_tilt)) {
    lifecycle::deprecate_warn(
      "0.0.0.9017",
      "profile_sector_upstream(isic_tilt)",
      "profile_sector_upstream(isic)"
    )
    isic <- isic_tilt
  }

  europages_companies <- select_europages_companies(europages_companies)
  ecoinvent_inputs <- select_ecoinvent_inputs(ecoinvent_inputs)

  indicator <- list(
    companies,
    scenarios,
    add_rowid(inputs),
    low_threshold,
    high_threshold
  )
  indicator_after <- list(
    europages_companies,
    ecoinvent_activities,
    ecoinvent_europages,
    ecoinvent_inputs,
    isic
  )
  exec_profile("sector_profile_upstream", indicator, indicator_after)
}
