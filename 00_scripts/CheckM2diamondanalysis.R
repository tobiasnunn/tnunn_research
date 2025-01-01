library(dplyr)
library(tidyr)
library(tidyverse)
library(gt)
library(readxl)
#-----------------------------------import---------------------------------
headers <- c("qseqid",	"sseqid",	"pident",	"length",	"mismatch",	"gapopen",	"qstart",	"qend",	"sstart",	"send",	"evalue",	"bitscore")

dires <- read.delim("02_middle-analysis_outputs/CheckM2_20241228/diamond_output/DIAMOND_RESULTS.tsv", header = FALSE)
names(dires) <- headers
#----------------------------------manipulation------------------------
dires$accession <- gsub("flye_asm_|_part2.*", "", dires$qseqid)

dires$ko_value <- gsub(".*~", "", dires$sseqid)

a_1Dt100g <- dires[dires$accession == "1Dt100g",]

a_1Dt100g <- a_1Dt100g %>%
  separate_rows(ko_value, sep = "&")

eggnogorig <- read_excel("02_middle-analysis_outputs/eggnog_stuff/1Dt100g_part2.xlsx", skip = 2, col_names = TRUE)
eggnog_kovalue <- data.frame(ko_value = str_replace_all(eggnogorig$KEGG_ko[-which(eggnogorig$KEGG_ko == "-")], "ko:", ""))
eggnog_kovalue <- eggnog_kovalue %>%
  separate_rows(ko_value, sep = ",")
#-----------------------------------comparison--------------------------
diamondkos <- data.frame(ko_value = unique(a_1Dt100g$ko_value))
eggnogkos <- data.frame(ko_value = unique(eggnog_kovalue$ko_value))
combined <- data.frame(ko_value = unique(c(diamondkos$ko_value, eggnogkos$ko_value)))


combined$eggnog <- combined$ko_value %in% eggnogkos$ko_value
combined$diamond <- combined$ko_value %in% diamondkos$ko_value

both <- nrow(combined[combined$eggnog == TRUE & combined$diamond == TRUE,])
eggnogonly <- nrow(combined[combined$eggnog == TRUE & combined$diamond == FALSE,])
diamondonly <- nrow(combined[combined$eggnog == FALSE & combined$diamond == TRUE,])

# write up investigation into DIAMOND_RESULTS.tsv and output a table with some key metrics
# like how many are in both and how many are in only one, maybe scale up to all accessions. 
# prelim to know what our options are when heatmapping
# remember to talk about the excel stuff