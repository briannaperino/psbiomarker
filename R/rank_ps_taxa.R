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

  name_map <- attr(model, "taxa_name_map")

  if (method == "rf") {
    imp <- randomForest::importance(model)
    imp <- as.data.frame(imp)
    imp$clean <- rownames(imp)
    score_col <- if ("MeanDecreaseAccuracy" %in% names(imp)) {
      "MeanDecreaseAccuracy"
    } else {
      names(imp)[1]
    }
    out <- imp[, c("clean", score_col), drop = FALSE]
    names(out)[2] <- "importance"
  } else {
    coefs <- stats::coef(summary(model))
    coefs <- coefs[rownames(coefs) != "(Intercept)", , drop = FALSE]
    out <- data.frame(
      clean = rownames(coefs),
      importance = abs(coefs[, "Estimate"]),
      estimate = coefs[, "Estimate"],
      p_value = coefs[, "Pr(>|z|)"],
      row.names = NULL
    )
  }

  if (!is.null(name_map)) {
    out <- merge(out, name_map, by = "clean", all.x = TRUE, sort = FALSE)
    out$taxa <- ifelse(is.na(out$original), out$clean, out$original)
  } else {
    out$taxa <- out$clean
  }

  out <- out[order(-out$importance), , drop = FALSE]
  out <- out[, c("taxa", setdiff(names(out), c("taxa", "original"))), drop = FALSE]
  utils::head(out, top_n)
}
