library(ggplot2)
library(purrr)
library(tidyverse)

# read in output from pt1
heatmapbase <- read_delim("02_middle-analysis_outputs/eggnog_stuff/post_eggnog_pipeline/kegg_enriched_pathways.tsv", delim = "\t")

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



# Heatmaps (multiple versions for different aesthetics)


gill_KOenrich_heatmap <- ggplot(data = proportionbase, mapping = aes(x = map_id, y = fct_rev(genus), fill = prop)) +
  geom_tile(color = "black",
            lwd = 0.5,
            linetype = 1) +
  coord_fixed(ratio = 5) +
  scale_fill_viridis_c(limits = c(0,1)) +
  theme_classic() +
  theme(
    axis.title.x = element_text(vjust = 0.5)) +
  ggtitle(label = "coconut") +
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5))+
  labs(y="bacterial genera", x = "KO pathway", fill = "proportion\nenriched\ngenomes")
gill_KOenrich_heatmap

gill_KOenrich_heatmap2 <- ggplot(data = proportionbase, mapping = aes(x = map_id, y = fct_rev(genus), fill = prop)) +
  geom_tile(color = "lightgrey",
            lwd = 0.5,
            linetype = 1) +
  coord_fixed(ratio = 5) +
  scale_fill_viridis_c(limits = c(0,1)) +
  theme_classic() +
  theme(
    axis.title.x = element_text(vjust = 0.5)) +
  ggtitle(label = "coconut") +
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5))+
  labs(y="bacterial genera", x = "KO pathway", fill = "proportion\nenriched\ngenomes")
gill_KOenrich_heatmap2

gill_KOenrich_heatmap3 <- ggplot(data = proportionbase, mapping = aes(x = map_id, y = fct_rev(genus), fill = prop)) +
  geom_tile(color = "lightgrey",
            lwd = 0.5,
            linetype = 1) +
  coord_fixed(ratio = 5) +
  scale_fill_viridis_c(limits = c(0,1), option = "plasma") +
  theme_classic() +
  theme(
    axis.title.x = element_text(vjust = 0.5)) +
  ggtitle(label = "coconut") +
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5))+
  labs(y="bacterial genera", x = "KO pathway", fill = "proportion\nenriched\ngenomes")
gill_KOenrich_heatmap3

# write them out so they can be read in in notebook
png(filename="03_final_outputs/prototype_heatmaps/sample1.png", width = 1080, height = 720)
plot(gill_KOenrich_heatmap)
dev.off()

png(filename="03_final_outputs/prototype_heatmaps/sample2.png", width = 1080, height = 720)
plot(gill_KOenrich_heatmap2)
dev.off()

png(filename="03_final_outputs/prototype_heatmaps/sample3.png", width = 1080, height = 720)
plot(gill_KOenrich_heatmap3)
dev.off()

?png
# what <- heatmapbase %>% 
#   filter(if_any(where(is.numeric), ~ .x >= 600))

# testing stuff DO NOT TOUCH
# what <- heatmapbase %>is_integer()what <- heatmapbase %>% 
#   filter(if_all(everything(), ~ . > 0.8))
# what <- heatmapbase %>% 
#   filter(if_any(c("Brachybacterium", "Sphingomonas"), ~ . > 600))