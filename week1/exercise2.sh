# 2 Compare hg19 gene annotations with hg16
wget https://hgdownload.soe.ucsc.edu/goldenPath/hg16/bigZips/hg16.chrom.sizes 
grep -v _ hg16.chrom.sizes > hg16-main.chrom.sizes
bedtools makewindows -g hg16-main.chrom.sizes -w 1000000 > hg16-1mb.bed
cut -f1-3,5 hg16-kc.tsv > hg16-kc.bed
bedtools intersect -c -a hg16-1mb.bed -b hg16-kc.bed > hg16-kc-count.bed
wc -l hg16-kc-count.bed 
wc -l hg19-kc.bed 
# 80270 genes in hg19 
bedtools intersect -v -a hg19-kc.bed -b hg16-kc.bed > hg19-unique.bed 
wc -l hg19-unique.bed
# 42717 genes in hg19 but not in hg16 
# hg19 is a more complete version of human reference genome using a more advanced assembly process (ie: prediction software) it makes sense that more genes would be in hg19 than hg16
wc -l hg16-kc.bed
# 21365 genes in hg16
bedtools intersect -v -a hg16-kc.bed -b hg19-kc.bed > hg16-unique.bed
wc -l hg16-unique.bed
# 3460 genes in hg19 but not in hg16 
# Some genes are in hg16 and not in hg19 because upon updating the assembly and annotations some duplications, and sequencing aritifacts for example were probably removed. 

