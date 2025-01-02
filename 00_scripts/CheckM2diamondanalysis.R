library(dplyr)
library(tidyr)
library(tidyverse)
library(gt)
library(readxl)
library(tidyjson)
library(purrr)
#-----------------------------------import---------------------------------

# DIAMOND RESULTS
headers <- c("qseqid",	"sseqid",	"pident",	"length",	"mismatch",	"gapopen",	"qstart",	"qend",	"sstart",	"send",	"evalue",	"bitscore")
dires <- read.delim("02_middle-analysis_outputs/CheckM2_20241228/diamond_output/DIAMOND_RESULTS.tsv", header = FALSE)
names(dires) <- headers

# EGGNOG RESULTS

eggnog_files <- list.files("02_middle-analysis_outputs/eggnog_stuff", pattern = ".xlsx", full.names = TRUE)
eggnog_file_list <- lapply(eggnog_files, function(x) read_excel(x, skip = 2, col_names = TRUE))
accession_names <- list.files("02_middle-analysis_outputs/eggnog_stuff", pattern = ".xlsx", full.names = FALSE)
accession_names <- gsub("flye_asm_|_part2.*", "", accession_names)
names(eggnog_file_list) <- accession_names

#----------------------------------manipulation------------------------

#DIAMOND

dires$accession <- gsub("flye_asm_|_part2.*", "", dires$qseqid)

dires$ko_value <- gsub(".*~", "", dires$sseqid)

dires <- dires %>%
  separate_rows(ko_value, sep = "&")

#EGGNOG

eggnog_kos <- eggnog_file_list %>% sapply(., "[[", "KEGG_ko")

# because the number of kos is different, pad to the maximum length with nas 
mx <- max(lengths(eggnog_kos))
eggnog_kos <- data.frame(lapply(eggnog_kos, `length<-`, mx))
eggnog_kos <- pivot_longer(eggnog_kos, 
                           cols = everything(), 
                           names_to = "accession", 
                           values_to = "ko_value")

eggnog_kos <- eggnog_kos[!eggnog_kos$ko_value == "-",] %>%
  separate_rows(ko_value, sep = ",")

eggnog_kos$ko_value <- gsub("ko:", "", eggnog_kos$ko_value)
#note: this line only works because there are no accessions with X in, safer
#would be to remove the first character only
eggnog_kos$accession <- gsub("X", "", eggnog_kos$accession)

#----------------------------------combined lists------------------------
# we now have two lists with accessions and ko values
# we want one master list per accession and then we want to know
# which are present in the eggnog file for that accession and
# which are present in the diamond file for that accession

unique_egg <- unique(eggnog_kos[c("accession", "ko_value")])
unique_diamond <- unique(dires[c("accession", "ko_value")])
combined <- rbind(unique_egg, unique_diamond )
combined <- unique(combined[c("accession", "ko_value")])
combined <- combined[!is.na(combined$accession), ]
# creating a combined accession and ko column to make it easier to match to combined
unique_egg$accko <- paste(unique_egg$accession, unique_egg$ko_value, sep = "-")
unique_diamond$accko <- paste(unique_diamond$accession, unique_diamond$ko_value, sep = "-")
combined$accko <- paste(combined$accession, combined$ko_value, sep = "-")
#-----------------------------------comparison--------------------------

combined$egg <- combined$accko %in% unique_egg$accko
combined$diamond <- combined$accko %in% unique_diamond$accko

unique <- combined %>% 
  group_by(accession) %>% 
  summarise(
    tot_rows = n(), 
    diamond = length(accession[diamond == TRUE]), 
    egg = length(accession[egg == TRUE]), 
    diamond_per = diamond / tot_rows,
    egg_per = egg / tot_rows)
#------------------------------------graphing----------------------------
write.csv(unique, "02_middle-analysis_outputs/CheckM2_20241228/uniquecomp.csv", row.names = FALSE)
#------------------------------------cumulative-------------------------
# two tables, the stuff for the unique values is above
#this section will be for the full table to have a look at most frequent per accession

eggcum <- eggnog_kos[!is.na(eggnog_kos$accession),] %>% 
  group_by(accession, ko_value) %>% 
  summarise(
    tot_rows = n()) %>%
    slice_max(
      order_by = tot_rows,
      n = 5,
      with_ties = FALSE,
      na_rm = TRUE
    )

diacum <- dires[!is.na(dires$accession),] %>% 
  group_by(accession, ko_value) %>% 
  summarise(
    tot_rows = n()) %>%
  slice_max(
    order_by = tot_rows,
    n = 5,
    with_ties = FALSE,
    na_rm = TRUE
  )

cumcomb <- bind_cols(eggcum, diacum)
names(cumcomb) <- c("accession.e", "ko_value.e", "tot_rows.e", "accession.d", "ko_value.d", "tot_rows.d")

write.csv(cumcomb, "02_middle-analysis_outputs/CheckM2_20241228/cumcomb.csv", row.names = FALSE)

# write up investigation into DIAMOND_RESULTS.tsv and output a table with some key metrics
# like how many are in both and how many are in only one, maybe scale up to all accessions. 
# prelim to know what our options are when heatmapping
# remember to talk about the excel stuff