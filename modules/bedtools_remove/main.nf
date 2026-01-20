#!/usr/bin/env nextflow

process BEDTOOLS_REMOVE {
    label 'process_medium'
    conda "${projectDir}/envs/samtools_env.yml"
    publishDir "${params.outdir}/final_bams", mode: 'copy'

    input:
    tuple val(samplename), path(bam), path(bai)

    output:
    tuple val(samplename), path("${samplename}.final.bam"), emit: filtered

    script:
    """
    # Remove duplicates, low quality, and blacklist regions
    samtools view -h -b -F 1024 -q 5 ${bam} | \
        bedtools intersect -v -a stdin -b ${params.blacklist} -wa \
        > ${samplename}.final.bam
    
    # Index the final BAM
    samtools index ${samplename}.final.bam
    """

    stub:
    """
    touch ${samplename}.final.bam
    touch ${samplename}.final.bam.bai
    """
}