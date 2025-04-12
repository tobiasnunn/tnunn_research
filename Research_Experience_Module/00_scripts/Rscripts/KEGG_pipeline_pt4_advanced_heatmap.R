library(ggplot2)
library(purrr)
library(tidyverse)

# # testing ground area
# heatmapbase <- read_delim("02_middle-analysis_outputs/eggnog_stuff/post_eggnog_pipeline/genera_kegg_enriched_pathways.tsv", delim = "\t")
# proportionbase <- heatmapbase %>% 
#   rowwise(map_id) %>%
#   mutate(total = sum(c_across(Brachybacterium:Sphingomonas))) %>% 
#   ungroup() %>% 
#   mutate(across(Brachybacterium:Sphingomonas, ~ . / total)) %>% 
#   select(!total) %>% 
#   filter(if_any(where(is.numeric), ~ .x >= 0.8)) %>%
#   pivot_longer(cols = !map_id, names_to = "genus", values_to = "prop")
# # UPDATE: un-hardcode the names maybe
# maps <- read_delim("02_middle-analysis_outputs/analysis_tables/genera_KEGG_metadata.tsv", delim = "\t")
# # join the prop stuff and kegg metadata stuff
# proportionbase <- proportionbase %>%
#   left_join(select(maps, map, name, class, subclass),
#             by = join_by(map_id == map))
# # TEST END
# read in the base doc from pt 3
proportionbase <- read_delim("02_middle-analysis_outputs/analysis_tables/genera_KEGG_chart_data.tsv", delim = "\t")

kegg_heatmap <- ggplot(data = proportionbase, mapping = aes(x = fct_rev(genus),
                                                            y = name, 
                                                            fill = prop)) +
  geom_tile(colour = "lightgrey", lwd = 0.5, linetype = 1) +
  labs(x =  "Bacterial Genus", y ="KEGG Pathway", fill = "proportion\nenriched\ngenomes",
       title = "Comparative prevalance of KEGG pathways between five genera",
       subtitle = "n = 552 samples, adjusted for number of samples in each genus") +
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5), text = element_text(size = 14)) +
  facet_grid(class ~ ., scales = "free", space = "free") +
  scale_fill_viridis_c(limits = c(0,1), option = "plasma") +
  theme(strip.placement = "outside") +
  theme(strip.text.y = element_text(angle = 0), strip.text = element_text(size = 16)) +
  theme(axis.text = element_text(size = 14), plot.title = element_text(size = 16))

kegg_heatmap

ggsave("02_middle-analysis_outputs/KEGG_stuff/generaheatmapnongroupproped.png", 
       plot = kegg_heatmap, width = 3700, height = 5500, units = "px")


# cut out the 2 big ones

cut_proportionbase <- read_delim("02_middle-analysis_outputs/analysis_tables/cut_genera_KEGG_chart_data.tsv", delim = "\t")

cut_kegg_heatmap <- ggplot(data = cut_proportionbase, mapping = aes(x = fct_rev(genus),
                                                            y = name, 
                                                            fill = prop)) +
  geom_tile(colour = "lightgrey", lwd = 0.5, linetype = 1) +
  labs(x =  "Bacterial Genus", y ="KEGG Pathway", fill = "proportion\nenriched\ngenomes",
       title = "Comparative prevalance of KEGG pathways between three genera",
       subtitle = "n = xx samples, adjusted for number of samples in each genus") +
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5), text = element_text(size = 14)) +
  facet_grid(class ~ ., scales = "free", space = "free") +
  scale_fill_viridis_c(limits = c(0,1), option = "plasma") +
  theme(strip.placement = "outside") +
  theme(strip.text.y = element_text(angle = 0), strip.text = element_text(size = 16)) +
  theme(axis.text = element_text(size = 14), plot.title = element_text(size = 16))

cut_kegg_heatmap

ggsave("02_middle-analysis_outputs/KEGG_stuff/cutgeneraheatmapnongroupproped.png", 
       plot = cut_kegg_heatmap, width = 4300, height = 5200, units = "px")
