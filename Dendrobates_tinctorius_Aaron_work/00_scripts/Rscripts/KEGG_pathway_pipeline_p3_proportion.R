library(dplyr)
library(tidyr)
library(tidyverse)

#the proportionising is done by looking at what % of samples in that genus
#does the map id appear
# parameters
metadatafile <- "02_middle-analysis_outputs/eggnog_stuff/post_eggnog_pipeline/genera_metadata.tsv"
countfilename <- "02_middle-analysis_outputs/eggnog_stuff/post_eggnog_pipeline/genera_kegg_enriched_pathways_revised.tsv"
# read in metadata file
metadata <- read_delim(metadatafile, delim = "\t", show_col_types = FALSE)
raw_counts <- read_delim(countfilename, delim = "\t", show_col_types = FALSE)

genera_count <- metadata %>% group_by(genus) %>% count(name = "total")

# choose which columns you want to include by altering this vector
# genera <- c("Brevibacterium", "Microbacterium", "Brachybacterium", "Pantoea", "Sphingomonas")

genera <- c("Brevibacterium", "Microbacterium", "Brachybacterium", "Pantoea", "Sphingomonas")

raw_counts <- select(raw_counts, map_id | all_of(genera))


#pivot the raw counts

prop_count <- raw_counts %>% pivot_longer(cols = -map_id, names_to = "genus", values_to = "count") %>% 
  left_join(genera_count, by = "genus") %>% 
  mutate(prop = count / total) %>% 
  select(map_id, genus, prop) %>% 
  pivot_wider(names_from = "genus", values_from = "prop") 

numeric_cols <- names(prop_count)[sapply(prop_count, is.numeric)]

filtered_prop_count <- prop_count %>% 
  rowwise() %>%
  filter(sum(c_across(where(is.numeric)) > 0.8) == 1 & 
           sum(c_across(where(is.numeric)) < 0.5) == length(numeric_cols) - 1) %>%
  ungroup() %>%
  pivot_longer(cols = -map_id, names_to = "genus", values_to = "prop")

# get the KEGG metadata
kegg_metadata <- read_delim("02_middle-analysis_outputs/analysis_tables/genera_KEGG_metadata.tsv", delim = "\t")

filtered_prop_count <- filtered_prop_count %>% 
  left_join(kegg_metadata, by = join_by(map_id == map)) %>% 
  select(map_id, genus, prop, name, class, subclass)

# now the heatmap
kegg_heatmap <- ggplot(data = filtered_prop_count, mapping = aes(x = fct_rev(genus),
                                                            y = name, 
                                                            fill = prop)) +
  geom_tile(colour = "lightgrey", lwd = 0.5, linetype = 1) +
  labs(x =  "Bacterial Genus", y ="KEGG Pathway", fill = "proportion\nenriched\ngenomes",
       title = "Comparative prevalance of KEGG pathways between X genera",
       subtitle = "n = X samples") +
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5), text = element_text(size = 14)) +
  facet_grid(subclass ~ ., scales = "free", space = "free") +
  scale_fill_viridis_c(limits = c(0,1), option = "plasma") +
  theme(strip.placement = "outside") +
  theme(strip.text.y = element_text(angle = 0), strip.text = element_text(size = 16)) +
  theme(axis.text = element_text(size = 14), plot.title = element_text(size = 16))

kegg_heatmap

# to do a heatmap of all

prop_count <- prop_count %>% 
  pivot_longer(cols = -map_id, names_to = "genus", values_to = "prop") %>% 
  left_join(kegg_metadata, by = join_by(map_id == map)) %>% 
  select(map_id, genus, prop, name, class, subclass)

# now the heatmap
all_heatmap <- ggplot(data = prop_count, mapping = aes(x = fct_rev(genus),
                                                                 y = name, 
                                                                 fill = prop)) +
  geom_tile(colour = "lightgrey", lwd = 0.5, linetype = 1) +
  labs(x =  "Bacterial Genus", y ="KEGG Pathway", fill = "proportion\nenriched\ngenomes",
       title = "Comparative prevalance of KEGG pathways between X genera",
       subtitle = "n = X samples") +
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5), text = element_text(size = 10)) +
  facet_grid(subclass ~ ., scales = "free", space = "free") +
  scale_fill_viridis_c(limits = c(0,1), option = "plasma") +
  theme(strip.placement = "outside") +
  theme(strip.text.y = element_text(angle = 0), strip.text = element_text(size = 8)) +
  theme(axis.text = element_text(size = 10), plot.title = element_text(size = 10))

all_heatmap

ggsave("02_middle-analysis_outputs/KEGG_stuff/all_pathways.png", 
       plot = all_heatmap, width = 3700, height = 5500, units = "px")
