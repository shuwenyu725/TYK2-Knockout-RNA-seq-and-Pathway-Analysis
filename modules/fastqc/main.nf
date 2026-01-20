process FASTQC {
    label 'process_low'
    conda "${projectDir}/envs/fastqc.yml"
    publishDir "${params.outdir}/fastqc", mode: 'copy', pattern: '*.{zip,html}'

    input:
    tuple val(sample), path(fastq)

    output:
    tuple val(sample), path("*_fastqc.zip"), emit: zip
    tuple val(sample), path("*_fastqc.html"), emit: html  // CHANGE THIS LINE

    script:
    """
    fastqc ${fastq} --outdir .
    """

    stub:
    """
    touch ${sample}_fastqc.zip
    touch ${sample}_fastqc.html
    """
}