# Change Log

# 0.1.2 - 2015-04-07

## Fixed

-   In `collate_all`, check for `prefix-rnaseq-metrics.tsv` file before
    attempting to merge the files into `prefix-all-metrics.tsv`.

## Changed

-   Removed regular expression from `is_bam` function, so the script will run
    with Bash version 2 released prior to 2004.

# 0.1.1 - 2015-03-20

## Changed

-   Write output files to `project1/sample1/picardmetrics` instead of
    `project1/sample1/`.

# 0.1 - 2015-03-16

-   Initial release.
