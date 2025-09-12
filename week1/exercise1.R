# 1. Plot gene density across each chromosome
library(dplyr)
library(tidyverse)
setwd("~/qb25-answers/week1")
header <- c( "chr", "start", "end", "count" )
df_kc <- read_tsv( file = "hg19-kc-count.bed", col_names=header )
df_kc_plot <- ggplot(df_kc, aes(x = start, y = count))+
  geom_line()+
  facet_wrap(~chr, scales="free")
ggsave("exercise1.png", plot = df_kc_plot, width = 20, height = 10, units = "in")
