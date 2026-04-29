#' Preprocess a phyloseq object for biomarker analysis
#'
#' Filter low-prevalence taxa and optionally transform counts.
#'
#' @param ps A `phyloseq` object.
#' @param prevalence Minimum prevalence required to keep a taxon, as a proportion of samples.
#' @param transform Character. One of `"relative_abundance"`, `"log1p"`, or `"none"`.
#'
#' @return A processed `phyloseq` object.
#' @export
prep_ps_biomarker <- function(ps, prevalence = 0.1,
                              transform = c("relative_abundance", "log1p", "none")) {
  transform <- match.arg(transform)
  stopifnot(inherits(ps, "phyloseq"))

  otu <- as(phyloseq::otu_table(ps), "matrix")
  if (phyloseq::taxa_are_rows(ps)) {
    prev <- rowMeans(otu > 0)
    keep <- names(prev)[prev >= prevalence]
  } else {
    prev <- colMeans(otu > 0)
    keep <- names(prev)[prev >= prevalence]
  }

  ps <- phyloseq::prune_taxa(keep, ps)

  if (transform == "relative_abundance") {
    ps <- phyloseq::transform_sample_counts(ps, function(x) x / sum(x))
  } else if (transform == "log1p") {
    ps <- phyloseq::transform_sample_counts(ps, function(x) log1p(x))
  }

  ps
}


#' Preprocess a phyloseq object for biomarker analysis
#'
#' Filter low-prevalence taxa and optionally transform counts.
#'
#' @param ps A `phyloseq` object.
#' @param prevalence Minimum prevalence required to keep a taxon, as a proportion of samples.
#' @param transform Character. One of `"relative_abundance"`, `"log1p"`, or `"none"`.
#'
#' @return A processed `phyloseq` object.
#' @export
prep_ps_biomarker <- function(ps, prevalence = 0.1,
                              transform = c("relative_abundance", "log1p", "none")) {
  transform <- match.arg(transform)
  stopifnot(inherits(ps, "phyloseq"))

  otu <- as(phyloseq::otu_table(ps), "matrix")

  if (phyloseq::taxa_are_rows(ps)) {
    prev <- rowMeans(otu > 0)
    keep <- names(prev)[prev >= prevalence]
  } else {
    prev <- colMeans(otu > 0)
    keep <- names(prev)[prev >= prevalence]
  }

  ps <- phyloseq::prune_taxa(keep, ps)

  if (transform == "relative_abundance") {
    ps <- phyloseq::transform_sample_counts(ps, function(x) x / sum(x))
  } else if (transform == "log1p") {
    ps <- phyloseq::transform_sample_counts(ps, function(x) log1p(x))
  }

  ps
}
