#!/usr/bin/env python3
import sys

#3.1 
#In this region of the genome I believe samples A01_09, A01_11, A01_23, A01_35, and A01_39 derives from the lab strain. While this region in samples A01_24, A01_27, A01_31, A01_62, and A01_63 derives from the wine strain. 

#3.2 
sample_ids = ["A01_62", "A01_39", "A01_63", "A01_35", "A01_31",
              "A01_27", "A01_24", "A01_23", "A01_11", "A01_09"]

vcf_file = "/Users/cmdb/qb25-answers/week3/biallelic.vcf"  
output_file = "gt_long.txt"

with open(vcf_file) as vcf, open(output_file, 'w') as out:
    out.write("SampleID\tChromosome\tPosition\tGenotype\n")
    for line in vcf:
        if line.startswith('#'):
            continue
        fields = line.strip().split('\t')
        chrom = fields[0]
        pos = fields[1]
        sample_data = fields[9:]
        for i, sample in enumerate(sample_ids): #way to get index and sample id 
            genotype_str = sample_data[i].split(':')[0]
            allele = genotype_str[0]
            if allele in ['0', '1']:
                out.write(f"{sample}\t{chrom}\t{pos}\t{allele}\n")

#3.3 
#More central regions of chromosome II in this sample map to the reference genome while regions further from the center map to the other genome. This is indicative of the fact that recombination events are more common the further away you are from centromeres. 

