#' @keywords internal
psbiomarker_validate_binary_group <- function(x) {
  if (length(unique(stats::na.omit(x))) != 2) {
    stop("`group` must be binary for logistic regression.")
  }
  invisible(TRUE)
}
