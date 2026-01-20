#!/usr/bin/env nextflow

process ALIGNMENTSIEVE {
    label 'process_medium'
    conda "${projectDir}/envs/deeptools_env.yml"
    publishDir "${params.outdir}/filtered_bams", mode: 'copy', pattern: '*.bam'
    publishDir "${params.outdir}/qc/alignmentsieve", mode: 'copy', pattern: '*_metrics.txt'

    input:
    tuple val(samplename), path(bam), path(bai) 

    output:
    tuple val(samplename), path("${samplename}.filtered.bam"), emit: filtered
    path("${samplename}_filter_metrics.txt"), emit: metrics

    script:
    """
    samtools index ${bam}

    alignmentSieve \
    -b ${bam} \
    -o ${samplename}.filtered.bam \
    --shift 4 -5 \
    --ignoreDuplicates \
    --minMappingQuality 5 \
    --blackListFileName ${params.blacklist} \
    --filterMetrics ${samplename}_filter_metrics.txt
    """

    stub:
    """
    touch ${samplename}.filtered.bam
    touch ${samplename}_filter_metrics.txt
    """
}