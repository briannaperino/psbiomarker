
# psbiomarker <img src="man/figures/logo.png" align="right" height="140"/>

**Biomarker discovery from phyloseq objects using random forest or
logistic regression.**

### psbiomarker is an R package focused on microbiome biomarker discovery that works directly with phyloseq objects. It filters low-abundant taxa, transforms counts, rarefys reads, and fits random forest models. The package also ranks the taxa by importance and generates plots to visualize. All of the tasks, phyloseq filtering, ranking and plots, are coompleted within the package pipeline. This package is compatible with 16s 18s, ITS and 28s rRNA. psbiomarker is designed to streamline the process of identifying phenotype-associated microbial signatures using the established data structure of pyhloseq.

## Workflow

1. **Preprocess** with `prep_ps_biomarker()` (filter taxa, transform counts)
2. **Fit models** with `fit_ps_biomarker_model()` (random forest)
3. **Rank taxa** with `rank_ps_taxa()` (by importance scores)
4. **Plot results** with `plot_ps_importance()`
5. **Full pipeline** with `run_ps_biomarker_pipeline()`

## Caporaso, J. G., et al. "Global patterns of 16S rRNA diversity at a depth of millions of sequences per sample." PNAS, 108, 4516-4522
[![R-CMD-check](https://github.com/briannaperino20/psbiomarker/workflows/R-CMD-check/badge.svg)](https://github.com/briannaperino20/psbiomarker/actions)
[![CRAN
status](https://www.r-pkg.org/badges/version/psbiomarker)](https://CRAN.R-project.org/package=psbiomarker)

## Installation

``` r
# Install from GitHub
install.packages("remotes")
#> Installing package into 'C:/Users/bribr/AppData/Local/Temp/RtmpYrcCHI/temp_libpath8f881b342481'
#> (as 'lib' is unspecified)
#> package 'remotes' successfully unpacked and MD5 sums checked
#> 
#> The downloaded binary packages are in
#>  C:\Users\bribr\AppData\Local\Temp\RtmpQ1vs8Y\downloaded_packages
remotes::install_github("briannaperino/psbiomarker")
#> Using GitHub PAT from the git credential store.
#> Downloading GitHub repo briannaperino/psbiomarker@HEAD
#> Skipping 1 packages not available: phyloseq
#> ── R CMD build ─────────────────────────────────────────────────────────────────
#>          checking for file 'C:\Users\bribr\AppData\Local\Temp\RtmpQ1vs8Y\remotes3c841a9c565a\briannaperino-psbiomarker-d373596/DESCRIPTION' ...  ✔  checking for file 'C:\Users\bribr\AppData\Local\Temp\RtmpQ1vs8Y\remotes3c841a9c565a\briannaperino-psbiomarker-d373596/DESCRIPTION' (665ms)
#>       ─  preparing 'psbiomarker':
#>    checking DESCRIPTION meta-information ...     checking DESCRIPTION meta-information ...   ✔  checking DESCRIPTION meta-information
#>       ─  checking for LF line-endings in source and make files and shell scripts
#>       ─  checking for empty or unneeded directories
#>       ─  building 'psbiomarker_0.0.0.9000.tar.gz'
#>      
#> 
#> Installing package into 'C:/Users/bribr/AppData/Local/Temp/RtmpYrcCHI/temp_libpath8f881b342481'
#> (as 'lib' is unspecified)
```

## Quick start

``` r
library(psbiomarker)

# Create example phyloseq object
set.seed(123)
otu <- matrix(
  rpois(40, lambda = c(rep(10, 20), rep(5, 20))),
  nrow = 10, ncol = 4,
  dimnames = list(paste0("Tax", 1:10), paste0("S", 1:4))
)
sdata <- data.frame(
  group = rep(c("Control", "Treatment"), each = 2),
  row.names = colnames(otu)
)
ps <- phyloseq::phyloseq(
  phyloseq::otu_table(otu, taxa_are_rows = TRUE),
  phyloseq::sample_data(sdata)
)

# Run full pipeline
res <- run_ps_biomarker_pipeline(
  ps = ps, 
  group = "group", 
  prevalence = 0.1, 
  transform = "relative_abundance", 
  method = "rf",
  top_n = 5
)

# Results
head(res$ranked_taxa)
#>      taxa importance
#> Tax2 Tax2   2.464320
#> Tax8 Tax8   1.001002
#> Tax1 Tax1   0.000000
#> Tax5 Tax5  -1.001002
#> Tax7 Tax7  -1.001002
```
 ```r
citation("psbiomarker")
```r
