#!/usr/bin/env nextflow

include { FASTQC } from './modules/fastqc'
include { PARSE_GTF } from './modules/parse_gtf'
include { STAR } from './modules/star'
include { STAR_ALIGN } from './modules/star_align'
include { MULTIQC    } from './modules/multiqc'
include { VERSE   } from './modules/verse'
include { CONCAT_COUNTS } from './modules/concat_counts'

workflow {
  Channel.fromFilePairs(params.reads, flat:false).set { align_ch }

  fastqc_ch = align_ch.flatMap { sample_id, reads -> reads.collect { read_file -> tuple(sample_id, read_file) }}

  FASTQC(fastqc_ch)

  Channel.of(file(params.gtf)).set { gtf_ch }
  PARSE_GTF(gtf_ch)

  STAR( file(params.genome), file(params.gtf) )
  STAR.out.set { star_index_ch }

  STAR_ALIGN( align_ch, star_index_ch )

  FASTQC.out.zip
  .map { sample_id, zip_file -> zip_file }                             
  .mix( STAR_ALIGN.out.log.map { sample_id, log_file -> log_file } )    
  .collect()                                                            
  .set { multiqc_ch }                                                  

  MULTIQC(multiqc_ch)

  VERSE( STAR_ALIGN.out.bam, file(params.gtf) )

  VERSE.out.counts
    .map { sample_id, count_file -> count_file }  
    .collect()
    .set { count_files_ch }   

  CONCAT_COUNTS(count_files_ch)
}

