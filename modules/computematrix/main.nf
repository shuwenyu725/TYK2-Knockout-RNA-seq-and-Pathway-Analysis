#!/usr/bin/env nextflow

process COMPUTEMATRIX {
    label 'process_high'
    conda "${projectDir}/envs/deeptools_env.yml"
    publishDir "${params.outdir}/matrices", mode: 'copy'

    input:
    tuple val(celltype), path(merged_bed), path(bigwigs), val(labels)

    output:
    tuple val(celltype), path("${celltype}_matrix.mat.gz"), emit: matrix

    script:
    def bw_files = bigwigs.join(' ')
    def sample_labels = labels.join(' ')
    
    """
    computeMatrix reference-point \\
        --referencePoint center \\
        -S ${bw_files} \\
        -R ${merged_bed} \\
        -o ${celltype}_matrix.mat.gz \\
        --beforeRegionStartLength 2000 \\
        --afterRegionStartLength 2000 \\
        --binSize 10 \\
        --samplesLabel ${sample_labels} \\
        --numberOfProcessors ${task.cpus}
    """

    stub:
    """
    touch ${celltype}_matrix.mat.gz
    """
}