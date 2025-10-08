# Plot Read Depth 
dp_data <- read.table("/Users/cmdb/qb25-answers/week3/DP.txt", header = TRUE)
dp_data$Read_Depth <- as.numeric(dp_data$Read_Depth)

hist(
  dp_data$Read_Depth,
  breaks = 21,
  col = "plum1",
  main = "Read Depth Distribution Across All Samples",
  xlab = "Read Depth",
  ylab = "Number of Observations",
  xlim = c(0, 20),
  border = "white"
  
# 2.2 The histogram displays a somewhat normal distrubution with most allele frequencies around 0.4 this was surprising to me considering you would expect the hisotgram to skew to the left. 
# 2.3 The second histogram shows that most reads have lower depths between 5 and 15. This distribution looks like a right-skewed distribution, which is typical for sequencing data.