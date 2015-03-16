#!/usr/bin/env Rscript
# plot-picardmetrics.R
# Kamil Slowikowski

library(ggplot2, quietly = TRUE)
library(plyr, quietly = TRUE)

# Main function. -------------------------------------------------------------

main <- function(prefix, outdir) {
  args <- commandArgs(trailingOnly = TRUE)

  if (length(args) < 1 || length(args) > 2) {
    cat("Usage: plot-picardmetrics PREFIX [OUTDIR]\n")
    cat("    Default OUTDIR is figures/\n")
    quit()
  }

  prefix <- args[1]

  if (length(args) == 2) {
    outdir <- args[2]
  } else {
    outdir <- "figures"
  }
  dir.create(outdir)

  dat <- read_metrics(prefix)
  write_tsv(x = dat, file = sprintf("%s-all-metrics.tsv", prefix))

  ggplot(dat) +
    geom_point(aes(PF_READS, PF_ALIGNED_BASES))

  ggplot(dat) +
    geom_histogram(aes(x = MAPQ_Mean), binwidth = 1) +
    labs(x = "Percent of Fragments Assigned (Binwidth = 1)",
         y = "Count")
}

# Functions. -----------------------------------------------------------------

write_tsv <- function(...) {
  write.table(sep = "\t", quote = FALSE, row.names = FALSE, ...)  
}

read_metrics <- function(prefix) {
  dat_align_metrics = read.delim(
    sprintf("%s-alignment-metrics.tsv", prefix),
    stringsAsFactors = FALSE
  )
  dat_duplicate_metrics = read.delim(
    sprintf("%s-duplicate-metrics.tsv", prefix),
    stringsAsFactors = FALSE
  )
  dat_gcbias_metrics = read.delim(
    sprintf("%s-gc-bias-summary.tsv", prefix),
    stringsAsFactors = FALSE
  )
  dat_insert_size_metrics = read.delim(
    sprintf("%s-insert-size-metrics.tsv", prefix),
    stringsAsFactors = FALSE
  )
  dat_library_complexity = read.delim(
    sprintf("%s-library-complexity.tsv", prefix),
    stringsAsFactors = FALSE
  )
  dat_rnaseq_metrics = read.delim(
    sprintf("%s-rnaseq-metrics.tsv", prefix),
    stringsAsFactors = FALSE,
  )
  dat_mapq_stats <- read.delim(
    sprintf("%s-mapq-stats.tsv", prefix),
    stringsAsFactors = FALSE
  )

  # Exclude FIRST_OF_PAIR and SECOND_OF_PAIR.
  idx = dat_align_metrics$CATEGORY %in% c("PAIR", "UNPAIRED")
  dat_align_metrics = dat_align_metrics[idx, ]

  # alignment_metrics and rnaseq_metrics both have this column.
  idx <- colnames(dat_rnaseq_metrics) == "PF_ALIGNED_BASES"
  colnames(dat_rnaseq_metrics)[idx] <- "PF_ALIGNED_BASES_rnaseq_metrics"
  
  # duplicate_metrics and library_complexity share columns
  cnames <- colnames(dat_library_complexity)
  cnames[2:length(cnames)] <- paste0(
    cnames[2:length(cnames)], "_library_complexity"
  )
  colnames(dat_library_complexity) <- cnames

  # Ensure the files are describing the same samples.
  stopifnot( all(dat_align_metrics$SAMPLE == dat_rnaseq_metrics$SAMPLE) )
  stopifnot( all(dat_align_metrics$SAMPLE == dat_duplicate_metrics$SAMPLE) )
  stopifnot( all(dat_align_metrics$SAMPLE == dat_gcbias_metrics$SAMPLE) )
  stopifnot( all(dat_align_metrics$SAMPLE == dat_insert_size_metrics$SAMPLE) )
  stopifnot( all(dat_align_metrics$SAMPLE == dat_library_complexity$SAMPLE) )
  stopifnot( all(dat_align_metrics$SAMPLE == dat_mapq_stats$SAMPLE) )

  dat = merge(dat_align_metrics, dat_rnaseq_metrics, by = "SAMPLE")
  dat = merge(dat, dat_duplicate_metrics, by = "SAMPLE")
  dat = merge(dat, dat_gcbias_metrics, by = "SAMPLE")
  dat = merge(dat, dat_insert_size_metrics, by = "SAMPLE")
  dat = merge(dat, dat_library_complexity, by = "SAMPLE")
  dat = merge(dat, dat_mapq_stats, by = "SAMPLE")

  colnames(dat)

  return(dat)
}

main(prefix, outdir)

