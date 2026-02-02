#' Extract a candidate vehicle make prefix
#'
#' Extracts a short prefix from a free-text vehicle description that is likely
#' to correspond to the vehicle make. The extraction is intentionally
#' conservative and is designed to operate prior to approximate matching.
#'
#' The function:
#' \itemize{
#'   \item standardises text for comparison,
#'   \item removes trailing content beginning with numeric tokens (e.g. model
#'         numbers or engine sizes),
#'   \item returns at most the first three whitespace-separated tokens.
#' }
#'
#' This helper does not attempt to identify the correct make on its own; it
#' merely produces a plausible candidate for downstream matching logic.
#'
#' @param x A single character string containing a vehicle description.
#'
#' @return A character string representing a candidate make prefix.
#'
#' @examples
#' extract_make_candidate("ALFA ROMEO GIULIETTA 1.4")
#' extract_make_candidate("ABARTH 1000SP L/H/D")
#'
#' @keywords internal
extract_make_candidate <- function(x) {
  x <- standardise_text(x)
  # stop at first digit
  x <- sub("\\s*[0-9].*$", "", x)
  # keep at most first 3 tokens
  tokens <- strsplit(x, " ")[[1]]
  paste(tokens[1:min(3, length(tokens))], collapse = " ")
}
