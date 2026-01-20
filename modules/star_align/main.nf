#!/usr/bin/env nextflow

process STAR_ALIGN {
  label 'process_high'
  container 'ghcr.io/bf528/star:latest'
  publishDir params.outdir, mode: 'copy'

  input:

  tuple val(name), path(reads)

  path genome_index

  output:

  tuple val(name), path("${name}.Aligned.sortedByCoord.out.bam"), emit: bam
  tuple val(name), path("${name}.Log.final.out"),                emit: log

  script:
  """


  STAR --runThreadN ${task.cpus} \
       --genomeDir ${genome_index} \
       --readFilesIn ${reads[0]} ${reads[1]} \
       --readFilesCommand zcat \
       --outFileNamePrefix ${name}. \
       --outSAMtype BAM SortedByCoordinate \
       2> ${name}.Log.final.out
  """
}