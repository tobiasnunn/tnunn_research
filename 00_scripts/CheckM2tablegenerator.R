library(dplyr)
library(tidyverse)
library(gt)
#------------------------import tsv------------------------------
checkm2 <- read.delim("02_middle-analysis_outputs/CheckM2_20241228/quality_report.tsv", header = TRUE, sep = "\t")
#------------------------cleaning data------------------------
checkm2$Name <-gsub("flye_asm_|_part2","",as.character(checkm2$Name))
#--------------------------table creation------------------------------
checkm2 %>%
  arrange(desc(Completeness)) %>%
  gt()  %>%
  tab_source_note(source_note = "Source: CheckM2 predict performed on 2024-12-28") %>%
  opt_row_striping() %>%
  opt_stylize(style = 5, color = "blue") %>%
  data_color(
    columns = Completeness,
    method = "numeric",
    palette = "Purples",
    domain = c(90, 100),
    reverse = FALSE
  ) %>%
  tab_header(
    title = "Table 4 - quality analysis from CheckM2",
    subtitle = md("based on samples taken from the skin microbiome of *Dendrobates tinctorius*")
  ) %>%
  cols_label(Name = "Accession",
             Completeness_Model_Used = "Completeness model used",
             Translation_Table_Used = "Translation table used",
             Additional_Notes = "Additional notes") %>%
  cols_width(
    Completeness_Model_Used ~ px(250)
  )

write.csv(checkm2, file = "03_final_outputs/metadata_and_quality_tables/checkm2.csv", row.names = FALSE)

