# Exercise 1
# One bowtie2 and three samtools commands
bowtie2 -p 4 -x ../genomes/sacCer3 -U ~/Data/BYxRM/fastq/A01_01.fq.gz > A01_01.sam
samtools sort -o A01_01.bam A01_01.sam 
samtools index A01_01.bam
# Exercise 2
# Samples A01_01, A01_03, & A01_04 in this chromosomal region possess SNPs characteristic of the RM-11 strain meaning that this region of chrI in those three samples was inherited from the RM-11 parent. This is why there are visual similarity between those three samples on IGV. 
