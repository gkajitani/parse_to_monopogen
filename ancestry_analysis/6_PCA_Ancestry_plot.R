library(tidyverse)

setwd("/projects/thor_human-AUDIT/people/zrj346/R_Scripts/ancestry_analysis")

# Data and code for plotting the top 10 genotype PCs are in /projects/thor_human-AUDIT/people/zrj346/vcf_PLINK/MEGA_SCZ/ancestry_analysis/PCA/PCA_plot.R
# Data and code for plotting ADMIXTURE-based ancestry analysis are in /projects/thor_human-AUDIT/people/zrj346/vcf_PLINK/MEGA_SCZ/ancestry_analysis/ADMIXTURE/plot_ADMXITURE_all_ancestries.R

merged_df <- read.csv("metadata_MEGA_SCZ_ALL_genotypePCs_ancestry.csv", row.names=1)

ggplot(merged_df, aes(x=genotype_PC1, y=genotype_PC2, color=ancestry_categorical)) + geom_point(size=1.5,alpha=0.7) + theme_bw() +
  labs(x = "PC1", y = "PC2", color = "Ancestry") + 
  scale_color_manual(values = c("Europe" = "#984EA3", 
                                "Africa" = "#E41A1C", 
                                "East Asia" = "#4DAF4A",
                                "Admixed" = "grey"))

ggplot(merged_df, aes(x=genotype_PC1, y=genotype_PC3, color=ancestry_categorical)) + geom_point(size=1.5,alpha=0.7) + theme_bw()+
  labs(x = "PC1", y = "PC3", color = "Ancestry") + 
  scale_color_manual(values = c("Europe" = "#984EA3", 
                                "Africa" = "#E41A1C", 
                                "East Asia" = "#4DAF4A",
                                "Admixed" = "grey"))


ggplot(merged_df, aes(x=genotype_PC2, y=genotype_PC3, color=ancestry_categorical)) + geom_point(size=1.5,alpha=0.7) + theme_bw()+
  labs(x = "PC2", y = "PC3", color = "Ancestry") + 
  scale_color_manual(values = c("Europe" = "#984EA3", 
                                "Africa" = "#E41A1C", 
                                "East Asia" = "#4DAF4A",
                                "Admixed" = "grey"))

samples_df <- merged_df[, c("Sample_ID","Europe","Africa","East.Asia","South.Asia","America")]

names(samples_df)[4] <- "East Asia"
names(samples_df)[5] <- "South Asia"

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


# Using k-means to evaluate categorical ancestries (using 10 clusters max to plot screeplot then get the optimal k)
cols    <- c("Europe", "Africa", "East.Asia", "South.Asia")
k_max   <- 10

df_scaled <- scale(merged_df[, cols])

# Plotting within-cluster sum of squares

wss <- sapply(1:k_max, function(k) {
  kmeans(df_scaled, centers = k, nstart = 25, iter.max = 100)$tot.withinss
})

elbow_df <- data.frame(k = 1:k_max, wss = wss)

ggplot(elbow_df, aes(x = k, y = wss)) +
  geom_line() +
  geom_point(size = 2.5) +
  scale_x_continuous(breaks = 1:k_max) +
  labs(
    title = "Screeplot (k-means test)",
    x     = "Number of clusters (k)",
    y     = "Total within-cluster SS"
  ) +
  theme_minimal()


###############
# Using k = 5 #
###############

k <- 5

set.seed(10001)


km <- kmeans(df_scaled, centers = k, nstart = 25, iter.max = 100)

merged_df$cluster <- factor(km$cluster, labels = paste0("C", seq_len(k)))

ggplot(merged_df, aes(x=genotype_PC1, y=genotype_PC2, color=cluster)) + geom_point(size=1.5,alpha=0.7) + theme_bw()+
  labs(x = "PC1", y = "PC3", color = "Ancestry")


merged_df$cluster_categorical <- merged_df$cluster

merged_df$cluster_categorical <- gsub("C1","Admixed-like-1",merged_df$cluster_categorical)

merged_df$cluster_categorical <- gsub("C2","East Asia-like",merged_df$cluster_categorical)

merged_df$cluster_categorical <- gsub("C3","Africa-like",merged_df$cluster_categorical)

merged_df$cluster_categorical <- gsub("C4","Admixed-like-2",merged_df$cluster_categorical)

merged_df$cluster_categorical <- gsub("C5","Europe-like",merged_df$cluster_categorical)


ggplot(merged_df, aes(x=genotype_PC1, y=genotype_PC2, color=cluster_categorical)) + geom_point(size=1.5,alpha=0.7) + theme_bw()+
  labs(x = "PC1", y = "PC2", color = "Ancestry") + 
  scale_color_manual(values = c("Europe-like" = "#984EA3", 
                                "Africa-like" = "#E41A1C", 
                                "East Asia-like" = "#4DAF4A",
                                "Admixed-like-1" = "#FF7F00",
                                "Admixed-like-2" = "grey"))+
  theme(legend.text = element_text(size=11), legend.title = element_text(size=10)) + guides(color = guide_legend(override.aes = list(size = 2)))



ggplot(merged_df, aes(x=genotype_PC1, y=genotype_PC3, color=cluster_categorical)) + geom_point(size=1.5,alpha=0.7) + theme_bw()+
  labs(x = "PC1", y = "PC3", color = "Ancestry") + 
  scale_color_manual(values = c("Europe-like" = "#984EA3", 
                                "Africa-like" = "#E41A1C", 
                                "East Asia-like" = "#4DAF4A",
                                "Admixed-like-1" = "#FF7F00",
                                "Admixed-like-2" = "grey"))+
  theme(legend.text = element_text(size=11), legend.title = element_text(size=10)) + guides(color = guide_legend(override.aes = list(size = 2)))


ggplot(merged_df, aes(x=genotype_PC2, y=genotype_PC3, color=cluster_categorical)) + geom_point(size=1.5,alpha=0.7) + theme_bw()+
  labs(x = "PC2", y = "PC3", color = "Ancestry") + 
  scale_color_manual(values = c("Europe-like" = "#984EA3", 
                                "Africa-like" = "#E41A1C", 
                                "East Asia-like" = "#4DAF4A",
                                "Admixed-like-1" = "#FF7F00",
                                "Admixed-like-2" = "grey"))+
  theme(legend.text = element_text(size=11), legend.title = element_text(size=10)) + guides(color = guide_legend(override.aes = list(size = 2)))


write.csv(merged_df,"metadata_MEGA_SCZ_ALL_genotypePCs_ancestry_kmeans_5.csv")


merged_df_long <- merged_df %>%
  pivot_longer(
    cols = c("Europe","Africa","East.Asia","South.Asia"),
    names_to = "variable",
    values_to = "value"
  )


cluster_order <- c("Europe-like", 
                   "Africa-like", 
                   "East Asia-like",
                   "Admixed-like-1",
                   "Admixed-like-2")

merged_df_long$cluster_categorical <- factor(merged_df_long$cluster_categorical, levels = rev(cluster_order))



ggplot(merged_df_long,
       aes(x = cluster_categorical,
           y = value,
           fill = variable)) +
  geom_boxplot(
    position = position_dodge(width = 0.8)) +
  theme_bw() +  labs(x = "Categorical ancestry group",y = "Ancestry fractions",fill = "Ancestry") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))+
  scale_fill_manual(values = c("Europe" = "#984EA3", 
                                "Africa" = "#E41A1C", 
                                "East.Asia" = "#4DAF4A",
                                "South.Asia" = "#FF7F00")) + coord_flip()


cats <- unique(merged_df_long$cluster_categorical)
n_cats <- length(cats)

bg_df <- data.frame(
  xmin = seq(0.5, n_cats - 0.5, by = 1),
  xmax = seq(1.5, n_cats + 0.5, by = 1),
  fill_bg = rep(c("white", "gray95"), length.out = n_cats)
)

ggplot(merged_df_long,
       aes(x = cluster_categorical,
           y = value,
           fill = variable)) +
  geom_rect(
    data = bg_df,
    aes(xmin = xmin, xmax = xmax, ymin = -Inf, ymax = Inf, fill = NULL),
    fill = bg_df$fill_bg,
    inherit.aes = FALSE
  ) +
  geom_boxplot(position = position_dodge(width = 0.8)) +
  geom_hline(yintercept = seq(0, 1, by = 0.25), color = "grey70", linewidth = 0.3) +
  labs(x = "Categorical ancestry group", y = "Ancestry fractions", fill = "Ancestry") +
  theme(
    axis.text.x = element_text(angle = 45, hjust = 1),
    panel.background = element_blank(),
    panel.border = element_rect(color = "black", fill = NA),
    panel.grid = element_blank(),
    axis.line = element_line(color = "black"),
    strip.background = element_rect(fill = "white", color = "black")
  ) +
  scale_fill_manual(values = c("Europe" = "#984EA3",
                               "Africa" = "#E41A1C",
                               "East.Asia" = "#4DAF4A",
                               "South.Asia" = "#FF7F00")) +
  coord_flip()

###############
# Using k = 4 #
###############


k2 <- 4

set.seed(10001)


km2 <- kmeans(df_scaled, centers = k2, nstart = 25, iter.max = 100)

df <- merged_df

df$cluster <- factor(km2$cluster, labels = paste0("C", seq_len(k2)))

ggplot(df, aes(x=genotype_PC1, y=genotype_PC2, color=cluster)) + geom_point(size=1.5,alpha=0.7) + theme_bw()+
  labs(x = "PC1", y = "PC2", color = "Ancestry")

df$cluster_categorical <- df$cluster

df$cluster_categorical <- gsub("C1","East Asia-like",df$cluster_categorical)

df$cluster_categorical <- gsub("C2","Europe-like",df$cluster_categorical)

df$cluster_categorical <- gsub("C3","Africa-like",df$cluster_categorical)

df$cluster_categorical <- gsub("C4","Admixed-like",df$cluster_categorical)

ggplot(df, aes(x=genotype_PC1, y=genotype_PC2, color=cluster_categorical)) + geom_point(size=1.5,alpha=0.7) + theme_bw()+
  labs(x = "PC1", y = "PC2", color = "Ancestry") + 
  scale_color_manual(values = c("Europe-like" = "#984EA3", 
                                "Africa-like" = "#E41A1C", 
                                "East Asia-like" = "#4DAF4A",
                                "Admixed-like" = "#FF7F00"))+
  theme(legend.text = element_text(size=11), legend.title = element_text(size=10)) + guides(color = guide_legend(override.aes = list(size = 2)))


ggplot(df, aes(x=genotype_PC1, y=genotype_PC3, color=cluster_categorical)) + geom_point(size=1.5,alpha=0.7) + theme_bw()+ 
  labs(x = "PC1", y = "PC3", color = "Ancestry") + 
  scale_color_manual(values = c("Europe-like" = "#984EA3", 
                                "Africa-like" = "#E41A1C", 
                                "East Asia-like" = "#4DAF4A",
                                "Admixed-like" = "#FF7F00")) +
  theme(legend.text = element_text(size=11), legend.title = element_text(size=10)) + guides(color = guide_legend(override.aes = list(size = 2)))


ggplot(df, aes(x=genotype_PC2, y=genotype_PC3, color=cluster_categorical)) + geom_point(size=1.5,alpha=0.7) + theme_bw()+
  labs(x = "PC2", y = "PC3", color = "Ancestry") + 
  scale_color_manual(values = c("Europe-like" = "#984EA3", 
                                "Africa-like" = "#E41A1C", 
                                "East Asia-like" = "#4DAF4A",
                                "Admixed-like" = "#FF7F00")) +
  theme(legend.text = element_text(size=11), legend.title = element_text(size=10)) + guides(color = guide_legend(override.aes = list(size = 2)))


write.csv(df,"metadata_MEGA_SCZ_ALL_genotypePCs_ancestry_kmeans_4.csv")


df_long <- df %>%
  pivot_longer(
    cols = c("Europe","Africa","East.Asia","South.Asia"),
    names_to = "variable",
    values_to = "value"
  )

cluster_order <- c("Europe-like", 
                   "Africa-like", 
                   "East Asia-like",
                   "Admixed-like")

df_long$cluster_categorical <- factor(df_long$cluster_categorical, levels = rev(cluster_order))


ggplot(df_long,
       aes(x = cluster_categorical,
           y = value,
           fill = variable)) +
  geom_boxplot(
    position = position_dodge(width = 0.8)) +
  theme_bw() +  labs(x = "Categorical ancestry group",y = "Ancestry fractions",fill = "Ancestry") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))+
  scale_fill_manual(values = c("Europe" = "#984EA3", 
                               "Africa" = "#E41A1C", 
                               "East.Asia" = "#4DAF4A",
                               "South.Asia" = "#FF7F00")) + coord_flip()


cats <- unique(df_long$cluster_categorical)
n_cats <- length(cats)

bg_df <- data.frame(
  xmin = seq(0.5, n_cats - 0.5, by = 1),
  xmax = seq(1.5, n_cats + 0.5, by = 1),
  fill_bg = rep(c("white", "gray92"), length.out = n_cats)
)

ggplot(df_long,
       aes(x = cluster_categorical,
           y = value,
           fill = variable)) +
  geom_rect(
    data = bg_df,
    aes(xmin = xmin, xmax = xmax, ymin = -Inf, ymax = Inf, fill = NULL),
    fill = bg_df$fill_bg,
    inherit.aes = FALSE
  ) +
  geom_boxplot(position = position_dodge(width = 0.8)) +
  geom_hline(yintercept = seq(0, 1, by = 0.25), color = "grey70", linewidth = 0.3) +
  labs(x = "Categorical ancestry group", y = "Ancestry fractions", fill = "Ancestry") +
  theme(
    axis.text.x = element_text(angle = 45, hjust = 1),
    panel.background = element_blank(),
    panel.border = element_rect(color = "black", fill = NA),
    panel.grid = element_blank(),
    axis.line = element_line(color = "black"),
    strip.background = element_rect(fill = "white", color = "black")
  ) +
  scale_fill_manual(values = c("Europe" = "#984EA3",
                               "Africa" = "#E41A1C",
                               "East.Asia" = "#4DAF4A",
                               "South.Asia" = "#FF7F00")) +
  coord_flip()
