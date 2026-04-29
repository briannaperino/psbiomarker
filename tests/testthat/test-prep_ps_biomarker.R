test_that("prep_ps_biomarker filters and transforms a phyloseq object", {
  skip_if_not_installed("phyloseq")

  otu <- matrix(
    c(10, 0, 0, 5,
      3,  2, 0, 0,
      0,  1, 4, 0),
    nrow = 3,
    byrow = TRUE
  )
  rownames(otu) <- c("Tax1", "Tax2", "Tax3")
  colnames(otu) <- c("S1", "S2", "S3", "S4")

  ps <- phyloseq::phyloseq(
    phyloseq::otu_table(otu, taxa_are_rows = TRUE),
    phyloseq::sample_data(data.frame(
      group = c("A", "A", "B", "B"),
      row.names = colnames(otu)
    ))
  )

  res <- prep_ps_biomarker(ps, prevalence = 0.5, transform = "relative_abundance")
  mat <- as(phyloseq::otu_table(res), "matrix")

  expect_s4_class(res, "phyloseq")
  expect_true("Tax1" %in% rownames(mat))
  expect_true(all(mat >= 0))
})
