library(dplyr)
library(tidyr)
library(tidyverse)
# read in the chosen accessions for prototype
all_genera <- read.delim("02_middle-analysis_outputs/analysis_tables/genera_analysis_combined.tsv") %>% filter(assembly_status != "suppressed" | sample_type == "bangor")

#------------------prototying steps--------------------------
# just_prototype <- read.delim("02_middle-analysis_outputs/analysis_tables/prototypelist.tsv")
# # filter 1 by 2 so just genera in prototype list or a bangor sample
# all_prototype <- all_genera %>% filter(all_genera$accession %in% just_prototype$accession | all_genera$sample_type == "bangor") %>%
#   filter(.$accession != "1Dt100h")
# 
# # ok, now i make the metadata file, this has two columns (mag_id = accession / bac_taxon = genus)
#-----------------------actual bit------------------
metadata <- all_genera %>% select(c("accession", "genus")) %>%
  mutate(across(c('genus'), substr, 4, nchar(genus)))

write_delim(metadata, "02_middle-analysis_outputs/eggnog_stuff/post_eggnog_pipeline/genera_metadata.tsv", delim = "\t")
