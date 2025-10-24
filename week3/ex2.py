#!/usr/bin/env python3
import sys

vcf_file = "/Users/cmdb/qb25-answers/week3/biallelic.vcf"
af_output = "AF.txt"
dp_output = "DP.txt"

with open(vcf_file) as vcf, open(af_output, 'w') as af_out, open(dp_output, 'w') as dp_out:
    af_out.write("Allele_Frequency\n")
    dp_out.write("Read_Depth\n")
    for line in open(vcf_file):
        if line.startswith('#'):
            continue
        fields = line.rstrip('\n').split('\t')
        info_field = fields[7]
        for entry in info_field.split(';'):
            if entry.startswith("AF="):
                af_values = entry.split('=')[1] # split AF value after = and select value after that 
                for af in af_values.split(','):  # split string into list ['0.12', '0.45']
                    af_out.write(f"{af}\n")
                break
        sample_fields = fields[9:]
    
        for sample in sample_fields:
            sample_values = sample.split(':')
            dp_values = sample_values[2]
            dp_out.write(f"{dp_values}\n")
            
            
# 2.2 The histogram displays a somewhat normal distrubution with most allele frequencies around 0.4 this was surprising to me considering you would expect the hisotgram to skew to the left. 
# 2.3 The second histogram shows that most reads have lower depths between 5 and 15. This distribution looks like a right-skewed distribution, which is typical for sequencing data.