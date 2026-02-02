#' Standardise vehicle text for matching
#'
#' Converts free-text vehicle descriptions into a standardised form suitable
#' for deterministic and fuzzy matching. The function uppercases text, removes
#' non-alphanumeric characters, collapses repeated whitespace, and trims
#' leading/trailing spaces.
#'
#' This function does **not** attempt to correct spelling, infer makes or models,
#' or change semantic content. It exists solely to make text comparable.
#'
#' @param x A character vector of vehicle makes or descriptions.
#'
#' @return A character vector of the same length as \code{x}, containing
#'   standardised text.
#'
#' @examples
#' standardise_text("ALFA-ROMEO  147 T-SPARK")
#' standardise_text("A C  COBRA")
#'
#' @export
standardise_text <- function(x) {
  x %>%
    toupper() %>%
    gsub("[^A-Z0-9 ]", " ", x = .) %>%
    gsub("\\s+", " ", x = .) %>%
    trimws()
}
