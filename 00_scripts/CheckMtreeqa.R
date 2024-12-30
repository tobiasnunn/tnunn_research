library(dplyr)
library(tidyverse)
library(gt)
#------------------------------import-------------------------------
treeqa<- read.delim("02_middle-analysis_outputs/CheckM/checkmtreeqa/checkmtreeqa_bigsummary.txt", header = TRUE)
#-----------------------------clean-------------------------------
treeqa$Bin.Id <- as.vector(lapply(treeqa$Bin.Id, function(x) gsub("flye_asm_|_part2", "", x)))
#-----------------------------tabulate--------------------------------
str(treeqa)
write.csv(treeqa, file = "03_final_outputs/metadata_and_quality_tables/checkmtreeqa.csv", row.names = FALSE)

#----------------------------stuff for Markdown doc [DONT RUN]-------------------
columnnames <- c("Bin.Id", "X..unique.markers..of.43.", "Taxonomy..contained.","Taxonomy..sister.lineage.")
treeqa[columnnames] %>%
  gt() %>%
  tab_source_note(source_note = "Source: CheckM tree_qa performed on 2024-12-30") %>%
  opt_row_striping() %>%
  opt_stylize(style = 5, color = "blue") %>%
  tab_header(
    title = "Table 6 - subset of data obtained from secondary CheckM analysis",
    subtitle = md("of samples taken from the skin microbiome of *Dendrobates tinctorius*, including taxonomy at various levels")
  )
