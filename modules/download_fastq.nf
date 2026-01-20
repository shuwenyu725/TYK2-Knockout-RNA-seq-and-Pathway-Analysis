process DOWNLOAD_FASTQ {
    label 'process_medium'
    container 'biocontainers/sra-tools:v2.11.0_cv1'
    conda "${projectDir}/envs/sra-tools.yml"  // Add this line
    
    publishDir "${params.sample_dir}", mode: 'copy'

    input:
    val srr_id

    output:
    tuple val(srr_id), path("${srr_id}.fastq.gz")

    script:
    """
    fasterq-dump ${srr_id} --threads 8 -t tmp_${srr_id}
gzip ${srr_id}.fastq
    """
}
