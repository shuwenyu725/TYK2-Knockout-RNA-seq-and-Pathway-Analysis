#!/usr/bin/env nextflow

process SAMTOOLS_VIEW {
    label 'process_medium'
    conda "${projectDir}/envs/samtools_env.yml"
    publishDir "${params.outdir}/nochrM_bams", mode: 'copy'

    input:
    tuple val(samplename), path(bam)

    output:
    tuple val(samplename), path("${samplename}.nochrM.sorted.bam"), path("${samplename}.nochrM.sorted.bam.bai"), emit: filtered  // FIXED

    script:
    """
    samtools view -h ${bam} | \
        awk '\$1 ~ /^@/ || (\$3 != "chrM" && \$3 != "MT" && \$3 != "chrMT")' | \
        samtools sort -@ ${task.cpus} -o ${samplename}.nochrM.sorted.bam -

    samtools index -@ ${task.cpus} ${samplename}.nochrM.sorted.bam
    """

    stub:
    """
    touch ${samplename}.nochrM.sorted.bam
    touch ${samplename}.nochrM.sorted.bam.bai
    """
}