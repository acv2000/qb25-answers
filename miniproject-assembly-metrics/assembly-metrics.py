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
    
print(f"Name: {ident}\tNumber of Contigs: {i}\tTotal length: {length}\tAverage length: {avg_length}")


