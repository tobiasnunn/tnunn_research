library(dplyr)
library(tidyr)
library(tidyverse)

# parameters
metadatafile <- "02_middle-analysis_outputs/eggnog_stuff/post_eggnog_pipeline/genera_metadata.tsv"
outputfilename <- "02_middle-analysis_outputs/eggnog_stuff/post_eggnog_pipeline/genera_kegg_enriched_pathways_revised.tsv"

# read in metadata file
metadata <- read_delim(metadatafile, delim = "\t", show_col_types = FALSE)


# clean so is in a good format
mapids <- data.frame(accession = character(), genus = character(), map_id = character(), map_description = character(),
                     gene_ratio = character(), p_val = numeric())

for (i in 1:nrow(metadata)) {
  filename <- paste0("02_middle-analysis_outputs/eggnog_stuff/eggnog_outputs/", metadata$accession[i], "_ko_pathway.tsv")
  if(file.exists(filename)){
    intermed <- read_delim(filename, col_names = TRUE, delim = "\t")
    accession <- metadata$accession[i]
    genus <- metadata$genus[i]
    map_id <- intermed$ID
    map_description <- intermed$Description
    gene_ratio <- intermed$GeneRatio
    p_val <- intermed$pvalue
    mapids <- add_row(mapids, accession = accession, genus = genus, map_id = map_id, map_description = map_description,
                      gene_ratio = gene_ratio, p_val = p_val)
  }
}

# outputs

metadata %>% group_by(genus) %>% count()

mapids <- separate_wider_delim(mapids, cols = gene_ratio, delim = "/", names = c("num", "denom"), cols_remove = FALSE)
mapids$gene_ratio_num <- as.numeric(mapids$num) / as.numeric(mapids$denom)

#write mapids in its entirety to save having to run that again
write_delim(mapids, file="02_middle-analysis_outputs/eggnog_stuff/post_eggnog_pipeline/genera_kegg_enriched_mapids.tsv", delim = "\t")

#this may be the point to filter by gene ratio, perhaps to > 0.1
#filter(mapids, gene_ratio_num > 0.1)

# maps are broken into "modules", could a module be expressed outside of the full map?
# also, maybe something to consider is to divide the nmber of KOs expressed in a pipeline per
# sample and divide it by the total possible, im thinking maybe an API to get that
# so that i have a proportion of how much a pipeline is expressed, and i can get rid of anything
# under like 50% or something.

# I am also now wondering if i should do something more focussed on the Bangor samples
# because it would be interesing what is seen in THEM specifically, not random online samples
# unless we make the assumption any other species in a genus can replace each other and are equivilent.

pivot <- mapids %>% 
  group_by(genus) %>% 
  count(map_id, name = "count") %>% 
  pivot_wider(names_from = genus, values_from = count, values_fill = 0)

write_delim(pivot, file = outputfilename, delim = "\t")
