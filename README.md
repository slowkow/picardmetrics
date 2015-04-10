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
      v19][Gencode19] gene annotations.

  -   `make_rRNA_intervals` creates an `intervals_list` file with all human
      ribosomal RNA genes.

  -   `plot_picardmetrics.R` shows how to read and plot the metrics.

## Commands

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
ln -s picardmetrics ~/bin/

# Copy and edit the configuration file to match your system.
cp picardmetricsrc ~/.picardmetricsrc
vim ~/.picardmetricsrc
```

You also need to install these dependencies:

-   [Picard]
-   [samtools], which depends on [htslib]
-   [stats]

## Examples

I included two BAM files in the [data/][data] folder, each with 10,000 mapped
reads, to illustrate the usage of `picardmetrics`. Please see the outputs in
the [out/][out] folder.

Here are three examples of how you can run the program:

1. Run `picardmetrics` sequentially (in a for loop) on multiple BAM files.

2. Run in parallel with [GNU parallel][parallel], using multiple processors or
   multiple servers.

3. Run in parallel with an [LSF] queue, distributing jobs to multiple servers.

### Example 1: Sequential

Run the Picard tools on the provided example BAM files:

```bash
for f in data/project1/sample?/sample?.bam; do
  picardmetrics run -o out -r $f
done
```

Collate the generated metrics files:

```bash
picardmetrics collate out/project1 out
```

### Example 2: GNU parallel

Run 2 jobs in parallel:

```bash
parallel -j2 picardmetrics run -r {} ::: data/project1/sample?/sample?.bam
```

If you have many files, or if you want to run jobs on multiple servers, it's
a good idea to put the full paths in a text file.

Here, we have ssh access to `server1` and `server2`. We're launching 16 jobs
on `server1` and 8 jobs on `server2`. You'll have to make sure that
`picardmetrics` is in your `PATH` on all servers.

```bash
ls /full/path/to/data/project1/sample*/sample*.bam > bams.txt
parallel -S 16/server1,8/server2 picardmetrics run -r {} :::: bams.txt
```

### Example 3: LSF

I recommend you install and use [asub] to submit jobs easily. This command
will submit a job for each BAM file to the `myqueue` LSF queue.

```bash
cat bams.txt | xargs -i echo picardmetrics run -r {} \
  | asub -j picardmetrics_jobs -q myqueue
```

[Picard]: https://broadinstitute.github.io/picard/
[samtools]: https://github.com/samtools/samtools
[htslib]: https://github.com/samtools/htslib
[stats]: https://github.com/arq5x/filo
[Picard]: https://broadinstitute.github.io/picard/
[BAM]: http://samtools.github.io/hts-specs/SAMv1.pdf
[parallel]: https://www.gnu.org/software/parallel/parallel_tutorial.html
[LSF]: http://www.vub.ac.be/BFUCC/LSF/
[Gencode19]: http://www.gencodegenes.org/releases/19.html
[asub]: https://github.com/lh3/asub
[scripts]: https://github.com/slowkow/picardmetrics/tree/master/scripts
[data]: https://github.com/slowkow/picardmetrics/tree/master/data
[out]: https://github.com/slowkow/picardmetrics/tree/master/out

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

