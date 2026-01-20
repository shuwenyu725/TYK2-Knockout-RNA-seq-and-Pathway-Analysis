#!/usr/bin/env nextflow

process FASTQC {

    container 'ghcr.io/bf528/fastqc:latest'
    publishDir params.outdir, mode: "copy", pattern: '*.html'

    input:
    tuple val(sample), path(fastq)

    output:
    tuple val(sample), path("*.zip"), emit: zip
    tuple val(sample), path("*.html"), emit: html

    script:
    """
    fastqc $fastq
    """
}

