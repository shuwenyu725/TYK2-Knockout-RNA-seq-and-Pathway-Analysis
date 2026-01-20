#!/usr/bin/env nextflow

process PLOTHEATMAP {
    label 'process_low'
    conda "${projectDir}/envs/deeptools_env.yml"
    publishDir "${params.outdir}/heatmaps", mode: 'copy'

    input:
    tuple val(celltype), path(matrix)

    output:
    tuple val(celltype), path("${celltype}_heatmap.png"), emit: heatmap_png
    tuple val(celltype), path("${celltype}_sorted_regions.bed"), emit: sorted_regions, optional: true

    script:
    """
    plotHeatmap \\
        -m ${matrix} \\
        -o ${celltype}_heatmap.png \\
        --outFileSortedRegions ${celltype}_sorted_regions.bed \\
        --colorMap RdBu_r \\
        --whatToShow 'plot, heatmap and colorbar' \\
        --kmeans 2 \\
        --sortRegions descend \\
        --sortUsing mean \\
        --plotTitle '${celltype}' \\
        --refPointLabel center \\
        --regionsLabel 'Gain' 'Loss' \\
        --yAxisLabel 'RPKM' \\
        --legendLocation none \\
        --heatmapHeight 20 \\
        --heatmapWidth 8 \\
        --dpi 300
    """

    stub:
    """
    touch ${celltype}_heatmap.png
    touch ${celltype}_sorted_regions.bed
    """
}