#!/usr/bin/env nextflow

process HOMER_MOTIFS {
    label 'process_high'
    conda "${projectDir}/envs/homer.yml"
    publishDir "${params.outdir}/homer/motifs", mode: 'copy'

    input:
    tuple val(celltype), path(peaks)

    output:
    tuple val(celltype), path("${celltype}_motifs/"), emit: motif_dir
    path("${celltype}_motifs/homerResults.html"), emit: html

    script:
    """
    findMotifsGenome.pl ${peaks} ${params.genome} ${celltype}_motifs/ \\
        -size 200 \\
        -len 8,10,12 \\
        -mask \\
        -p ${task.cpus}
    """

    stub:
    """
    mkdir -p ${celltype}_motifs
    touch ${celltype}_motifs/homerResults.html
    """
}