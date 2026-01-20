#!/usr/bin/env nextflow

process BEDTOOLS_INTERSECT {
    label 'process_low'
    conda "${projectDir}/envs/bedtools.yml"
    publishDir "${params.outdir}/qc/frip", mode: 'copy'

    input:
    tuple val(samplename), path(peaks), path(bam), path(bai)

    output:
    tuple val(samplename), path("${samplename}_frip.txt"), emit: frip

    script:
    """
    # Count total reads in BAM
    total_reads=\$(samtools view -c ${bam})

    # Count reads overlapping peaks
    reads_in_peaks=\$(bedtools intersect -a ${bam} -b ${peaks} | samtools view -c)

    # Calculate FRiP score
    frip=\$(echo "scale=4; \$reads_in_peaks / \$total_reads" | bc)

    # Write results
    echo -e "Sample\\tTotal_Reads\\tReads_in_Peaks\\tFRiP_Score" > ${samplename}_frip.txt
    echo -e "${samplename}\\t\$total_reads\\t\$reads_in_peaks\\t\$frip" >> ${samplename}_frip.txt
    """

    stub:
    """
    echo -e "Sample\\tTotal_Reads\\tReads_in_Peaks\\tFRiP_Score" > ${samplename}_frip.txt
    echo -e "${samplename}\\t1000000\\t200000\\t0.2000" >> ${samplename}_frip.txt
    """
}