#!/usr/bin/env nextflow

process SAMTOOLS_SORT {
    label 'process_medium'  // Changed for multi-threading
    conda "${projectDir}/envs/samtools_env.yml"  // Fixed path
    publishDir "${params.outdir}/sorted_bams", mode: 'copy'

    input:
    tuple val(samplename), path(bam)

    output:
    tuple val(samplename), path("${samplename}.sorted.bam"), emit: sorted  // Fixed pattern

    script:
    """
    samtools sort -@ ${task.cpus} ${bam} -o ${samplename}.sorted.bam
    """

    stub:
    """
    touch ${samplename}.sorted.bam
    """
}