library(ggplot2)
library(purrr)
library(tidyverse)
library(KEGGREST)

# read in output from pt1
heatmapbase <- read_delim("02_middle-analysis_outputs/eggnog_stuff/post_eggnog_pipeline/prototype_kegg_enriched_pathways.tsv", delim = "\t")

# get the metadata from KEGG website
maps <- data.frame(map = heatmapbase$map_id, name = NA, 
                   description = NA, class = NA, dblinks = NA)

for (i in 1:nrow(maps)) {
  getten <- keggGet(heatmapbase$map_id[i])
  maps$name[i] <- coalesce(getten[[1]]$NAME[[1]], NA)
  maps$description[i] <- coalesce(getten[[1]]$DESCRIPTION[[1]], NA)
  maps$class[i] <- coalesce(getten[[1]]$CLASS[[1]], NA)
  maps$dblinks[i] <- coalesce(getten[[1]]$DBLINKS[[1]], NA)
}

maps <- separate_wider_delim(maps, class, delim = "; ", names = c("class", "subclass"))

write_delim(maps, "02_middle-analysis_outputs/analysis_tables/prototype_KEGG_metadata.tsv", delim = "\t")


# change to proportions rather than number of genomes:
# dplyr and tidyverse do be good :gorilla emoji: :moai emoji: :diamond emoji:

proportionbase <- heatmapbase %>% 
  rowwise(map_id) %>%
  mutate(total = sum(c_across(Brachybacterium:Sphingomonas))) %>% 
  ungroup() %>% 
  mutate(across(Brachybacterium:Sphingomonas, ~ . / total)) %>% 
  select(!total) %>% 
  filter(if_any(where(is.numeric), ~ .x >= 0.8)) %>%
  pivot_longer(cols = !map_id, names_to = "genus", values_to = "prop")

# UPDATE: create weighted scores before proportions as group sizes different

proportionbase <- proportionbase %>%
  left_join(select(maps, map, name, class, subclass),
            by = join_by(map_id == map))

kegg_heatmap <- ggplot(data = proportionbase, mapping = aes(x = fct_rev(genus),
                                                            y = name, 
                                                            fill = prop)) +
  geom_tile(colour = "lightgrey", lwd = 0.5, linetype = 1) +
  labs(x =  "Bacterial Genus", y ="KEGG Pathway", fill = "proportion\nenriched\ngenomes",
       title = "Coconut / Banana") +
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5), text = element_text(size = 14)) +
  facet_grid(class ~ ., scales = "free", space = "free") +
  scale_fill_viridis_c(limits = c(0,1), option = "plasma") +
  theme(strip.placement = "outside") +
  theme(strip.text.y = element_text(angle = 0), strip.text = element_text(size = 16)) +
  theme(axis.text = element_text(size = 14), plot.title = element_text(size = 16))

ggsave("02_middle-analysis_outputs/KEGG_stuff/prototypeheatmapformat.png", 
       plot = kegg_heatmap, width = 3700, height = 5200, units = "px")
