#!/usr/bin/env python3

import sys
import fasta

my_file = open( sys.argv[1] )
contigs = fasta.FASTAReader(my_file)

for contig in contigs: 
    print(contig[0])

# for ident, sequence in assemblies:
#     print( f"Name: {ident}" )
#     print(f”First 20 nucleotides: {sequence[:20]}")
