library(httr2)
library(tidyverse)

# read in combined table
combi <- read.delim("02_middle-analysis_outputs/analysis_tables/genera_analysis_combined.tsv")

# filter this so were left with "good samples"

filtered <- filter(combi, sample_type == "ncbi" & taxonomy_check_status == "OK" & is.na(refseq_category) & assembly_status == "current" & match_status != "below_threshold_mismatch")

subset <- filtered %>% group_by(genus) %>% slice_sample(n=10)

local <- filter(combi, sample_type == "bangor" & family != "f__")

countbygenus <- local %>% group_by(genus) %>% count()

# NOTE: improve the automation on this bit, a for loop could do that
fastalist <- filter(subset, 1 == 0)

for (i in 1:nrow(countbygenus)) {
  fastalist <- rbind(fastalist, slice_sample(filter(subset, genus == countbygenus[i,"genus"]), n=10-countbygenus$n[i]))
}


# call the API, get .fastas
urlstring <- 'https://api.ncbi.nlm.nih.gov/datasets/v2/'
api_header <- 'd4f921c91015c68f48f656a99ad5bcf84a08'

for (i in 1:nrow(fastalist)) {
  accession <- fastalist$accession[i]
  req <- request(base_url = urlstring) %>% 
    req_auth_bearer_token(api_header) %>%
    req_url_path_append("genome", "accession", accession, "download") %>%
    req_url_query( include_annotation_type ='GENOME_FASTA') %>%
    req_perform(path = paste0("02_middle-analysis_outputs/ncbi_stuff/fasta/", accession, '.zip'))
}


