BYxRM_bam % samtools index -M A01*

for sample in A01_09 A01_23 A01_27 A01_35 A01_62 A01_11 A01_24 A01_31 A01_39 A01_63
do
    echo $sample.bam >> bamListFile.txt
    samtools view -c $sample.bam >> read_counts.txt
done 

 freebayes -f ../../week2/genomes/sacCer3.fa  -L bamListFile.txt --genotype-qualities -p 1 > unfiltered.vcf

