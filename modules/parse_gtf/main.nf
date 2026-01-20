#!/usr/bin/env nextflow

process PARSE_GTF {
    label 'process_medium'
    container 'ghcr.io/bf528/pandas:latest'  
    publishDir params.outdir, mode: "copy"

    input:
    path gtf

    output:
    path "gene_ids_to_names.txt"

    script:
    """
    python3 ${projectDir}/bin/parse_gtf.py -i $gtf -o gene_ids_to_names.txt
    """
}