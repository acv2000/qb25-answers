# Exercise 1: PCA analysis
library(tidyr)
library(dplyr)
library(matrixStats)

setwd("~/qb25-answers/week7")

read_matrix <-read.delim("read_matrix.tsv", row.names = 1, check.names = FALSE)
read_matrix = as.matrix(read_matrix)

# Fix mislabeled columns
swap <- match(c("LFC-Fe_Rep3", "Fe_Rep1"), colnames(read_matrix))
read_matrix[, swap] <- read_matrix[, rev(swap)]

reads_sds <- rowSds(read_matrix)
top500_vargene <- order(reads_sds, decreasing = TRUE)[1:500]
expr_top500 <- read_matrix[top500_vargene, ]

expr_t <- t(expr_top500)
norm_expr_t = scale(expr_t)
pca_expr <- prcomp(expr_t, center = TRUE)
summary(pca_expr)

pca_df <- as_tibble(pca_expr$x[, 1:2], rownames = "Sample")
pca_df <- pca_df %>%
  tidyr::separate(Sample, into = c("Tissue", "Replicate"), sep = "_", remove = FALSE)

pca_summary <- tibble(
  PC = 1:length(pca_expr$sdev),
  sd = pca_expr$sdev) %>%
  mutate(
    var = sd^2,
    norm_var = var / sum(var))

pca_summary %>% ggplot(aes(PC, norm_var)) + 
  geom_line() +
  geom_point()
ggsave("PCA_variance_plot.png", width = 6, height = 4)

ggplot(pca_df, aes(x = PC1, y = PC2, color = Tissue, shape = Replicate)) +
  geom_point(size = 3) +
  labs(title = "PCA of Top 500 Variable Genes",
       x = "PC1",
       y = "PC2") +
  theme_minimal()
ggsave("PCA_plot.png", width = 6, height = 5)

# Calculate variance
variance_pca <- (pca_results$sdev)^2 / sum(pca_results$sdev^2)

bar_df <- tibble(PC = paste0("PC", 1:length(variance_pca)),
                 Variance = variance_pca)

ggplot(bar_df, aes(x = PC, y = Variance)) +
  geom_bar(stat = "identity", fill = "plum") +
  theme_minimal() +
  labs(title = "Variance Explained by Principal Components",
       x = "Principal Component",
       y = "Proportion of Variance Explained")
ggsave("PCA_variance.png", width = 6, height = 4)

# Exercise 2: K-means clustering
combined <- read_matrix[, seq(1, 21, 3)]
combined <- combined + read_matrix[, seq(2, 21, 3)]
combined <- combined + read_matrix[, seq(3, 21, 3)]
combined <- combined / 3

gene_var_combined <- rowSds(combined)
combined_fil <- combined[gene_var_combined > 1, ]

set.seed(42)
k_clusters <- kmeans(combined_fil, centers = 12, nstart = 100)
labels <- k_clusters$cluster

sorted_id <- order(labels)
sorted_data <- combined_fil[sorted_id, ]
sorted_labels <- labels[sorted_id]

library(RColorBrewer)
png("heatmap.png", width = 800, height = 800)
heatmap(sorted_data,
        Rowv = NA, Colv = NA,
        RowSideColors = brewer.pal(12, "Paired")[sorted_labels],
        ylab = "Gene")
dev.off()

# Exercise 3: Gene ontology enrichment analysis
cluster3_genes <- rownames(sorted_data)[sorted_labels == 3]
cluster2_genes <- rownames(sorted_data)[sorted_labels == 2]

write.table(cluster3_genes, "cluster3_genes.txt", quote = FALSE, row.names = FALSE, col.names = FALSE)
write.table(cluster2_genes, "cluster2_genes.txt", quote = FALSE, row.names = FALSE, col.names = FALSE)

