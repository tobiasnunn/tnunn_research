library(ggplot2)
library(purrr)
library(tidyverse)
library(KEGGREST)

#-------------------------------setup parameters----------------
# read in output from pt2
heatmapbase <- read_delim("02_middle-analysis_outputs/eggnog_stuff/post_eggnog_pipeline/genera_kegg_enriched_pathways.tsv", delim = "\t")

# read in metadata file
metadatafile <- "02_middle-analysis_outputs/eggnog_stuff/post_eggnog_pipeline/genera_metadata.tsv"

# the number of times a specific map ID was enriched across all groups, so we can select rows higher than it
cutval <- 1000

# the percentage (80%) that a genus need have for it to count as "significantly" different than others.
selectprop <- 0.8


#----------------------------------proportionise------------------
# because i have different numbers of samples in each group, i want to
# adjust the raw numbers before creating the rowise proportions 

# read in the metadata file
metadata <- read_delim(metadatafile, delim = "\t", show_col_types = FALSE) %>% group_by(genus) %>% count(name = "genus_total")

#proportionise by the columns to make them equal in weight
heatmapbase_prop <- pivot_longer(heatmapbase, !map_id, names_to = "genus", values_to = "count") %>% 
  left_join(metadata, by = "genus") %>% 
  mutate(group_prop = count / genus_total) %>%
  select(map_id, genus, group_prop) %>%
  pivot_wider(names_from = genus, values_from = group_prop)

# add a total row to filter by
heatmapbase_prop <- heatmapbase_prop %>%
  rowwise() %>%
  mutate(total = sum(c_across(-map_id), na.rm = TRUE)) %>%
  ungroup()
# filter by the total row
heatmapbase_filt <- filter(heatmapbase, total >= 1000)

# change to proportions rather than number of genomes:
# dplyr and tidyverse do be good :gorilla emoji: :moai emoji: :diamond emoji:

# UPDATE: create weighted scores before proportions as group sizes different (group proportions)


# row proportions
proportionbase <- heatmapbase_prop %>% 
  rowwise(map_id) %>%
  mutate(total = rowSums(across(where(is.numeric)))) %>% 
  ungroup() %>% 
  mutate(across(where(is.numeric), ~ . / total)) %>% 
  select(!total) %>% 
  filter(if_any(where(is.numeric), ~ .x >= 0.8)) %>%
  pivot_longer(cols = !map_id, names_to = "genus", values_to = "prop")
# UPDATE: un-hardcode the names maybe

# row proportions (cut out sphingo and pantoea)
cut_proportionbase <- select(heatmapbase_prop, -c("Sphingomonas", "Pantoea")) %>% 
  rowwise(map_id) %>%
  mutate(total = rowSums(across(where(is.numeric)))) %>%
  ungroup() %>% 
  filter(total > 0) %>%
  mutate(across(where(is.numeric), ~ . / total)) %>%
  select(!total) %>% 
  filter(if_any(where(is.numeric), ~ .x >= 0.8)) %>%
  pivot_longer(cols = !map_id, names_to = "genus", values_to = "prop")


# if file exists, then read, otherwise create
if(file.exists("02_middle-analysis_outputs/analysis_tables/genera_KEGG_metadata.tsv")){
  maps <- read_delim("02_middle-analysis_outputs/analysis_tables/genera_KEGG_metadata.tsv", delim = "\t")
} else {
  # get the metadata from KEGG website
  maps <- data.frame(map = heatmapbase$map_id, name = NA, 
                     description = NA, class = NA, dblinks = NA)
  
  count <- 0
  
  for (i in 1:nrow(maps)) {
    count <- count + 1
    counter <- paste0("counter: ", count, " / ", nrow(maps))
    print(counter)
    getten <- keggGet(heatmapbase$map_id[i])
    maps$name[i] <- coalesce(getten[[1]]$NAME[[1]], NA)
    maps$description[i] <- coalesce(getten[[1]]$DESCRIPTION[[1]], NA)
    maps$class[i] <- coalesce(getten[[1]]$CLASS[[1]], NA)
    maps$dblinks[i] <- coalesce(getten[[1]]$DBLINKS[[1]], NA)
  }
  
  maps <- separate_wider_delim(maps, class, delim = "; ", names = c("class", "subclass"))
  
  write_delim(maps, "02_middle-analysis_outputs/analysis_tables/genera_KEGG_metadata.tsv", delim = "\t")
  
}

# join the prop stuff and kegg metadata stuff
proportionbase <- proportionbase %>%
  left_join(select(maps, map, name, class, subclass),
            by = join_by(map_id == map))
write_delim(proportionbase, "02_middle-analysis_outputs/analysis_tables/genera_KEGG_chart_data.tsv", delim = "\t")


# join the prop stuff and kegg metadata stuff
cut_proportionbase <- cut_proportionbase %>%
  left_join(select(maps, map, name, class, subclass),
            by = join_by(map_id == map))
write_delim(cut_proportionbase, "02_middle-analysis_outputs/analysis_tables/cut_genera_KEGG_chart_data.tsv", delim = "\t")
