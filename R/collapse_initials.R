#' Collapse spaced single-letter initials
#'
#' Collapses adjacent single-letter tokens separated by whitespace into a
#' single token. This is primarily used to handle vehicle makes written as
#' spaced initials (e.g. \code{"A C"} → \code{"AC"}, \code{"B M W"} to
#' \code{"BMW"}).
#'
#' The function operates purely at the character level and does not attempt to
#' validate or interpret the resulting token.
#'
#' @param x A character vector.
#'
#' @return A character vector of the same length as \code{x}, with spaced
#'   initials collapsed where detected.
#'
#' @examples
#' \dontrun
#' collapse_initials("A C COBRA")
#' collapse_initials("B M W 320")
#' }
#'
#' @keywords internal
collapse_initials <- function(x) {
  words <- strsplit(x, " ")[[1]]
  result <- character(0)
  buffer <- ""
  for (i in seq_along(words)) {
    w <- words[i]
    if (grepl("^[0-9]", w)) {
      # Word starts with a number → flush buffer and add the rest unchanged
      if (buffer != "") result <- c(result, buffer)
      result <- c(result, words[i:length(words)])
      break
    } else if (grepl("^[A-Z]$", w)) {
      # Single uppercase letter → add to buffer
      buffer <- paste0(buffer, w)
    } else {
      # Other words → flush buffer and add word
      if (buffer != "") result <- c(result, buffer)
      result <- c(result, w)
      buffer <- ""
    }
  }
  # Flush any remaining buffer if no number found
  if (buffer != "" && length(result) == 0) {
    result <- buffer
  }
  paste(result, collapse = " ")
}
