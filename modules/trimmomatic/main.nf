#!/usr/bin/env nextflow

process TRIMMOMATIC {
    label 'process_medium'
    conda "${projectDir}/envs/trimmomatic.yml"
    publishDir "${params.outdir}/trimmed", mode: 'copy'

    input:
    tuple val(samplename), path(fastq)
    path(adapter_fa)  

    output:
    tuple val(samplename), path("${samplename}_trimmed.fastq.gz"), emit: trimmed
    tuple val(samplename), path("${samplename}_trim.log"), emit: log

    script:
    """
    trimmomatic SE -threads ${task.cpus} -phred33 \\
        ${fastq} ${samplename}_trimmed.fastq.gz \\
        ILLUMINACLIP:${adapter_fa}:2:20:7 \\
        LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:20 \\
        2> ${samplename}_trim.log
    """

    stub:
    """
    touch ${samplename}_trimmed.fastq.gz
    touch ${samplename}_trim.log
    """
}