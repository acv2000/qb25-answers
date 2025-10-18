library(ggplot2)

setwd("/Users/cmdb/qb25-answers/week3/")

#2.2 Allele frequency spectrum
af_data <- read.table("AF.txt", header = TRUE)
af_plot <- ggplot(af_data , aes(x = Allele_Frequency)) +
  geom_histogram(bins = 11, fill = "orchid3", color = "black") +
  labs(
    title = "Allele Frequency Spectrum",
    x = "Allele Frequency",
    y = "Count"
  ) +
  theme_minimal()
ggsave("allele_freq.png", plot = af_plot, width = 8, height = 6, dpi = 300)
# The histogram displays a somewhat normal distribution with most allele frequencies around 0.4 this was surprising to me considering you would expect the histogram to skew to the left. 

#2.3 Read depth distribution
dp_data <- read.table("/Users/cmdb/qb25-answers/week3/DP.txt", header = TRUE)
dp_data$Read_Depth <- as.numeric(dp_data$Read_Depth)
read_plot <- ggplot(dp_data, aes(x = Read_Depth)) +
  geom_histogram(
    bins = 21,
    fill = "plum1",
    color = "white"
  ) +
  labs(
    title = "Read Depth Distribution Across All Samples",
    x = "Read Depth",
    y = "Number of Observations"
  ) +
  xlim(0, 20) +
  theme_minimal()
ggsave("read_depth.png", plot = read_plot, width = 8, height = 6, dpi = 300)

# The second histogram shows that most reads have lower depths between 5 and 15. This distribution looks like a right-skewed distribution, which is typical for sequencing data.