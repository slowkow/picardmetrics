#!/usr/bin/env bash
# test.sh
#
# Test picardmetrics

# Clean up previous runs.
rm -rf data/project1/sample?/picardmetrics
rm -f data/*.tsv
rm -f test/test-run.log
rm -f test/test-collate.log

# Run multiple metrics tools such as Picard on each BAM file.
for f in data/project1/sample?/sample?.bam
do
  ./picardmetrics run -r $f 2>&1 >> test/test-run.log
done

# Collate the generated tables into project summary tables.
./picardmetrics collate \
  data/project1 \
  data/project1/sample?/picardmetrics/sample?.sorted.bam \
  &> test/test-collate.log
