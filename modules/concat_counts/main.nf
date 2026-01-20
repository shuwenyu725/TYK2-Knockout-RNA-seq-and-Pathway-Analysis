#!/usr/bin/env nextflow


process CONCAT_COUNTS {
  label 'process_low'
  container 'ghcr.io/bf528/pandas:latest'
  publishDir params.outdir, mode: 'copy'

  input:
  path count              

  output:
  path "counts_matrix.tsv"

  script:
  """
  concat_counts.py -i ${count} -o counts_matrix.tsv
  """
}