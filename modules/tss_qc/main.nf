#!/usr/bin/env nextflow
process TSS_QC {
    label 'process_medium'
    conda "${projectDir}/envs/deeptools_env.yml"
    publishDir "${params.outdir}/qc/tss_enrichment", mode: 'copy'
    
    input:
    tuple val(sample), path(bigwig)
    path tss_bed
    
    output:
    tuple val(sample), path("${sample}_tss_enrichment.txt"), emit: score
    
    script:
    """
    computeMatrix reference-point \
        --referencePoint center \
        -S ${bigwig} \
        -R ${tss_bed} \
        -b 2000 -a 2000 \
        --skipZeros \
        -p ${task.cpus} \
        --binSize 20 \
        -o ${sample}_tss_matrix.gz

    plotProfile \
        -m ${sample}_tss_matrix.gz \
        -out ${sample}_profile.png \
        --outFileNameData ${sample}_data.tab

    # ENCODE method: center vs average of 100bp end flanks
    awk 'NR==3 {
        # End flanks: first 5 bins (100bp) and last 5 bins (100bp)
        # Bins 1-5 = cols 2-6, Bins 196-200 = cols 197-201
        flank_sum = 0;
        for(i=2; i<=6; i++) flank_sum += \$i;
        for(i=197; i<=201; i++) flank_sum += \$i;
        flank_avg = flank_sum / 10;
        
        # Center: single bin at TSS (bin 100 = col 101)
        center = \$101;
        
        # TSS enrichment = center / flank average
        score = (flank_avg > 0) ? center / flank_avg : 0;
        
        print "Sample: ${sample}";
        print "TSS_Enrichment_Score: " score;
    }' ${sample}_data.tab > ${sample}_tss_enrichment.txt
    """
}