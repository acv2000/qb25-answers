#!/usr/bin/env python3

import sys

my_file = open( sys.argv[1] )

for line in my_file: 
    column = line.strip("\n") 
    column2 = column.split("\t")
    original_score = int(column2[4])
    start = int(column2[1])
    end = int(column2[2])
    new_score = original_score*(end - start)
    strand = column2[5]
    if strand =="-":
        finalnew_score = new_score * -1
    else:
        finalnew_score = new_score
    print(f"{column2[0]}\t{start}\t{end}\t{column2[3]}\t{finalnew_score}\t{strand}")