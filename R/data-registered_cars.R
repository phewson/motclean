# Internal data do not export
#' Registered vehicle reference data (internal)
#'
#' Internal reference table of registered vehicle makes and models used to
#' support vehicle make and model matching.
#'
#' The data are derived from official UK vehicle licensing statistics published
#' by the Driver and Vehicle Licensing Agency (DVLA).
#'
#' Source:
#' \url{https://www.gov.uk/government/statistical-data-sets/vehicle-licensing-statistics-data-tables}
#'
#' reg_cars <- read.csv("~/DATA/dft/veh_stats/df_VEH0120_UK.csv")
#'
#' registered_cars <- reg_cars %>%
#'    filter(BodyType == "Cars") %>%
#'    group_by(Make) %>%
#'    summarise(n_registered = sum(X2023Q4)) %>%
#'    rename(make = "Make")
#'
#' The data have been transformed and reduced for use within this package and
#' do not represent the full published dataset.
#'
#' @docType data
#' @keywords internal
#' @usage NULL
"registered_cars"
