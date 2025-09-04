#!/usr/bin/env python3

import sys
import fasta

my_file = open( sys.argv[1] )
contigs = fasta.FASTAReader(my_file)

i = 0 
length = 0 

for ident, sequence in contigs: 
    length = int(length + len(sequence))
    i = int(i + 1)
avg_length = length/i 
#print(f"Name: {ident}\tNumber of Contigs: {i}\tTotal length: {length}\tAverage length: {avg_length}")
my_file.close()

my_file = open( sys.argv[1] )
contigs = fasta.FASTAReader(my_file)
contig_lengths= []

for ident, sequence in contigs: 
    len_contig = int(len(sequence))
    contig_lengths.append(len_contig)
contig_lengths.sort(reverse=True)
#print(contig_lengths)

cum_length = 0 
cumulative_len = []
for len in contig_lengths:
    cumulative_len.append(len)
    cum_length = cum_length + len
    if cum_length > (length*0.5):
        print(f"The sequence length of the shortest contig at 50% of the total assembly length is: {len}")
        break






