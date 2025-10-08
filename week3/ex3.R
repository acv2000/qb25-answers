genotypes <- read.table("/Users/cmdb/qb25-answers/week3/gt_long.txt", header=TRUE, sep="\t", stringsAsFactors=FALSE)
subset_data <- subset(genotypes, SampleID == "A01_62" & Chromosome == "chrII")
subset_data$Genotype <- factor(subset_data$Genotype, levels = c("0", "1"))

plot(as.numeric(subset_data$Position), 
     as.numeric(subset_data$Genotype), 
     col = subset_data$Genotype,
     pch = 16,
     xlab = "Position on chrII", 
     ylab = "Genotype (0 = reference, 1 = wine)", 
     main = "Ancestry of Sample A01_62 on chrII",
     yaxt = "n")

axis(2, at=c(0,1), labels=c("0", "1"))
legend("topright", legend = c("Reference (0)", "Wine (1)"),
       col = c("black", "red"), pch = 16)

#3.3 
#More central regions of chromosome II in this sample map to the reference genome while regions further from the center map to the other genome. This is indicative of the fact that recombination events are more common the further away you are from centromeres. 

library(ggplot2)

genotypes <- read.table("/Users/cmdb/qb25-answers/week3/gt_long.txt", header = TRUE, sep = "\t", stringsAsFactors = FALSE)
genotypes$Genotype <- factor(genotypes$Genotype, levels = c("0", "1"))
ggplot(genotypes, aes(x = as.numeric(Position), y = SampleID, color = Genotype)) +
  geom_point(size = 1.5, alpha = 0.8) +
  facet_grid(. ~ Chromosome, scales = "free_x", space = "free_x") +
  scale_color_manual(values = c("0" = "black", "1" = "red")) +
  labs(
    title = "Genotypes of Samples Across Chromosomes",
    x = "Position",
    y = "Sample",
    color = "Genotype"
  ) +
  theme_minimal() +
  theme(
    strip.text.x = element_text(angle = 90),
    axis.text.x = element_text(size = 7)
  ) +
  theme(axis.text.x = element_blank(), axis.ticks.x = element_blank())

