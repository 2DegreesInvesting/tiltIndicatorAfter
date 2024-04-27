#' Profile sector and upstream sector
#'
#' These functions wrap the output of the corresponding function in
#' [tiltIndicator](https://2degreesinvesting.github.io/tiltIndicator/reference/index.html).
#'
#' @inheritParams tiltIndicator::sector_profile_upstream
#' @param europages_companies Dataframe. Companies from europages.
#' @param ecoinvent_activities Dataframe. Activities from ecoinvent.
#' @param ecoinvent_inputs Dataframe. Upstream products from ecoinvent.
#' @param ecoinvent_europages Dataframe. Mapper between europages and ecoinvent.
#' @param isic Dataframe. ISIC data.
#' @param isic_tilt `r lifecycle::badge("deprecated")`
#'
#' @return `r document_tilt_profile()`
#' @export
#'
#' @family top-level functions
#'
#' @examples
#' library(tiltToyData)
#' library(readr, warn.conflicts = FALSE)
#'
#' restore <- options(readr.show_col_types = FALSE)
#'
#' companies <- read_csv(toy_sector_profile_companies())
#' scenarios <- read_csv(toy_sector_profile_any_scenarios())
#' europages_companies <- read_csv(toy_europages_companies()) |> head(3)
#' ecoinvent_activities <- read_csv(toy_ecoinvent_activities()) |> head(3)
#' ecoinvent_europages <- read_csv(toy_ecoinvent_europages()) |> head(3)
#' isic_name <- read_csv(toy_isic_name()) |> head(3)
#'
#' result <- profile_sector(
#'   companies,
#'   scenarios,
#'   europages_companies = europages_companies,
#'   ecoinvent_activities = ecoinvent_activities,
#'   ecoinvent_europages = ecoinvent_europages,
#'   isic = isic_name
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
#' europages_companies <- read_csv(toy_europages_companies()) |> head(3)
#' ecoinvent_activities <- read_csv(toy_ecoinvent_activities()) |> head(3)
#' ecoinvent_inputs <- read_csv(toy_ecoinvent_inputs()) |> head(3)
#' ecoinvent_europages <- read_csv(toy_ecoinvent_europages()) |> head(3)
#' isic_name <- read_csv(toy_isic_name()) |> head(3)
#'
#' result <- profile_sector_upstream(
#'   companies,
#'   scenarios,
#'   inputs,
#'   europages_companies = europages_companies,
#'   ecoinvent_activities = ecoinvent_activities,
#'   ecoinvent_inputs = ecoinvent_inputs,
#'   ecoinvent_europages = ecoinvent_europages,
#'   isic = isic_name
#' )
#'
#' result |> unnest_product()
#'
#' result |> unnest_company()
#'
#' # Cleanup
#' options(restore)
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
  profile_sector_upstream_impl(
    companies = companies,
    scenarios = scenarios,
    inputs = inputs,
    europages_companies = europages_companies,
    ecoinvent_activities = ecoinvent_activities,
    ecoinvent_inputs = ecoinvent_inputs,
    ecoinvent_europages = ecoinvent_europages,
    isic = isic,
    isic_tilt = isic_tilt,
    low_threshold = low_threshold,
    high_threshold = high_threshold
  )
}

#' @rdname profile_impl
#' @export
#' @keywords internal
profile_sector_upstream_impl <- function(companies,
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
  exec_profile("sector_profile_upstream", indicator, indicator_after) |>
    tilt_profile()
}
