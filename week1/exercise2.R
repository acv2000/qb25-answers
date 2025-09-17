# 2 Compare hg19 gene annotations with hg16
library(dplyr)
library(tidyverse)
setwd("~/qb25-answers/week1")
header <- c( "chr", "start", "end", "count" )
df_19kc <- read_tsv( file = "hg19-kc-count.bed", col_names=header )
df_16kc <- read_tsv( file = "hg16-kc-count.bed", col_names=header )
df_comb <- bind_rows( hg19=df_19kc, hg16=df_16kc, .id="assembly" )
df_kc_plot <- ggplot(df_comb, aes(x = start, y = count, color = assembly))+
  geom_line()+
  facet_wrap(~chr, scales="free")
ggsave("exercise2.png", plot = df_kc_plot, width = 20, height = 10, units = "in")
