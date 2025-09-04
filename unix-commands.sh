#Unix Scripts Assignment Day 2: 
#1: Explore ce11_genes.bed using Unix
conda activate qb25
wget https://github.com/bxlab/cmdb-quantbio/raw/refs/heads/main/assignments/bootcamp/lists_loops_conditionals/ce11_genes.bed
#   How many features (lines)?
wc -l ce11_genes.bed #53935
#   How many features per chr? e.g. chrI, chrII
cut -f 1 ce11_genes.bed | uniq -c 
    #5460 chrI
    #12 chrM
    #9057 chrV
    #6840 chrX
    #6299 chrII
    #21418 chrIV
    #4849 chrIII
# How many features per strand? e.g. +, -
cut -f 6 ce11_genes.bed | sort | uniq -c
    #26626 -
    #27309 +

#3: Explore GTEx_Analysis_v8_Annotations_SampleAttributesDS.txt using Unix
# Which three SMTSDs (Tissue Site Detail) have the most samples?
cut -f 6 GTEx_Analysis_v8_Annotations_SampleAttributesDS.txt | sort | uniq -c | sort -k 1 -nr
    # Blood, Brain, & Skin
# How many lines have “RNA”?
grep "RNA" GTEx_Analysis_v8_Annotations_SampleAttributesDS.txt | wc -l 
    # 20017
# How many lines do not have “RNA”?
grep -v "RNA" GTEx_Analysis_v8_Annotations_SampleAttributesDS.txt | wc -l
    #2935



