#!/usr/bin/env bash
# test.sh
#
# Test picardmetrics

main() {
  echo -e "$(DATE)\tSTART\ttest_default"
  test_default
  echo -e "$(DATE)\tSTART\ttest_rnaseq"
  test_rnaseq
  echo -e "$(DATE)\tDONE"
}

test_default() {
  # Clean up previous runs.
  rm -rf out
  rm -f test/test-run.log
  rm -f test/test-collate.log

  # Run multiple metrics on each BAM file.
  for f in data/project1/sample?/sample?.bam
  do
    ./picardmetrics run -f ~/picardmetrics.conf -o out $f \
      2>&1 >> test/test-run.log
  done

  # Collate the generated tables into project summary tables.
  ./picardmetrics collate out/project1 out &> test/test-collate.log

  # Confirm that the final output is correct.
  md5sum -c \
    <(echo 5f4a27b122a088730f144c93a2100a74 out/project1-all-metrics.tsv)

  if [[ "$?" != 0 ]]; then
    exit 1
  fi
}

test_rnaseq() {
  # Clean up previous runs.
  rm -rf out
  rm -f test/test-run.log
  rm -f test/test-collate.log

  # Run multiple metrics on each BAM file.
  for f in data/project1/sample?/sample?.bam
  do
    ./picardmetrics run -f ~/picardmetrics.conf -o out -r $f \
      2>&1 >> test/test-run.log
  done

  # Collate the generated tables into project summary tables.
  ./picardmetrics collate out/project1 out &> test/test-collate.log

  # Confirm that the final output is correct.
  md5sum -c \
    <(echo 98887a74cfdec74cb60f11f8f69d281e out/project1-all-metrics.tsv)

  if [[ "$?" != 0 ]]; then
    exit 1
  fi
}

DATE() {
  command date +'%Y-%m-%d %H:%M:%S'
}

main
