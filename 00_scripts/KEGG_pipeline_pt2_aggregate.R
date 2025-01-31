library(dplyr)
library(tidyr)
library(tidyverse)
library(readxl)
if (!require("BiocManager")){
  install.packages("BiocManager")
BiocManager::install("MicrobiomeProfiler")
}
library(MicrobiomeProfiler)

# parameters
args <- commandArgs(trailingOnly = TRUE)
# Check if arguments are provided
if (length(args) == 0) {
  metadatafile <- "02_middle-analysis_outputs/eggnog_stuff/post_eggnog_pipeline/prototype_metadata.tsv"
  outputfilename <- "02_middle-analysis_outputs/eggnog_stuff/post_eggnog_pipeline/prototype_kegg_enriched_pathways.tsv"
} else {
  metadatafile <- args[1]
  outputfilename <- args[2]
}
# Print the arguments
print(args)



# read in metadata file
metadata <- read_delim(metadatafile, delim = "\t", show_col_types = FALSE)


# clean so is in a good format
mapids <- data.frame(accession = character(), genus = character(), ko_id = character(), map_id = character())

for (i in 1:nrow(metadata)) {
  i <- 5
  filename <- paste0("02_middle-analysis_outputs/eggnog_stuff/eggnog_outputs/", metadata$accession[i], "_ko_enrichment.tsv")
  if(file.exists(filename)){
    intermed <- read_delim(filename, col_names = TRUE, delim = "\t")
    accession <- metadata$accession[i]
    genus <- metadata$genus[i]
    ko_id <- intermed$ko_id
    map_id <- intermed$map_id
    mapids <- add_row(mapids, accession = accession, genus = genus, ko_id = ko_id, map_id = map_id)
  }
}

# outputs
pivot <- mapids %>% group_by(genus) %>% count(map_id, name = "count") %>% pivot_wider(names_from = genus, values_from = count, values_fill = 0)
write_delim(pivot, file = outputfilename, delim = "\t")


