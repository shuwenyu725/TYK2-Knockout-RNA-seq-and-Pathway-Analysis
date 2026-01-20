#!/usr/bin/env nextflow

process CSV_TO_BED {
    label 'process_low'
    publishDir "${params.outdir}/diffbind", mode: 'copy'

    input:
    tuple val(celltype), path(csv)

    output:
    tuple val(celltype), path("${celltype}_differential_peaks.bed"), emit: bed

    script:
    """
    # Convert CSV to BED format (skip header, remove quotes)
    tail -n +2 ${csv} | sed 's/"//g' | awk -F',' 'BEGIN {OFS="\\t"} {
        print \$1, \$2, \$3, "peak_"NR, \$11, "+"
    }' > ${celltype}_differential_peaks.bed
    """

    stub:
    """
    touch ${celltype}_differential_peaks.bed
    """
}