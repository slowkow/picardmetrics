# picardmetrics

Run [Picard] tools and collate multiple metrics files.

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

  -   `make_refFlat` creates a `refFlat` file with (human) [Gencode
      v19][Gencode19] gene annotations, needed for `CollectRnaSeqMetrics`.

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
  -f FILE     The configuration file. (Default: .picardmetricsrc)
  -o DIR      Write output files in this directory. (Default: .)
  -r          The BAM file has RNA-seq reads. (Default: false)

$ picardmetrics collate
Usage: picardmetrics collate PREFIX DIR
  All picardmetrics output files in DIR will be collated.
  A file named 'PREFIX-all-metrics.tsv' will be written in DIR.
```

## Installation

```bash
# Download the code.
git clone git@github.com:slowkow/picardmetrics.git

# Install the script to your preferred location.
cd picardmetrics
make install PREFIX=~/.local

# Edit the configuration file to match your system.
vim ~/.picardmetricsrc
```

You also need to install these dependencies:

-   [Picard]
-   [samtools], which depends on [htslib]
-   [stats]

[BAM]: http://samtools.github.io/hts-specs/SAMv1.pdf
[Gencode19]: http://www.gencodegenes.org/releases/19.html

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

