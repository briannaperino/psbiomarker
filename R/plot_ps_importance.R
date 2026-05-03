#' Plot top biomarker taxa
#'
#' @param ranked_taxa Output from `rank_ps_taxa()`.
#' @param top_n Number of top taxa to plot.
#'
#' @return A `ggplot` object.
#' @export
plot_ps_importance <- function(ranked_taxa, top_n = 20) {
  df <- utils::head(ranked_taxa, top_n)

  df$taxa <- factor(df$taxa, levels = rev(df$taxa))

  ggplot2::ggplot(df, ggplot2::aes(x = taxa, y = importance)) +
    ggplot2::geom_col(fill = "#2C7FB8") +
    ggplot2::coord_flip() +
    ggplot2::labs(x = NULL, y = "Importance") +
    ggplot2::theme_minimal()
}
