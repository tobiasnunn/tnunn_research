library(dplyr)
library(tidyr)
library(tidyverse)
library(readxl)
# if (!require("BiocManager")){
#   install.packages("BiocManager")
# BiocManager::install("MicrobiomeProfiler")
# }
library(MicrobiomeProfiler)

#check which eggnog files have not been enriched and work through those
eggnogfiles <- data.frame(filename = list.files("02_middle-analysis_outputs/eggnog_stuff/eggnog_outputs/", pattern = "*.xlsx"))
eggnogfiles$accession <- sub("\\.(emapper).*", "", eggnogfiles$filename)

existing_enrichments <- data.frame(filename = list.files("02_middle-analysis_outputs/eggnog_stuff/eggnog_outputs/", pattern = "*_ko_enrichment.tsv"))
existing_enrichments$accession <- sub("\\_ko_enrichment.tsv", "", existing_enrichments$filename)

list_to_process <- filter(eggnogfiles, !eggnogfiles$accession %in% existing_enrichments$accession)


for (i in 1:nrow(list_to_process))
{
  count <- i
  #read in the KEGG_ko column of the spreadsheet
  #clean the data
  fullfilename <- paste0("02_middle-analysis_outputs/eggnog_stuff/eggnog_outputs/", list_to_process$filename[i])
  intermed <- read_excel(fullfilename, range = "L3:L60000", col_names = TRUE)
  intermed <- intermed[intermed$KEGG_ko != "-" & !is.na(intermed$KEGG_ko),] %>% 
    mutate(KEGG_ko = str_replace_all(KEGG_ko, "ko:", "")) %>%  separate_longer_delim(KEGG_ko, delim = ",")
  mapids <- data.frame(accession = character(), ko_id = character(), map_id = character())
  for (j in 1:nrow(intermed))
  {
    #enrich each KO 
    ko_id <- intermed$KEGG_ko[j]
    enrichtest <- enrichKO(ko_id, pAdjustMethod = "BH")
    if(!is.null(enrichtest)){
      accession <- list_to_process$accession[i]
      map_id <- enrichtest@result[which(enrichtest@result$p.adjust < 0.05), ]$ID 
      mapids <- add_row(mapids, accession = accession, ko_id = ko_id, map_id = map_id)
    }
  }
  #and save to a file
  write_delim(mapids, paste0("02_middle-analysis_outputs/eggnog_stuff/eggnog_outputs/", list_to_process$accession[i], "_ko_enrichment.tsv"),
              delim = "\t")
  
  
}


