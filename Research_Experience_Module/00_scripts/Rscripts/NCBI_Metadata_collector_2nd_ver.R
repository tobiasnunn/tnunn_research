library(httr2)
library(tidyverse)
library(jsonlite)
library(tidyr)
library(purrr)
library(tidyjson)
library(writexl)
# I need a new file so that i can make a proper input to the tree maker file GTDBTKtrees.R
#-----------------------------1. import data---------------
# lookup what genus each of our local samples is in, AUTOMATE
# using gtdb-tk file
# read it in:

treetax <- read.delim('02_middle-analysis_outputs/gtdbtk_stuff/20241224_de_novo_wf/gtdbtk.bac120.decorated.tree-taxonomy', 
                      sep = "\t", 
                      header = FALSE,
                      col.names = c('accession', 'path')) %>% 
  separate_wider_delim(
    path, 
    delim = "; ", 
    names = c("domain", "phylum", "class", "order", "family", "genus", "species"), 
    too_few = "align_start",
    too_many = "merge")

bangorsamples <- filter(treetax, str_detect(accession, "flye_asm"))

bangorgenera <- unique(bangorsamples$genus)

genera_analysis <- treetax %>% 
  filter(genus %in% bangorgenera)
# this returns 587 for me which is more than the 552 i was expecting
# i think this is because there are 35 surpressed samples i couldnt eggnog
#----------------------------2. identify treestuff and clean-----------

# get rid of extra text "GB/RS_" and "flye_asm_/_part2":
genera_analysis$cutacc <- gsub("GB_|RS_|flye_asm_|_part2", "", genera_analysis$accession)
ncbi_samples <- genera_analysis %>% 
  filter(species != "s__")

#--------------------------------read in jsons and manipulate--------------------- 
# MEGATABLE
filenames <- list.files("02_middle-analysis_outputs/ncbi_stuff/json/", 
                        pattern=glob2rx("GC*.json"), full.names=TRUE)
jsonlist <- lapply(filenames, jsonlite::read_json) %>% sapply(., "[[", 1)
reports <- tibble(report=jsonlist)

expand <- data.frame(spread_all(jsonlist, recursive = TRUE, sep = "."))

write_xlsx(expand, path = "03_final_outputs/MEGATABLE.xlsx", col_names = TRUE)


#get the fields I want to see for tree
#loop back to this
metadata <- reports %>%
  hoist(report,
        "accession",
        "average_nucleotide_identity",
        "assembly_info",
        "checkm_info") %>%
  hoist(assembly_info,
        "assembly_status",
        "refseq_category",
        "biosample") %>%
  hoist(average_nucleotide_identity,
        "taxonomy_check_status",
        "match_status") %>%
  hoist(checkm_info,
        "completeness",
        "completeness_percentile",
        "contamination") %>%
  hoist(biosample,
        "geo_loc_name",
        "lat_lon",
        "host",
        "isolation_source") %>% 
  select(c("accession", "assembly_status", "refseq_category", "taxonomy_check_status", "match_status",
           "completeness", "completeness_percentile", "contamination", "geo_loc_name",
           "lat_lon", "host", "isolation_source"))

treestuff_combined <- genera_analysis %>% 
  left_join(metadata, by = join_by(cutacc == accession))

treestuff_combined$sample_type <- "ncbi"

treestuff_combined$sample_type[treestuff_combined$refseq_category == "reference genome"] <- "reference"
treestuff_combined$sample_type[treestuff_combined$assembly_status == "suppressed"] <- "suppressed"

treestuff_combined$sample_type[treestuff_combined$species == "s__"] <- "bangor"
# supressed samples
#treestuff_combined$sample_type[treestuff_combined$assembly_status == "suppressed"] <- "suppressed"

# now take only the columns with useful stuff
write_delim(treestuff_combined, file = "02_middle-analysis_outputs/analysis_tables/treestuff_combined.tsv", delim = "\t")
      