minimap2 -ax map-ont ../genomes/sacCer3.fa ../rawdata/ERR8562478.fastq > longreads.sam 
samtools sort longreads.sam -o longreads.bam
samtools index longreads.bam
samtools idxstats longreads.bam > longreads.idxstats

