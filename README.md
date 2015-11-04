# picardmetrics

Run [Picard] tools and collate multiple metrics files. Check the quality of
your sequencing data.

[![DOI](https://zenodo.org/badge/doi/10.5281/zenodo.17142.svg)](http://dx.doi.org/10.5281/zenodo.17142)
[![Build Status](https://travis-ci.org/slowkow/picardmetrics.svg?branch=master)](https://travis-ci.org/slowkow/picardmetrics)

## Summary

`picardmetrics` runs up to [12 Picard tools][manual] on a [BAM] file and
collates all of the output files into a single table with up to [90 different
metrics][definitions]. It also creates the two Picard files required for
CollectRnaSeqMetrics.

See the [manual] for more details.

After running `picardmetrics`, plot and explore the metrics:

```r
library(ggplot2)

dat <- read.delim("out/rnaseq-all-metrics.tsv", stringsAsFactors = FALSE)

ggplot(dat) +
  geom_point(aes(PF_READS, PF_ALIGNED_BASES))
```

See two example BAM files in the [data/][data] folder. They are used to
illustrate the usage of `picardmetrics` and to test that it functions
correctly. See the outputs in the [out/][out] folder. Download the reference
files used to test `picardmetrics` [here][reference].

## Example

![Genes detected vs. Mean MAPQ and Percent of bases vs. Sample][example]

[example]: https://github.com/slowkow/picardmetrics/blob/master/man/picardmetrics-banner.png

Use Picard to assess the quality of your sequencing data. This example shows
RNA-seq data from [hundreds of glioblastoma cells and gliomasphere cell
lines][Patel2014].

On the left, each point represents an RNA-seq sample. We see that samples
with high mean mapping quality have the greatest number of detected genes.
Further, the color reveals variation in the percent of reads per sample
that are assigned to exons.

On the right, each bar represents an RNA-seq sample. Each sample is broken
down into the percent of sequenced bases coming from different genomic
regions. We see that many samples have few sequenced bases coming from
coding regions relative to intergenic regions.

[Patel2014]: http://www.ncbi.nlm.nih.gov/bioproject/PRJNA248302

## Installation

```bash
# Download the code.
git clone https://github.com/slowkow/picardmetrics

cd picardmetrics

# Download and install the dependencies.
make get-deps PREFIX=~/.local

# Install picardmetrics and the man page.
make install PREFIX=~/.local

# Edit the configuration file for your project.
vim ~/picardmetrics.conf
```

If you wish, you can manually install the dependencies:

-   [Picard]
-   [samtools], which depends on [htslib]
-   [stats]
-   [gtfToGenePred]

[BAM]: http://samtools.github.io/hts-specs/SAMv1.pdf
[Gencode]: http://www.gencodegenes.org/

[Picard]: https://broadinstitute.github.io/picard/
[samtools]: https://github.com/samtools/samtools
[htslib]: https://github.com/samtools/htslib
[stats]: https://github.com/arq5x/filo
[gtfToGenePred]: http://hgdownload.cse.ucsc.edu/admin/exe/linux.x86_64/

[scripts]: https://github.com/slowkow/picardmetrics/tree/master/scripts
[data]: https://github.com/slowkow/picardmetrics/tree/master/data
[out]: https://github.com/slowkow/picardmetrics/tree/master/out

[manual]: http://slowkow.com/picardmetrics/
[reference]: http://dx.doi.org/10.5281/zenodo.18116

[definitions]: https://broadinstitute.github.io/picard/picard-metric-definitions.html

## Contributing

Please [submit an issue][issues] to report bugs or ask questions.

Please contribute bug fixes or new features with a [pull request][pull] to this repository.

[issues]: https://github.com/slowkow/picardmetrics/issues
[pull]: https://help.github.com/articles/using-pull-requests/

## Related work

[RNA-SeQC][rnaseqc]

> RNA-SeQC is a java program which computes a series of quality control
> metrics for RNA-seq data. The input can be one or more BAM files. The output
> consists of HTML reports and tab delimited files of metrics data. This
> program can be valuable for comparing sequencing quality across different
> samples or experiments to evaluate different experimental parameters. It can
> also be run on individual samples as a means of quality control before
> continuing with downstream analysis.

[RSeQC][rseqc]

> RSeQC package provides a number of useful modules that can comprehensively
> evaluate high throughput sequence data especially RNA-seq data. Some basic
> modules quickly inspect sequence quality, nucleotide composition bias, PCR
> bias and GC bias, while RNA-seq specific modules evaluate sequencing
> saturation, mapped reads distribution, coverage uniformity, strand
> specificity, etc.

[QoRTs][qorts]

> The QoRTs software package is a fast, efficient, and portable multifunction
> toolkit designed to assist in the analysis, quality control, and data
> management of RNA-Seq datasets. Its primary function is to aid in the
> detection and identification of errors, biases, and artifacts produced by
> paired-end high-throughput RNA-Seq technology. In addition, it can produce
> count data designed for use with differential expression and differential
> exon usage tools 2, as well as individual-sample and/or group-summary
> genome track files suitable for use with the UCSC genome browser (or any
> compatible browser).

[rnaseqc]: http://www.broadinstitute.org/cancer/cga/rna-seqc
[rseqc]: http://rseqc.sourceforge.net/
[qorts]: https://github.com/hartleys/QoRTs
