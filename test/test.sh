#!/usr/bin/env bash
# test.sh
#
# Test picardmetrics
#
# data/project1/sample1.bam     10,000 paired-end 101 bp reads
# data/project1/sample2.bam     similar reads, but the header is shuffled

main() {
  # Clean up previous runs.
  rm -rf out

  echo -e "$(DATE)\tSTART\ttest_default"
  test_default

  echo -e "$(DATE)\tSTART\ttest_rnaseq"
  test_rnaseq

  echo -e "$(DATE)\tDONE"
}

test_default() {
  out=out/default
  mkdir -p $out

  run_log=$out/picardmetrics-run.log
  collate_log=$out/picardmetrics-collate.log
  rm -f $run_log $collate_log

  # Run multiple metrics on each BAM file.
  for f in data/project1/sample?/sample?.bam
  do
    ./picardmetrics run -f ~/picardmetrics.conf -o $out $f 2>&1 >> $run_log
  done

  # Collate the generated tables.
  ./picardmetrics collate $out $out &> $collate_log

  # Confirm that the final output is correct.
  md5sum -c \
    <(echo "5f4a27b122a088730f144c93a2100a74  ${out}-all-metrics.tsv")

  ERR=$?
  if [[ $ERR != 0 ]]; then
    exit $ERR
  fi
}

test_rnaseq() {
  out=out/rnaseq
  mkdir -p $out

  run_log=$out/picardmetrics-run.log
  collate_log=$out/picardmetrics-collate.log
  rm -f $run_log $collate_log

  # Run multiple metrics on each BAM file.
  for f in data/project1/sample?/sample?.bam
  do
    ./picardmetrics run -r -f ~/picardmetrics.conf -o $out $f 2>&1 >> $run_log
  done

  # Collate the generated tables.
  ./picardmetrics collate $out $out &> $collate_log

  # Confirm that the final output is correct.
  md5sum -c \
    <(echo "98887a74cfdec74cb60f11f8f69d281e  ${out}-all-metrics.tsv")
  
  ERR=$?
  if [[ $ERR != 0 ]]; then
    exit $ERR
  fi
}

DATE() {
  command date +'%Y-%m-%d %H:%M:%S'
}

main
