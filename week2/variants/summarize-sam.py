#!/usr/bin/env python3
import sys

samfile = open( sys.argv[1] )

chr_alignments = {}
nm_counts = {}

for line in samfile:
    if line.startswith('@'): #skip header lines
        continue
    columns = line.strip().split('\t')
    rname = columns[2]
    if rname not in chr_alignments:
        chr_alignments[rname] = 1
    else: 
        chr_alignments[rname] += 1
    nm_value = None
    for field in columns:  
        if field.startswith("NM:i:"):
                nm_value = int(field[5:])  # 5th position after NM is the number 
                break
    if nm_value is not None:
        nm_counts[nm_value] = nm_counts.get(nm_value, 0) + 1
        
for chr in chr_alignments.keys():
    print(f"{chr}: {chr_alignments[chr]} reads")

print("\nNM tag counts (mismatch counts):")
for nm in sorted(nm_counts.keys()):
    print(f"{nm}: {nm_counts[nm]} reads")

