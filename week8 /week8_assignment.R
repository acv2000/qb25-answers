library(tidyverse)
library(DESeq2)
library(broom)

#Set working directory 
setwd("~/qb25-answers/week8 /")

# Exercise 1: 

# Load gene expression counts
counts_df <- read_delim("gtex_whole_blood_counts_downsample.txt")
counts_df[1:5,]
counts_df <- column_to_rownames(counts_df, var = "GENE_NAME")
counts_df[1:5,]

# Load metadata 
metadata_df <- read_delim("gtex_metadata_downsample.txt")
metadata_df[1:5,]
metadata_df <- column_to_rownames(metadata_df, var = "SUBJECT_ID")
metadata_df[1:5,]

# Confirm that ordering is correct 
colnames(counts_df) == rownames(metadata_df) # need to have the same length! 

# Create DESeq2 object
dds <- DESeqDataSetFromMatrix(countData = counts_df,
                              colData = metadata_df,
                              design = ~ SEX + AGE + DTHHRDY)
# PCA 
vsd <- vst(dds)
plotPCA(vsd, intgroup = "AGE")
plotPCA(vsd, intgroup = "SEX")
plotPCA(vsd, intgroup = "DTHHRDY")

# 48% percent of the variance in gene expression is explained by PC1 and 7% of the variance is explained by PC2. 
# PC1 seems to be associated with the "DTHHRDY" (death condition) variable, PC2 on the other hand doesn't seem to be associated to any variable in particular. 

# Exercise 2: 
vsd_df <- assay(vsd) %>%
  t() %>%
  as_tibble()

vsd_df <- bind_cols(metadata_df, vsd_df)

m1 <- lm(formula = WASH7P ~ DTHHRDY + AGE + SEX, data = vsd_df) %>%
  summary() %>%
  tidy()

#It doesn't really seem like WASH7P has sex-differential expression, males have am slight increase in SLC25A47 expression but this increase is not significant. 

m2 <- lm(formula =  SLC25A47 ~ DTHHRDY + AGE + SEX, data = vsd_df) %>%
  summary() %>%
  tidy()

#SLC25A47 does have display a sex-differential expression pattern, males express this gene more and this increase is expression is statistically significant (p<0.05). 

dds <- DESeq(dds)

sex_dif <- results(dds, name = "SEX_male_vs_female") %>%
  as_tibble(rownames = "GENE_ID")

sig_gene <- sex_dif %>%
  filter(!is.na(padj) & padj < 0.1) #filters out nans 

nrow(sig_gene)

# There are 262 significant genes! 

chrom_loc <- read_delim("gene_locations.txt")
names(chrom_loc)[names(chrom_loc) == "GENE_NAME"] <- "GENE_ID" 
#needed to rename to use left join, I kept getting errors using "rename" function that didn't make sense this base R code worked though?

merged_chr_sex <- left_join(sex_dif, chrom_loc, by = "GENE_ID")
ordered_chr_sex <- merged_chr_sex %>%
  arrange(padj)
head(ordered_chr_sex, 10)

male_up   <- ordered_chr_sex %>% filter(log2FoldChange > 0 & padj < 0.1)
female_up <- ordered_chr_sex %>% filter(log2FoldChange < 0 & padj < 0.1)

# Upregulated genes in males with a negative log fold change, are located on the Y chromosome. 
# Upregulated genes in females with a negative log fold change, are located on the X chromosome. 
# The genes with the most significant results are mostly male-upregulated genes, which reflects the fact that Y expression is unique to males. 

sex_dif %>%
  filter(GENE_ID %in% c("WASH7P", "SLC25A47"))
# Only SLC25A47 is coming up in my object because I filtered for significant p-values, this is consistent with my findings in the linear regression model. 

# If you use a very stringent FDR threshold this significantly minimizes false positives, this means that we can be very confident that these genes are differentially expressed. 
# However, this also means there will be an increase in false negatives, some genuinely deferentially expressed genes will not fall under the significance threshold. 
# This is the opposite when you use a more lenient threshold, you will have less false negatives but more false positives. 
# A larger sample sizes will increase the statistical power of the analysis and make it easier to detect differentially expressed genes.

death_dif <- results(dds, name = "DTHHRDY_ventilator_case_vs_fast_death_of_natural_causes") %>%
  as_tibble(rownames = "GENE_ID")

sig_death_gene <- death_dif %>%
  filter(!is.na(padj) & padj < 0.1)

nrow(sig_death_gene)
# There are 16069 significant genes!

dds_perm <- dds
colData(dds_perm)$SEX <- factor(colData(dds_perm)$SEX)
colData(dds_perm)$Sex_perm <- factor(sample(colData(dds_perm)$SEX))
design(dds_perm) <- ~ Sex_perm
dds_perm <- DESeq(dds_perm)

res_perm <- results(dds_perm, contrast = c("Sex_perm", "male", "female")) 
sig_genes_perm <- sum(res_perm$padj < 0.10, na.rm = TRUE)
nrow(sig_genes_perm)
# My real and permuted results are very similar (perm=267) this indicates that these significant genes not reflect biological differences. 
# FDR thresholds are important!

results_sex <- results(dds, name = "SEX_male_vs_female") %>%
  as_tibble(rownames = "GENE_ID")

results_sex$significant <- ifelse(!is.na(results_sex$padj) & results_sex$padj < 0.10 & abs(results_sex$log2FoldChange) > 1, "Significant", "Not Significant")

volcano_plot <- ggplot(results_sex, aes(x = log2FoldChange, y = -log10(padj), color = significant)) +
  geom_point(alpha = 0.6, size = 2) +
  scale_color_manual(values = c("Significant" = "red", "Not Significant" = "grey")) +
  theme_minimal() +
  labs(
    title = "Volcano Plot of Differential Expression",
    x = "log2(Fold Change)",
    y = "-log10(Adjusted p-value)",
    color = "Significance"
  ) +
  theme(
    plot.title = element_text(hjust = 0.5),
    legend.position = "right"
  ) # some values have a basically 0 p-value --> I can't fix this sorry 

ggsave("volcano_plot.png", plot = volcano_plot, width = 8, height = 6, dpi = 300)
