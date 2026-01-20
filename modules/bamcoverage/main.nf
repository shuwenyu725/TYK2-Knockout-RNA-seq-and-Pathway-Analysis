#!/usr/bin/env nextflow

process BAMCOVERAGE {
    label 'process_medium'
    conda "${projectDir}/envs/deeptools_env.yml"
    publishDir "${params.outdir}/bigwigs", mode: 'copy'

    input:
    tuple val(samplename), path(bam), path(bai)

    output:
    tuple val(samplename), path("${samplename}.bw"), emit: bigwig

    script:
    """
    bamCoverage \\
        -b ${bam} \\
        -o ${samplename}.bw \\
        --binSize 10 \\
        --normalizeUsing CPM \\
        --numberOfProcessors ${task.cpus}
    """

    stub:
    """
    touch ${samplename}.bw
    """
}