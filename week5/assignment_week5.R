library(tidyverse)
library(dplyr)
library(readr)
library(lubridate)

setwd("~/qb25-answers/week5")

#Step 1
inherited_dnms <- read.csv("/Users/cmdb/qb25-answers/week5/aau1043_dnm.csv", header = TRUE)

filtered_inherited_dnms <- filtered_inherited_dnms <- inherited_dnms %>%
  filter(Phase_combined != "")
table(filtered_inherited_dnms$Phase_combined)

parental_ages <- read.csv("/Users/cmdb/qb25-answers/week5/aau1043_parental_age.csv", header = TRUE)

joined_dnms <- inner_join(filtered_inherited_dnms, parental_ages, by = "Proband_id")

#Step 2 
# Separate maternal and paternal DNMs
maternal_dnms <- joined_dnms %>%
  filter(Phase_combined == "mother")
paternal_dnms <- joined_dnms %>%
  filter(Phase_combined == "father")

# Count mutations by Proband_id and Mother_age
counts_mat <- maternal_dnms %>%
  group_by(Proband_id, Mother_age) %>%
  summarize(count = n())

# Count mutations by Proband_id and Father_age
counts_pat <- paternal_dnms %>%
  group_by(Proband_id, Father_age) %>%
  summarize(count = n())


mat_plot <- ggplot(counts_mat, aes(x= Mother_age, y = count)
       )+ 
  geom_point(color = "palevioletred") +
  labs(
    title = "Maternal DNMs by Motther's Age (per Proband)",
    x = "Mother's Age",
    y = "Count of DNMs")


pat_plot <- ggplot(counts_pat, aes(x= Father_age, y = count)
)+ 
  geom_point(color = "steelblue3") +
  labs(
    title = "Paternal DNMs by Father's Age (per Proband)",
    x = "Father's Age",
    y = "Count of DNMs")

ggsave("ex2_a.png", plot = mat_plot, width = 6, height = 4, dpi = 300)
ggsave("ex2_b.png", plot = pat_plot, width = 6, height = 4, dpi = 300)

#OLS: maternal age vs. maternal DNMs
lm(data = counts_mat, formula = count ~ 1 + Mother_age )%>%
  summary()

#OLS: paternal age vs. paternal DNMs
lm(data = counts_pat, formula = count ~ 1 + Father_age )%>%
  summary()

#Predict for a 50.5-year-old father
paternal_model <- lm(data = counts_pat, formula = count ~ 1 + Father_age )
new_data <- data.frame(Father_age = 50.5)
predict(paternal_model, newdata = new_data)

#Compare distributions of maternal vs. paternal DNMs
counts_mat$Source <- "Maternal"
counts_pat$Source <- "Paternal"
combined_counts <- rbind(counts_mat, counts_pat)
ggplot(combined_counts, aes(x = count, fill = Source)) +
  geom_histogram(alpha = 0.5, position = "identity", bins = 30) +
  labs(title = "Distribution of Maternal vs. Paternal DNMs",
       x = "DNM Count",
       y = "Frequency") +
  scale_fill_manual(values = c("Maternal" = "palevioletred", "Paternal" = "steelblue3")) +
  theme_minimal()
ggsave("ex2_c.png")

#Statistical test: maternal vs. paternal DNMs per proband
merged <- merge(counts_mat, counts_pat, by = "Proband_id", suffixes = c("_mat", "_pat"))
merged$maternal_dnm <- merged$count_mat
merged$paternal_dnm <- merged$count_pat
t_result <- t.test(merged$maternal_dnm, merged$paternal_dnm, paired = TRUE)
t_result

merged$dnm_diff <- merged$paternal_dnm - merged$maternal_dnm
summary(lm(dnm_diff ~ 1, data = merged))

#Explore a new dataset
daily_accidents_420 <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/main/data/2025/2025-04-22/daily_accidents_420.csv')
daily_accidents_420 <- daily_accidents_420 %>%
  filter(!is.na(e420))

ggplot(daily_accidents_420, aes(x = date, y = fatalities_count, color = e420)) +
  geom_point(size = 2) +
  scale_color_manual(
    values = c("FALSE" = "gray60", "TRUE" = "chartreuse4"),
    labels = c("Other Days", "April 20"),
    name = "Date Type"
  ) +
  labs(
    title = "Daily Traffic Fatalities (Highlighting April 20)",
    x = "Date",
    y = "Number of Fatalities"
  ) +
  theme_minimal()
ggsave("ex3_a.png")

daily_accidents_420 <- daily_accidents_420 %>%
  mutate(year = year(date))

avg_fatalities_per_day <- daily_accidents_420 %>%
  group_by(year) %>%
  summarise(
    days_in_data = n(),
    total_fatalities = sum(fatalities_count, na.rm = TRUE),
    avg_fatalities_per_day = mean(fatalities_count, na.rm = TRUE)
  )

ggplot(avg_fatalities_per_day, aes(x = year, y = avg_fatalities_per_day)) +
  geom_line(color = "violetred4", size = 1) +
  geom_point(size = 2) +
  labs(
    title = "Average Fatalities per Day by Year",
    x = "Year",
    y = "Average Fatalities per Day"
  ) +
  theme_minimal()
ggsave("ex3_b.png")

model <- lm(data = daily_accidents_420, formula = fatalities_count ~ 1 +  e420)
summary(model)
