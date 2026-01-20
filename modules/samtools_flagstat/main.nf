#!/usr/bin/env nextflow

process SAMTOOLS_FLAGSTAT {
    label 'process_low' 
    conda "${projectDir}/envs/samtools_env.yml"
    publishDir "${params.outdir}/qc/flagstat", mode: 'copy', pattern: '*.txt'

    input:
    tuple val(samplename), path(bam)  

    output:
    tuple val(samplename), path("${samplename}_flagstat.txt"), emit: flagstat

    script:
    """
    samtools flagstat ${bam} > ${samplename}_flagstat.txt
    """
}