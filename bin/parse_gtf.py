#!/usr/bin/env python3

import argparse


parser = argparse.ArgumentParser(
    description="Extract Ensembl gene IDs and gene symbols from a GTF annotation file."
)
parser.add_argument("-i", "--input", help="Input GTF file", dest="input", required=True)
parser.add_argument("-o", "--output", help="Output TSV file", dest="output", required=True)

args = parser.parse_args()


out = open(args.output, 'w')
out.write("ensembl_id\tgene_name\n")

with open(args.input, 'r') as f:
    for line in f:
        
        if line.startswith('#'):
            continue

        fields = line.strip().split('\t')
        
        if len(fields) < 9:
            continue

        
        if fields[2] != 'gene':
            continue

        
        attr = fields[8]
        gene_id = None
        gene_name = None

        
        for item in attr.split(';'):
            item = item.strip()
            if item.startswith('gene_id'):
                gene_id = item.split('"')[1]
            elif item.startswith('gene_name'):
                gene_name = item.split('"')[1]

       
        if gene_id and gene_name:
            out.write(f"{gene_id}\t{gene_name}\n")

out.close()

print(f"[Done] Extracted gene IDs and names to: {args.output}")
