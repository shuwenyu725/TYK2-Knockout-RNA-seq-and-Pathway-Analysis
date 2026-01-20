#!/usr/bin/env python3

import argparse, os, pandas as pd
ap = argparse.ArgumentParser()
ap.add_argument("-i", nargs="+", required=True)   
ap.add_argument("-o", required=True)              
p = ap.parse_args()

dfs = [ pd.read_csv(f, sep="\t", header=0, names=["gene", os.path.basename(f).replace(".exon.txt","")]).set_index("gene")
        for f in p.i ]
pd.concat(dfs, axis=1).fillna(0).astype(int).to_csv(p.o, sep="\t")


