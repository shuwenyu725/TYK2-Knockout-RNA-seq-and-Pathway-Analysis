#!/usr/bin/env nextflow

process SAMTOOLS_INDEX {
    label 'process_single'
    conda "${projectDir}/envs/samtools_env.yml"  // Fixed path
    publishDir "${params.outdir}/sorted_bams", mode: 'copy'

    input:
    tuple val(samplename), path(bam), path(bai) 

    output:
    tuple val(samplename), path(bam), path("${bam}.bai"), emit: indexed  // Fixed pattern

    script:
    """
    if [ ! -f ${bam}.bai ]; then
        samtools index -@ ${task.cpus} ${bam}
    fi
    """

    stub:
    """
    touch ${bam}.bai
    """
}