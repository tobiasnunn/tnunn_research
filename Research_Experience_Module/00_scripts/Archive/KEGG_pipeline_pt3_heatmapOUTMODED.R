library(ggplot2)
library(purrr)
library(tidyverse)

# read in output from pt1
heatmapbase <- read_delim("02_middle-analysis_outputs/eggnog_stuff/post_eggnog_pipeline/prototype_kegg_enriched_pathways.tsv", delim = "\t")

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

#-----------------------------------------------extra special heatmaps------------------
# the other three subtracting Sphingomonas and Pantoea

lower3base <- heatmapbase[,1:4] %>% 
  rowwise(map_id) %>%
  mutate(total = sum(c_across(Brachybacterium:Microbacterium))) %>% 
  ungroup() %>% 
  mutate(across(Brachybacterium:Microbacterium, ~ . / total)) %>% 
  select(!total) %>% 
  filter(if_any(where(is.numeric), ~ .x >= 0.8)) %>%
  pivot_longer(cols = !map_id, names_to = "genus", values_to = "prop")

# heatmap
lower3KOenrich_heatmap <- ggplot(data = lower3base, mapping = aes(x = map_id, y = fct_rev(genus), fill = prop)) +
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
lower3KOenrich_heatmap


# commonality test

commonbase <- heatmapbase %>% 
  rowwise(map_id) %>%
  mutate(total = sum(c_across(Brachybacterium:Sphingomonas))) %>% 
  ungroup() %>% 
  mutate(across(Brachybacterium:Sphingomonas, ~ . / total)) %>%
  mutate(across(Brachybacterium:Sphingomonas, ~ abs(. - 0.2))) %>%
  mutate(across(Brachybacterium:Sphingomonas, ~ abs(1 - .))) %>%
  select(!total) %>%
  rowwise(map_id) %>%
  mutate(total = sum(c_across(Brachybacterium:Sphingomonas))) %>%
  filter(total > 4.9) %>%
  select(!total) %>%
  pivot_longer(cols = !map_id, names_to = "genus", values_to = "prop")


# heatmap
commonKOenrich_heatmap <- ggplot(data = commonbase, mapping = aes(x = map_id, y = fct_rev(genus), fill = prop)) +
  geom_tile(color = "lightgrey",
            lwd = 0.5,
            linetype = 1) +
  coord_fixed(ratio = 5) +
  scale_fill_viridis_c(limits = c(0.95,1), option = "plasma", direction = 1) +
  theme_classic() +
  theme(
    axis.title.x = element_text(vjust = 0.5)) +
  ggtitle(label = "coconut") +
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5))+
  labs(y="bacterial genera", x = "KO pathway", fill = "proportion\nenriched\ngenomes")
commonKOenrich_heatmap





#copies
# commonbase <- heatmapbase %>% 
#   rowwise(map_id) %>%
#   mutate(total = sum(c_across(Brachybacterium:Sphingomonas))) %>% 
#   ungroup() %>% 
#   mutate(across(Brachybacterium:Sphingomonas, ~ . / total)) %>%  
#   rowwise(map_id) %>%
#   mutate(difference = max(c_across(Brachybacterium:Sphingomonas))- min(c_across(Brachybacterium:Sphingomonas))) %>%
#   select(!total) %>%
#   filter(difference < 0.22 & difference > 0.18) %>%
#   select(!difference) %>%
#   pivot_longer(cols = !map_id, names_to = "genus", values_to = "prop")


# commonKOenrich_heatmap <- ggplot(data = commonbase, mapping = aes(x = map_id, y = fct_rev(genus), fill = prop)) +
#   geom_tile(color = "lightgrey",
#             lwd = 0.5,
#             linetype = 1) +
#   coord_fixed(ratio = 5) +
#   scale_fill_viridis_c(limits = c(0,0.04), option = "plasma", direction = -1) +
#   theme_classic() +
#   theme(
#     axis.title.x = element_text(vjust = 0.5)) +
#   ggtitle(label = "coconut") +
#   theme(axis.text.x = element_text(angle = 90, vjust = 0.5))+
#   labs(y="bacterial genera", x = "KO pathway", fill = "proportion\nenriched\ngenomes")
# commonKOenrich_heatmap
