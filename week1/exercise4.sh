# Use bedtools intersect and hg19-kc.bed to determine which gene has the most SNPs
bedtools intersect -c -a hg19-kc.bed -b chr1.bed | sort -k5,5nr > topsnpgenehits.bed
# ENST00000490107.6_7, SMYD3, hg19 chr1:245,912,865-246,670,519, 757,655bp, Exon Count: 12 

# Determine which SNPs lie within vs outside of a gene
bedtools sample -i chr1.bed -n 20 -seed 42 > snp_sample.bed
bedtools sort -i snp_sample.bed > snp_sample.sorted.bed
bedtools sort -i hg19-kc.bed > hg19-kc.sorted.bed
bedtools closest -d -t first -a snp_sample.sorted.bed -b hg19-kc.sorted.bed > snp_and_genes.bed
awk '$11 == 0' snp_and_genes.bed | wc -l
# 15 SNPs inside a gene
awk '$11 > 0 { print $11 }' snp_and_genes.bed | sort -n | awk 'NR==1{min=$1} {max=$1} END{print min, max}'
# Min: 1664 Max: 22944
