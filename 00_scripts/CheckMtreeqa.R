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
#----------------------------stuff for Markdown doc [DONT RUN]-------------------


columnnames <- c("BinId", "Xuniquemarkersof43", "Taxonomycontained","Taxonomysisterlineage")
treeqa$Taxonomycontained <- gsub(";", "&#8594;", treeqa$Taxonomycontained)
treeqa$Taxonomysisterlineage <- gsub(";", "&#8594;", treeqa$Taxonomysisterlineage)
treeqa[columnnames] %>%
  gt() %>%
  tab_source_note(source_note = "Source: CheckM tree_qa performed on 2024-12-30") %>%
  opt_row_striping() %>%
  opt_stylize(style = 5, color = "blue") %>%
  tab_header(
    title = "Table 6 - subset of data obtained from secondary CheckM analysis",
    subtitle = md("of samples taken from the skin microbiome of *Dendrobates tinctorius*, including taxonomy at various levels")
  ) %>%
  fmt_markdown(
    columns = c(Taxonomycontained, Taxonomysisterlineage),
    rows = everything(),
    md_engine = "markdown"
  )


