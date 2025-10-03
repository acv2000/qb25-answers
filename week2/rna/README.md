hisat2 -x sacCer3 -U ../rawdata/SRR10143769.fastq -S SRR10143769.sam
samtools sort SRR10143769.sam -o SRR10143769.bam
samtools index SRR10143769.bam