#!/usr/bin/env bash
# test.sh
#
# Test picardmetrics
#
# data/project1/sample1.bam     10,000 paired-end 101 bp reads
# data/project1/sample2.bam     similar reads, but the header is shuffled

OK=1

main() {
  # Clean up previous runs.
  rm -rf out

  echo -e "$(DATE)\tSTART\ttest_default"
  test_default

  echo -e "$(DATE)\tSTART\ttest_rnaseq"
  test_rnaseq

  echo -e "$(DATE)\tDONE"

  if [[ ! $OK = 1 ]];then
    echo -e "$(DATE)\tFailed"
    exit 1
  fi
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
  checksum=$(md5sum ${out}-all-metrics.tsv | cut -f1 -d' ')
  if [[ ! "244cffd02775ab1517578147aee39ab1" = "$checksum" ]]; then
    cat $run_log >&2
    cat $collate_log >&2
    OK=0
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
  checksum=$(md5sum ${out}-all-metrics.tsv | cut -f1 -d' ')
  if [[ ! "3482de25bcf68887d71ed1803505ec66" = "$checksum" ]]; then
    cat $run_log >&2
    cat $collate_log >&2
    OK=0
  fi
}

DATE() {
  command date +'%Y-%m-%d %H:%M:%S'
}

main
