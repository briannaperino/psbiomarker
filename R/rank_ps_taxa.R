#' Rank taxa by model importance
#'
#' Convert model output into a ranked taxa table.
#'
#' @param model A fitted model from `fit_ps_biomarker_model()`.
#' @param method Character. `"rf"` or `"logistic"`.
#' @param top_n Number of top taxa to return.
#'
#' @return A data.frame of ranked taxa.
#' @export
rank_ps_taxa <- function(model, method = c("rf", "logistic"), top_n = 20) {
  method <- match.arg(method)

  if (method == "rf") {
    imp <- randomForest::importance(model)
    imp <- as.data.frame(imp)
    imp$taxa <- rownames(imp)
    score_col <- if ("MeanDecreaseAccuracy" %in% names(imp)) "MeanDecreaseAccuracy" else names(imp)[1]
    out <- imp[, c("taxa", score_col), drop = FALSE]
    names(out)[2] <- "importance"
  } else {
    coefs <- stats::coef(summary(model))
    coefs <- coefs[rownames(coefs) != "(Intercept)", , drop = FALSE]
    out <- data.frame(
      taxa = rownames(coefs),
      importance = abs(coefs[, "Estimate"]),
      estimate = coefs[, "Estimate"],
      p_value = coefs[, "Pr(>|z|)"],
      row.names = NULL
    )
  }

  out <- out[order(-out$importance), , drop = FALSE]
  utils::head(out, top_n)
}
