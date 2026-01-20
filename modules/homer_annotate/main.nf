#!/usr/bin/env nextflow

process HOMER_ANNOTATE {
    label 'process_medium'
    conda "${projectDir}/envs/homer.yml"
    publishDir "${params.outdir}/homer/annotations", mode: 'copy'

    input:
    tuple val(celltype), path(peaks)

    output:
    tuple val(celltype), path("${celltype}_annotated.txt"), emit: annotated
    path("${celltype}_annotation_summary.txt"), emit: summary

    script:
    """
    # Annotate differential peaks
    annotatePeaks.pl ${peaks} ${params.genome} \\
        -gtf ${params.annotation} \\
        > ${celltype}_annotated.txt

    # Create summary of genomic feature distribution
    tail -n +2 ${celltype}_annotated.txt | \\
        cut -f8 | sort | uniq -c | sort -rn > ${celltype}_annotation_summary.txt
    """

    stub:
    """
    touch ${celltype}_annotated.txt
    touch ${celltype}_annotation_summary.txt
    """
}
 