#!/usr/bin/env nextflow

process BEDTOOLS_MERGE {
    label 'process_low'
    conda "${projectDir}/envs/bedtools.yml"
    publishDir "${params.outdir}/merged_peaks", mode: 'copy'

    input:
    tuple val(celltype), path(bed)

    output:
    tuple val(celltype), path("${celltype}_merged_peaks.bed"), emit: merged

    script:
    """
    # Sort and merge overlapping peaks
    sort -k1,1 -k2,2n ${bed} | bedtools merge -i - > ${celltype}_merged_peaks.bed
    """

    stub:
    """
    touch ${celltype}_merged_peaks.bed
    """
}