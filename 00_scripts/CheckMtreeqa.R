library(dplyr)
library(tidyverse)
library(gt)
#------------------------------import-------------------------------
treeqa<- read.delim("02_middle-analysis_outputs/CheckM/checkmtreeqa/checkmtreeqa_bigsummary.txt", header = TRUE, sep = "\t")
#-----------------------------clean-------------------------------
treeqa$Bin.Id <- gsub("flye_asm_|_part2", "", as.character(treeqa$Bin.Id))
names(treeqa) <- gsub("\\.", "", names(treeqa))
#-----------------------------tabulate--------------------------------
write.csv(treeqa, file = "03_final_outputs/metadata_and_quality_tables/checkmtreeqa.csv", row.names = FALSE)
