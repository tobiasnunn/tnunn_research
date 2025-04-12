library(tidyverse)
library(ggplot2)
library(scales)

#the proportionising is done by looking at what % of samples in that genus
#does the map id appear
# parameters
metadatafile <- "02_middle-analysis_outputs/eggnog_stuff/post_eggnog_pipeline/genera_metadata.tsv"
countfilename <- "02_middle-analysis_outputs/eggnog_stuff/post_eggnog_pipeline/genera_kegg_enriched_pathways_revised.tsv"

high_lim <- 0.8
low_lim <- 0.5
# read in metadata file
metadata <- read_delim(metadatafile, delim = "\t", show_col_types = FALSE)
raw_counts <- read_delim(countfilename, delim = "\t", show_col_types = FALSE)

# this is the code for doing just the Bangor samples
# metadata <- read_delim(metadatafile, delim = "\t", show_col_types = FALSE) %>% 
#   filter(!str_detect(accession, "^GC"))
# 
# mapids <- read_delim(file="02_middle-analysis_outputs/eggnog_stuff/post_eggnog_pipeline/genera_kegg_enriched_mapids.tsv", delim = "\t") %>% 
#   filter(!str_detect(accession, "^GC"))
# 
# raw_counts <- mapids %>% 
#   group_by(genus) %>% 
#   count(map_id, name = "count") %>% 
#   pivot_wider(names_from = genus, values_from = count, values_fill = 0)



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
  filter(sum(c_across(where(is.numeric)) > high_lim) == 1 & 
           sum(c_across(where(is.numeric)) < low_lim) == length(numeric_cols) - 1) %>%
  ungroup() %>%
  pivot_longer(cols = -map_id, names_to = "genus", values_to = "prop")

# get the KEGG metadata
kegg_metadata <- read_delim("02_middle-analysis_outputs/analysis_tables/genera_KEGG_metadata.tsv", delim = "\t")

filtered_prop_count <- filtered_prop_count %>% 
  left_join(kegg_metadata, by = join_by(map_id == map)) %>% 
  select(map_id, genus, prop, name, class, subclass)

filtered_prop_count$perc <- scales::percent(filtered_prop_count$prop, accuracy = 0.1)
filtered_prop_count <- filtered_prop_count %>% 
  mutate(yellow = prop > 0.5)
  
# now the heatmap

# my attempt at making an automated list for the subtitle, so far a failure
# disag_count <- as.vector(genera_count$total[length(genera_count$total):1])

kegg_heatmap <- ggplot(data = filtered_prop_count, mapping = aes(x = fct_rev(genus),
                                                            y = name, 
                                                            fill = prop)) +
  geom_tile(colour = "lightgrey", lwd = 0.5, linetype = 1) +
  labs(x =  "Bacterial Genus", y ="KEGG Pathway", fill = "proportion\nenriched\ngenomes",
       title = "Comparative prevalance of KEGG pathways between\nsubsets of 5 genera as chosen by GTDB-TK analysis",
       subtitle = "n = 552 samples (200, 48, 231, 42, 31)") + # there has to be a way to automate that
  theme(axis.text.x = element_text(vjust = 0.5), text = element_text(size = 14)) +
  #facet_grid(subclass ~ ., scales = "free", space = "free") +
  scale_fill_viridis_c(limits = c(0,1), option = "plasma") +
  theme(strip.placement = "outside") +
  theme(strip.text.y = element_text(angle = 0), strip.text = element_text(size = 16)) +
  theme(axis.text = element_text(size = 14), plot.title = element_text(size = 16)) +
  facet_wrap(~subclass, scales="free", nrow = 5, ncol = 1) + 
  geom_text(aes(label = perc, colour = yellow)) +
  scale_colour_manual(values=c("white", "black")) + 
  guides(colour = "none")

kegg_heatmap

ggsave("02_middle-analysis_outputs/KEGG_stuff/all_genera_updated.png", 
       plot = kegg_heatmap, width = 4000, height = 4500, units = "px")


# small upgrade to axis labels

kegg_heatmap_b <- ggplot(data = filtered_prop_count, mapping = aes(x = fct_rev(genus),
                                                                 y = name, 
                                                                 fill = prop)) +
  geom_tile(colour = "lightgrey", lwd = 0.5, linetype = 1) +
  labs(x =  "Bacterial Genus", y ="KEGG Pathway", fill = "proportion\nenriched\ngenomes",
       title = "Comparative prevalance of KEGG pathways between\nsubsets of 5 genera as chosen by GTDB-TK analysis",
       subtitle = "n = 552 samples (200, 48, 231, 42, 31)") + # there has to be a way to automate that
  theme(axis.text.x = element_text(vjust = 0.5), text = element_text(size = 14)) +
  #facet_grid(subclass ~ ., scales = "free", space = "free") +
  scale_fill_viridis_c(limits = c(0,1), option = "plasma") +
  theme(strip.placement = "outside") +
  theme(strip.text.y = element_text(angle = 0), strip.text = element_text(size = 16)) +
  theme(axis.text = element_text(size = 14), plot.title = element_text(size = 16)) +
  facet_wrap(~subclass, scales="free_y", nrow = 5, ncol = 1) + 
  geom_text(aes(label = perc, colour = yellow)) +
  scale_colour_manual(values=c("white", "black")) + 
  guides(colour = "none")

kegg_heatmap_b
# scales="free_y" is instrumental in getting the x-axis to not repeat

ggsave("02_middle-analysis_outputs/KEGG_stuff/all_genera_updated_b.png", 
       plot = kegg_heatmap_b, width = 4000, height = 4500, units = "px")

# code for the funny heatmap:
# put "scales="fixed" for the other funny
# kegg_heatmap <- ggplot(data = filtered_prop_count, mapping = aes(x = fct_rev(genus),
#                                                                  y = name, 
#                                                                  fill = prop)) +
#   geom_tile(colour = "lightgrey", lwd = 0.5, linetype = 1) +
#   labs(x =  "Bacterial Genus", y ="KEGG Pathway", fill = "proportion\nenriched\ngenomes",
#        title = "Comparative prevalance of KEGG pathways between subsets of 5 genera as chosen by GTDB-TK analysis",
#        subtitle = c("n = 552 samples (200, 48, 231, 42, 31)")) + # there has to be a way to automate that
#   theme(axis.text.x = element_text(angle = 90, vjust = 0.5), text = element_text(size = 14)) +
#   facet_grid(subclass ~ ., scales = "free", space = "free") +
#   scale_fill_viridis_c(limits = c(0,1), option = "plasma") +
#   theme(strip.placement = "outside") +
#   theme(strip.text.y = element_text(angle = 0), strip.text = element_text(size = 16)) +
#   theme(axis.text = element_text(size = 14), plot.title = element_text(size = 16)) +
#   facet_wrap(~subclass, scales="free")
# 
# kegg_heatmap
# 
# ggsave("02_middle-analysis_outputs/KEGG_stuff/all_genera_updated_haha.png", 
#        plot = kegg_heatmap, width = 8000, height = 2000, units = "px")