#!/usr/bin/env python3

import sys

GTEx_expression = open( sys.argv[1] )

# i unzipped using command line sorry!

_ = GTEx_expression.readline()
_ = GTEx_expression.readline()
header = GTEx_expression.readline().rstrip().split("\t")
DDX11L1 = GTEx_expression.readline().rstrip().split("\t")

gene_expr= {}
for i in range(len(header)): 
    spot = header[i]
    gene_expr[spot]= DDX11L1[i]
# print(gene_expr)

GTEx_expression.close()

metadata = open("/Users/cmdb/Data/GTEx/GTEx_Analysis_v8_Annotations_SampleAttributesDS.txt")

for line in metadata: 
    data = line.strip("\n") 
    list = data.split('\t')
    if list[0] in gene_expr:
        print(f"{list[0]}\t{list[6]}\t{gene_expr[list[0]]}\n")
    
metadata.close()

# Brain, Adrenal gland, & Thyroid



    
    
