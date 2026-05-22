library(tidyverse)

# Scree plot
eigenval <- read.table("pca_samples_all_postQC_results.eigenval")
plot(eigenval$V1, type="b", 
     xlab="PC", ylab="Eigenvalue",
     main="Genotype PCs")

eigenvec <- read.table("pca_samples_all_postQC_results.eigenvec")

names(eigenvec)[1] <- "FID"
names(eigenvec)[2] <- "Sample_ID"
names(eigenvec)[3] <- "PC1"
names(eigenvec)[4] <- "PC2"
names(eigenvec)[5] <- "PC3"
names(eigenvec)[6] <- "PC4"
names(eigenvec)[7] <- "PC5"
names(eigenvec)[8] <- "PC6"
names(eigenvec)[9] <- "PC7"
names(eigenvec)[10] <- "PC8"
names(eigenvec)[11] <- "PC9"
names(eigenvec)[12] <- "PC10"

samples_df <- read.csv("ADMIXTURE_5_ancestries.csv", row.names=1 )

merged_df <- merge(eigenvec, samples_df, by = "Sample_ID")

ggplot(merged_df, aes(x=PC1, y=PC2, color=ancestry)) + geom_point(size=1.5,alpha=0.7) + theme_bw() +
  scale_color_manual(values = c("Europe" = "#984EA3", 
                               "Africa" = "#E41A1C", 
                               "East Asia" = "#4DAF4A",
                               "Admixed" = "grey"))

ggplot(merged_df, aes(x=PC1, y=PC3, color=ancestry)) + geom_point(size=1.5,alpha=0.7) + theme_bw()+
  scale_color_manual(values = c("Europe" = "#984EA3", 
                                "Africa" = "#E41A1C", 
                                "East Asia" = "#4DAF4A",
                                "Admixed" = "grey"))

ggplot(merged_df, aes(x=PC1, y=PC4, color=ancestry)) + geom_point(size=1.5,alpha=0.7) + theme_bw()+
  labs(color = "Ancestry") + 
  scale_color_manual(values = c("Europe" = "#984EA3", 
                                "Africa" = "#E41A1C", 
                                "East Asia" = "#4DAF4A",
                                "Admixed" = "grey"))

ggplot(merged_df, aes(x=PC2, y=PC3, color=ancestry)) + geom_point(size=1.5,alpha=0.7) + theme_bw()+
  scale_color_manual(values = c("Europe" = "#984EA3", 
                                "Africa" = "#E41A1C", 
                                "East Asia" = "#4DAF4A",
                                "Admixed" = "grey"))

ggplot(merged_df, aes(x=PC2, y=PC4, color=ancestry)) + geom_point(size=1.5,alpha=0.7) + theme_bw()+
  labs(color = "Ancestry") + 
  scale_color_manual(values = c("Europe" = "#984EA3", 
                                "Africa" = "#E41A1C", 
                                "East Asia" = "#4DAF4A",
                                "Admixed" = "grey"))

ggplot(merged_df, aes(x=PC3, y=PC4, color=ancestry)) + geom_point(size=1.5,alpha=0.7) + theme_bw()+
  labs(color = "Ancestry") + 
  scale_color_manual(values = c("Europe" = "#984EA3", 
                                "Africa" = "#E41A1C", 
                                "East Asia" = "#4DAF4A",
                                "Admixed" = "grey"))


merged_df <- merged_df[, c("Sample_ID","PC1","PC2","PC3","ancestry","Europe","Africa","East.Asia","South.Asia","America")]

names(merged_df)[2] <- "genotype_PC1"
names(merged_df)[3] <- "genotype_PC2"
names(merged_df)[4] <- "genotype_PC3"
names(merged_df)[5] <- "ancestry_categorical"

write.csv(merged_df,"metadata_combined_samples_genotypePCs_ancestry.csv")
