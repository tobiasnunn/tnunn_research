library(dplyr)
library(tidyr)
library(tidyverse)
library(gt)
library(knitr)
library(jsonlite)
library(tidyjson)

#--------------------------------read in jsons and manipulate--------------------- 
filenames <- list.files("02_middle-analysis_outputs/ncbi_stuff/json/", 
                        pattern=glob2rx("GC*.json"), full.names=TRUE)
jsonlist <- lapply(filenames, jsonlite::read_json) %>% sapply(., "[[", 1)
reports <- tibble(report=jsonlist)

#get the fields i want to see
expand <- reports %>%
  hoist(report, 
        "accession", 
        "average_nucleotide_identity",
        "assembly_info",
        "checkm_info") %>%
  hoist(assembly_info, 
        "assembly_status",
        "refseq_category") %>%
  hoist(average_nucleotide_identity,
        "taxonomy_check_status",
        "match_status") %>%
  hoist(checkm_info,
        "completeness",
        "completeness_percentile",
        "contamination") %>%
  select(c("accession", "assembly_status", "refseq_category", "taxonomy_check_status", "match_status",
           "completeness", "completeness_percentile", "contamination"))

#--------------------------------read in file from gtdb-tk for combi-----------------
genera <- read.delim("02_middle-analysis_outputs/analysis_tables/genera_analysis.tsv")

#left join the tables
combi <- left_join(genera, expand, by = "accession")
write_delim(combi, "02_middle-analysis_outputs/analysis_tables/genera_analysis_combined.tsv", delim = "\t")
#### can i enrich the data table here to add data i did earlier (i.e. it has fields for checkm that i could fill, did i do ANI too?)###