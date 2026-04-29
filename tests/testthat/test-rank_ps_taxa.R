test_that("rank_ps_taxa ranks random forest taxa", {
  skip_if_not_installed("phyloseq")
  skip_if_not_installed("randomForest")

  otu <- matrix(
    c(10, 0, 0, 5,
      3,  2, 0, 0,
      0,  1, 4, 0,
      2,  1, 0, 3),
    nrow = 4,
    byrow = TRUE
  )
  rownames(otu) <- c("Tax1", "Tax2", "Tax3", "Tax4")
  colnames(otu) <- c("S1", "S2", "S3", "S4")

  ps <- phyloseq::phyloseq(
    phyloseq::otu_table(otu, taxa_are_rows = TRUE),
    phyloseq::sample_data(data.frame(
      group = c("A", "A", "B", "B"),
      row.names = colnames(otu)
    ))
  )

  ps2 <- prep_ps_biomarker(ps, prevalence = 0, transform = "relative_abundance")
  rf_model <- fit_ps_biomarker_model(ps2, group = "group", method = "rf", ntree = 50, seed = 1)

  ranked <- rank_ps_taxa(rf_model, method = "rf", top_n = 3)

  expect_s3_class(ranked, "data.frame")
  expect_true(all(c("taxa", "importance") %in% names(ranked)))
  expect_lte(nrow(ranked), 3)
  expect_true(is.character(ranked$taxa))
})

test_that("rank_ps_taxa ranks logistic regression taxa", {
  skip_if_not_installed("phyloseq")
  skip_if_not_installed("randomForest")

  otu <- matrix(
    c(10, 0, 0, 5,
      3,  2, 0, 0,
      0,  1, 4, 0,
      2,  1, 0, 3),
    nrow = 4,
    byrow = TRUE
  )
  rownames(otu) <- c("Tax1", "Tax2", "Tax3", "Tax4")
  colnames(otu) <- c("S1", "S2", "S3", "S4")

  ps <- phyloseq::phyloseq(
    phyloseq::otu_table(otu, taxa_are_rows = TRUE),
    phyloseq::sample_data(data.frame(
      group = c("A", "A", "B", "B"),
      row.names = colnames(otu)
    ))
  )

  ps2 <- prep_ps_biomarker(ps, prevalence = 0, transform = "relative_abundance")
  glm_model <- fit_ps_biomarker_model(ps2, group = "group", method = "logistic")

  ranked <- rank_ps_taxa(glm_model, method = "logistic", top_n = 3)

  expect_s3_class(ranked, "data.frame")
  expect_true(all(c("taxa", "importance", "estimate", "p_value") %in% names(ranked)))
  expect_lte(nrow(ranked), 3)
  expect_true(all(ranked$importance >= 0))
})
