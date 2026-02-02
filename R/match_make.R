#' Match vehicle makes from noisy text
#'
#' Attempts to identify a canonical vehicle make from a noisy free-text
#' description. Matching is performed using progressive prefix extraction,
#' approximate string distance, and conservative acceptance thresholds.
#'
#' The function returns both a matched make and a match status:
#' \itemize{
#'   \item \code{ACCEPT}: high-confidence automatic match
#'   \item \code{REVIEW}: plausible match requiring review
#'   \item \code{REJECT}: no suitable match (classified as \code{OTHER})
#' }
#'
#' The matcher is deliberately conservative: it prefers rejection over
#' misclassification and is designed to leave rare vehicles, kit cars,
#' imports, and malformed records unmatched.
#'
#' @param x A character vector containing vehicle make and model text.
#' @param strict Maximum string distance for automatic acceptance.
#' @param loose Maximum string distance for review-level matches.
#' @param min_mot Minimum frequency threshold used to distinguish common
#'   vehicles from rare or anomalous entries.
#'
#' @return A character matrix with two rows:
#'   \describe{
#'     \item{make}{Matched canonical make, or \code{"OTHER"}}
#'     \item{status}{One of \code{"ACCEPT"}, \code{"REVIEW"},
#'                   or \code{"REJECT"}}
#'   }
#'
#' @examples
#' \dontrun{
#' match_make("ALFA RAMEO GIULIETTA 1.4")
#' match_make("A C COBRA")
#' match_make("KIT CAR SPECIAL")
#' }
#' @export
#' @importFrom stringdist stringdist
match_make <- function(x, strict = 0.08, loose = 0.15, min_mot = 5) {
  make_dictionary <- registered_cars  # internal dataset

  cand <- extract_make_candidate(x)
  cand <- collapse_initials(cand)
  if (grepl("\\b(REPLICA|KIT|TRIBUTE)\\b", cand)) {
    return(c(make_clean = "OTHER", status = "REJECT"))
  }
  dict2 <- make_dictionary[substr(make_dictionary$make, 1, 1) ==
                             substr(cand, 1, 1), ]
  if (nrow(dict2) == 0) {
    return(c(make_clean = "OTHER", status = "REJECT"))
  }
  words <- strsplit(cand, " ")[[1]]
  dict_tokens <- strsplit(dict2$make, " ")
  best <- NULL
  for (k in seq_len(min(3, length(words)))) {
    prefix <- paste(words[1:k], collapse = " ")
    d <- stringdist::stringdist(prefix, dict2$make, method = "jw")
    if (k == 2) {
      second_word <- words[2]
      second_d <- vapply(dict_tokens, function(tok) {
        if (length(tok) >= 2)
          stringdist::stringdist(second_word, tok[2], method = "jw")
        else
          Inf
      }, numeric(1))
      d <- pmin(d, second_d)
    }

    i <- which.min(d)

    if (d[i] <= loose) {
      best <- list(
        make = dict2$make[i],
        dist = d[i],
        n_registered = dict2$n_registered[i]
      )
      break
    }
  }
  if (is.null(best)) {
    return(c(make_clean = "OTHER", status = "REJECT"))
  }
  if (best$dist <= strict && best$n_registered >= min_mot) {
    return(c(make_clean = best$make, status = "ACCEPT"))
  }
  return(c(make_clean = best$make, status = "REVIEW"))
}
