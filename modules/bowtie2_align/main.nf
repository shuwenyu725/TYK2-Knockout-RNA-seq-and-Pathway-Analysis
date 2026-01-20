#!/usr/bin/env nextflow

process BOWTIE2_ALIGN {
    label 'process_high'
    conda "${projectDir}/envs/bowtie2_env.yml"

    publishDir "${params.sample_dir}", mode: 'copy'

    input:
    path reads
    path index_dir
    val samplename

    output:                                                       
    tuple val(samplename), path("${samplename}.bam"), emit: bam   

    script:
    """
    bowtie2 -p ${task.cpus - 1} \
        --very-sensitive \
        -x ${index_dir}/genome \
        -U ${reads} \
        | samtools view -@ 1 -bS - > ${samplename}.bam
    """

    stub:
    """
    touch ${samplename}.bam
    """
}