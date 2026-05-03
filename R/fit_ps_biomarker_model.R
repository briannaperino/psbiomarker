#' Fit a biomarker classification model
#'
#' Fit either a random forest or logistic regression model using taxa as predictors.
#'
#' @param ps A `phyloseq` object.
#' @param group Name of the `sample_data(ps)` column to use as the outcome variable.
#' @param method Character. One of `"rf"` or `"logistic"`.
#' @param ntree Number of trees for random forest.
#' @param seed Random seed used for random forest.
#'
#' @return A fitted model object.
#' @export
fit_ps_biomarker_model <- function(ps, group,
                                   method = c("rf", "logistic"),
                                   ntree = 500, seed = 1) {
  method <- match.arg(method)
  stopifnot(inherits(ps, "phyloseq"))

  meta <- as.data.frame(phyloseq::sample_data(ps))
  if (!group %in% names(meta)) stop("`group` not found in sample_data(ps).")

  x <- as.data.frame(t(as.matrix(phyloseq::otu_table(ps))))
  colnames(x) <- make.names(colnames(x), unique = TRUE)

  dat <- cbind(y = meta[[group]], x)
  dat <- dat[stats::complete.cases(dat), , drop = FALSE]
  dat$y <- as.factor(dat$y)

  if (method == "rf") {
    set.seed(seed)
    randomForest::randomForest(y ~ ., data = dat, ntree = ntree, importance = TRUE)
  } else {
    stats::glm(y ~ ., data = dat, family = stats::binomial())
  }
}
