# picardmetrics

Run [Picard] tools and collate multiple metrics files. Check the quality of
your sequencing data.

[![DOI](https://zenodo.org/badge/doi/10.5281/zenodo.17142.svg)](http://dx.doi.org/10.5281/zenodo.17142)

## Example

![Genes detected vs. Mean MAPQ and Percent of bases vs. Sample][example]

[example]: https://github.com/slowkow/picardmetrics/blob/master/man/picardmetrics-banner.png

Use Picard to assess the quality of your sequencing data. This example shows
RNA-seq data from [hundreds of glioblastoma cells and gliomasphere cell
lines][Patel2014].

On the left, we see that samples with high mean mapping quality have the
greatest number of detected genes. Further, the color of points reveals
variation in the percent of reads per sample that are assigned to exons.

On the right, each sample is broken down into the percent of sequenced bases
coming from different genomic regions. We see that many samples have few
sequenced bases coming from coding regions relative to intergenic regions.

[Patel2014]: http://www.ncbi.nlm.nih.gov/bioproject/PRJNA248302

## Summary

`picardmetrics` runs 10 Picard tools on a [BAM] file:

  -   [SortSam]
  -   [MarkDuplicates]
  -   [CollectMultipleMetrics]
      -   [CollectAlignmentSummaryMetrics]
      -   [CollectBaseDistributionByCycle]
      -   [CollectInsertSizeMetrics]
      -   [MeanQualityByCycle]
      -   [QualityScoreDistribution]
  -   [CollectRnaSeqMetrics]
  -   [CollectGcBiasMetrics]
  -   [EstimateLibraryComplexity]

You can find additional scripts in the [scripts/][scripts] folder:

  -   `make_refFlat` creates a `refFlat` file with (human) [Gencode] gene
      annotations, needed for `CollectRnaSeqMetrics`. It also downloads the
      human reference genome.

  -   `make_rRNA_intervals` creates an `intervals_list` file with all human
      ribosomal RNA genes, needed for `CollectRnaSeqMetrics`.

  -   `plot_picardmetrics.R` shows how to read and plot the metrics.

I included two BAM files in the [data/][data] folder, each with 10,000 mapped
reads, to illustrate the usage of `picardmetrics`. Please see the outputs in
the [out/][out] folder.

## Commands

See the [manual] for more details.

```bash
$ picardmetrics
Usage: picardmetrics COMMAND
  run         Run the Picard tools on a given BAM file.
  collate     Collate metrics files for multiple BAM files.

$ picardmetrics run
Usage: picardmetrics run [-f FILE] [-o DIR] [-r] <file.bam>
  -f FILE     The configuration file. (Default: picardmetrics.conf)
  -o DIR      Write output files in this directory. (Default: .)
  -r          The BAM file has RNA-seq reads. (Default: false)
  -k          Keep the output BAM file. (Default: false)

$ picardmetrics collate
Usage: picardmetrics collate PREFIX DIR
  All picardmetrics output files in DIR will be collated.
  A file named 'PREFIX-all-metrics.tsv' will be written in DIR.
```

## Installation

```bash
# Download the code.
git clone https://github.com/slowkow/picardmetrics

cd picardmetrics

# Download and install the dependencies.
make get-deps PREFIX=~/.local

# Download human reference files and create the files needed for Picard.
make data

# Install picardmetrics.
make install PREFIX=~/.local

# Edit the configuration file to match your system.
vim ~/picardmetrics.conf
```

If you wish, you can manually install these dependencies:

-   [Picard]
-   [samtools], which depends on [htslib]
-   [stats]

[BAM]: http://samtools.github.io/hts-specs/SAMv1.pdf
[Gencode]: http://www.gencodegenes.org/

[Picard]: https://broadinstitute.github.io/picard/
[samtools]: https://github.com/samtools/samtools
[htslib]: https://github.com/samtools/htslib
[stats]: https://github.com/arq5x/filo

[scripts]: https://github.com/slowkow/picardmetrics/tree/master/scripts
[data]: https://github.com/slowkow/picardmetrics/tree/master/data
[out]: https://github.com/slowkow/picardmetrics/tree/master/out

[manual]: http://slowkow.com/picardmetrics/

[SortSam]: https://broadinstitute.github.io/picard/command-line-overview.html#SortSam
[MarkDuplicates]: https://broadinstitute.github.io/picard/command-line-overview.html#MarkDuplicates
[CollectMultipleMetrics]: https://broadinstitute.github.io/picard/command-line-overview.html#CollectMultipleMetrics
[CollectAlignmentSummaryMetrics]: https://broadinstitute.github.io/picard/command-line-overview.html#CollectAlignmentSummaryMetrics
[CollectBaseDistributionByCycle]: https://broadinstitute.github.io/picard/command-line-overview.html#CollectBaseDistributionByCycle
[CollectInsertSizeMetrics]: https://broadinstitute.github.io/picard/command-line-overview.html#CollectInsertSizeMetrics
[MeanQualityByCycle]: https://broadinstitute.github.io/picard/command-line-overview.html#MeanQualityByCycle
[QualityScoreDistribution]: https://broadinstitute.github.io/picard/command-line-overview.html#QualityScoreDistribution
[CollectRnaSeqMetrics]: https://broadinstitute.github.io/picard/command-line-overview.html#CollectRnaSeqMetrics
[CollectGcBiasMetrics]: https://broadinstitute.github.io/picard/command-line-overview.html#CollectGcBiasMetrics
[EstimateLibraryComplexity]: https://broadinstitute.github.io/picard/command-line-overview.html#EstimateLibraryComplexity

