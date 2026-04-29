test_that("fit_ps_biomarker_model fits random forest and logistic models", {
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
  glm_model <- fit_ps_biomarker_model(ps2, group = "group", method = "logistic")

  expect_s3_class(rf_model, "randomForest")
  expect_s3_class(glm_model, "glm")
})

test_that("fit_ps_biomarker_model errors when group is missing", {
  skip_if_not_installed("phyloseq")

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

  expect_error(
    fit_ps_biomarker_model(ps, group = "missing_column", method = "rf"),
    "not found"
  )
})
