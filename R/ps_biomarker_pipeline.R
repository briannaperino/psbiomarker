#' Run the full biomarker pipeline
#'
#' @param ps A `phyloseq` object.
#' @param group Name of the sample_data column with the outcome variable.
#' @param prevalence Minimum prevalence threshold.
#' @param transform Transformation choice.
#' @param method Biomarker model: `"rf"` or `"logistic"`.
#' @param top_n Number of top taxa to return and plot.
#' @param ntree Number of trees for random forest.
#' @param seed Random seed.
#'
#' @return A list with processed data, model, ranked taxa, and plot.
#' @export
run_ps_biomarker_pipeline <- function(ps, group,
                                      prevalence = 0.1,
                                      transform = c("relative_abundance", "log1p", "none"),
                                      method = c("rf", "logistic"),
                                      top_n = 20,
                                      ntree = 500,
                                      seed = 1) {
  transform <- match.arg(transform)
  method <- match.arg(method)

  ps_processed <- prep_ps_biomarker(
    ps = ps,
    prevalence = prevalence,
    transform = transform
  )

  model <- fit_ps_biomarker_model(
    ps = ps_processed,
    group = group,
    method = method,
    ntree = ntree,
    seed = seed
  )

  ranked_taxa <- rank_ps_taxa(model, method = method, top_n = top_n)
  plot <- plot_ps_importance(ranked_taxa, top_n = top_n)

  list(
    ps_processed = ps_processed,
    model = model,
    ranked_taxa = ranked_taxa,
    plot = plot
  )
}
