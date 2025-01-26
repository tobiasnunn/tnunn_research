library(httr2)
library(tidyverse)

# read in combined table
combi <- read.delim("02_middle-analysis_outputs/analysis_tables/genera_analysis_combined.tsv")

# filter this so were left with "good samples"

filtered <- filter(combi, sample_type == "ncbi" & taxonomy_check_status == "OK" & is.na(refseq_category) & assembly_status == "current" & match_status != "below_threshold_mismatch")

subset <- filtered %>% group_by(genus) %>% slice_sample(n=10)

local <- filter(combi, sample_type == "bangor" & family != "f__")

countbygenus <- local %>% group_by(genus) %>% count()

final <- rbind(slice_sample(filter(subset, genus == "g__Microbacterium"), n=8), slice_sample(filter(subset, genus == "g__Sphingomonas"), n=6))
final <- rbind(final, slice_sample(filter(subset, genus == "g__Pantoea"), n=9))
final <- rbind(final, slice_sample(filter(subset, genus == "g__Brevibacterium"), n=9))
final <- rbind(final, slice_sample(filter(subset, genus == "g__Brachybacterium"), n=9))

# NOTE: improve the automation on this bit, a for loop could do that
fastalist <- filter(subset, 1 == 0)

for (i in 1:nrow(countbygenus)) {
  numberofsamples <- 10-countbygenus[i,"n"].astype(numeric)
  fastalist <- rbind(fastalist, slice_sample(filter(subset, genus == countbygenus[i,"genus"]), n=numberofsamples))
}

