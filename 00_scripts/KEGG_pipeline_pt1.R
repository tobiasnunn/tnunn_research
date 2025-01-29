library(dplyr)
library(tidyr)
library(tidyverse)
library(readxl)
if (!require("BiocManager")){
  install.packages("BiocManager")
BiocManager::install("MicrobiomeProfiler")
}
library(MicrobiomeProfiler)

# read in metadata file
metadata <- read_delim("02_middle-analysis_outputs/eggnog_stuff/post_eggnog_pipeline/prototype_metadata.tsv", delim = "\t", show_col_types = FALSE)

# read in all the .xlsx files
#data.l <- vector(mode = "list", length = nrow(metadata))
kegg_kos <- metadata
kegg_kos$ko_list <- "banana"

# clean so is in a good format
for (i in 1:nrow(metadata)) {
  filename <- paste0("02_middle-analysis_outputs/eggnog_stuff/eggnog_outputs/", metadata$accession[i], ".emapper.annotations.xlsx")
  if(file.exists(filename)){
    intermed <- read_excel(filename, skip = 2, col_names = TRUE)
    ko_list <- paste(intermed$KEGG_ko[intermed$KEGG_ko != "-" & !is.na(intermed$KEGG_ko)], collapse = "|")
    kegg_kos$ko_list[i] <- ko_list  
  }
}

# get each ko onto its own line (some have multiple)
apple <- kegg_kos %>% separate_longer_delim(ko_list, delim = "|") %>% 
  separate_longer_delim(ko_list, delim = ",") %>% separate_wider_delim( ko_list, delim = ":", names = c(NA,"ko_list"), too_few = "align_end")

# enrichKO
testko <- apple[1:nrow(apple),]
mapids <- data.frame(accession = character(), genus = character(), ko_id = character(), map_id = character())
count <- 0

for (i in 1:nrow(testko)) {
  count <- count + 1
  counter <- paste(count, "/", nrow(testko))
  enrichtest <- enrichKO(testko$ko_list[i], pAdjustMethod = "BH")
  if(!is.null(enrichtest)){
    accession <- testko$accession[i]
    genus <- testko$genus[i]
    ko_id <- testko$ko_list[i]
    map_id <- enrichtest@result[which(enrichtest@result$p.adjust < 0.05), ]$ID 
    mapids <- add_row(mapids, accession = accession, genus = genus, ko_id = ko_id, map_id = map_id)
  }
}

#kegg.l[[mag]] <- ko@result[which(ko@result$p.adjust < 0.05), ]$ID
#?enrichKO

# outputs
pivot <- mapids %>% group_by(genus) %>% count(map_id, name = "count") %>% pivot_wider(names_from = genus, values_from = count, values_fill = 0)
write_delim(pivot, file = "02_middle-analysis_outputs/eggnog_stuff/post_eggnog_pipeline/kegg_enriched_pathways.tsv", delim = "\t")


