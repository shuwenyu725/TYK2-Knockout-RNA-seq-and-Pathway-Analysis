#!/usr/bin/env nextflow

process MACS3_CALLPEAK {
    label 'process_medium'
    conda "${projectDir}/envs/macs3.yml"
    publishDir "${params.outdir}/peaks", mode: 'copy', pattern: '*.{narrowPeak,xls,bed}'
    publishDir "${params.outdir}/qc/macs3", mode: 'copy', pattern: '*.log'

    input:
    tuple val(samplename), path(bam), path(bai) 

    output:
    tuple val(samplename), path("${samplename}_peaks.narrowPeak"), emit: peaks
    tuple val(samplename), path("${samplename}_peaks.xls"), emit: peak_xls
    tuple val(samplename), path("${samplename}_summits.bed"), emit: summits
    path("${samplename}_callpeak.log"), emit: log

    script:
    """
    macs3 callpeak \\
        -t ${bam} \\
        -f BAM \\
        -g mm \\
        -n ${samplename} \\
        -B \\
        -q 0.01 \\
        --nomodel \\
        --extsize 200 \\
        --shift -100 \\
        --keep-dup auto \\
        --call-summits \\
        2> ${samplename}_callpeak.log
    """

    stub:
    """
    touch ${samplename}_peaks.narrowPeak
    touch ${samplename}_peaks.xls
    touch ${samplename}_summits.bed
    touch ${samplename}_callpeak.log
    """
}