test_that("run_ps_biomarker_pipeline returns expected outputs", {
  skip_if_not_installed("phyloseq")
  skip_if_not_installed("randomForest")
  skip_if_not_installed("ggplot2")

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

  res <- run_ps_biomarker_pipeline(
    ps = ps,
    group = "group",
    prevalence = 0,
    transform = "relative_abundance",
    method = "rf",
    top_n = 3,
    ntree = 50,
    seed = 1
  )

  expect_type(res, "list")
  expect_true(all(c("ps_processed", "model", "ranked_taxa", "plot") %in% names(res)))
  expect_s4_class(res$ps_processed, "phyloseq")
  expect_s3_class(res$model, "randomForest")
  expect_s3_class(res$ranked_taxa, "data.frame")
  expect_s3_class(res$plot, "ggplot")
  expect_lte(nrow(res$ranked_taxa), 3)
})
