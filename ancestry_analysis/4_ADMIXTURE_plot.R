library(tidyverse)
library(tidyr)

df_fam <- read.table("merged.fam")
df_admx_q <- read.table("merged.5.Q")

combined_df <- cbind(df_fam, df_admx_q)
combined_df <- combined_df[,c(-3,-4,-5,-6)]

names(combined_df)[1] <- "ancestry"
names(combined_df)[2] <- "Sample_ID"
names(combined_df)[3] <- "East Asia"
names(combined_df)[4] <- "South Asia"
names(combined_df)[5] <- "Europe"
names(combined_df)[6] <- "America"
names(combined_df)[7] <- "Africa"

samples_df <- combined_df %>% 
  filter(grepl("^MEGA", Sample_ID))

samples_df <- samples_df %>%
  mutate(ancestry = case_when(
    Africa > 0.7 ~ "Africa",
    Europe > 0.7 ~ "Europe",
    `East Asia` > 0.7 ~ "East Asia",
    `South Asia` > 0.7 ~ "South Asia",
    America > 0.7 ~ "America",
    TRUE ~ ancestry  # default to current value if none meet condition
  ))



samples_df$ancestry <- gsub("0", "Admixed", samples_df$ancestry)

write.csv(samples_df,"ADMIXTURE_MEGA_all_all_ancestries.csv")

# Reshape the data from wide to long format
samples_long <- samples_df %>%
  mutate(Sample_ID = factor(Sample_ID),
         Sample_ID = reorder(Sample_ID, Europe)) %>%
  pivot_longer(cols = c("Europe","Africa","East Asia","South Asia","America"), 
               names_to = "Ancestry", 
               values_to = "Proportion")


samples_long <- samples_long %>% mutate(Percentage = Proportion*100)

samples_long <- samples_long %>%
  mutate(Ancestry = factor(Ancestry, levels = c("Africa","South Asia","America","East Asia","Europe")))


ggplot(samples_long, aes(x = as.numeric(Sample_ID), y = Percentage, fill = Ancestry)) +
  geom_col(position = position_stack(reverse = F), width = 1) +  # width=1 removes gaps
  scale_fill_manual(values = c("Europe" = "#984EA3", 
                               "Africa" = "#E41A1C", 
                               "East Asia" = "#4DAF4A",
                               "South Asia" = "#FF7F00",
                               "America" = "#377EB8")) +
  scale_x_continuous(
    breaks = 1:nrow(samples_df),
    labels = levels(samples_long$Sample_ID),
    expand = c(0, 0)  # Remove padding on x-axis
  ) +
  labs(title = "Ancestry Proportions - All MEGA samples",
       x = "Samples",
       y = "Percentage (%)") +
  theme_minimal() +
  theme(
    axis.text.x = element_text(size = 0),
    panel.grid.major.x = element_blank(),
    panel.grid.minor.x = element_blank()
  )


