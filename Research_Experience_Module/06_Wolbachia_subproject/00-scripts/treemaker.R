library(tidyverse)
library(ape)
library(ggtree)
library(ggtext)

metabase <- read_delim("03-true_outputs/Wolbachia_combined.tsv", delim = "\t")
metabase <- metabase %>% select(accession, species, sample_type, cutacc)
metabase$species <- gsub("s__", "", metabase$species)

treebase <- ape::read.tree("02-intermediate_hawk_outputs/wolbachia_out/gtdbtk.bac120.decorated.tree")

tree <- keep.tip(treebase, metabase$accession)
rm(treebase)

metabase$display_label <- ifelse(
  metabase$sample_type == "bangor",
  paste0("**", metabase$cutacc, "**"),  # Just bold accession for bangor
  paste0(metabase$cutacc, "  *", metabase$species, "*")  # Accession and italic species for others
)

# style stuff
style_data <- data.frame(
  sample_type = c("bangor", "reference", "ncbi"),
  color = c("black", "darkgreen", "blue"),  # Example colors
  shape = c(20, 8, 18)  # Different point shapes: circle, triangle, square
)

p <- ggtree(tree) %<+% metabase %<+% style_data + 
  geom_tippoint(aes(shape = sample_type), size = 2.5) +
  geom_richtext(
    aes(label = display_label), 
    size = 3, 
    hjust = -0.03,
    label.padding = grid::unit(0, "pt"),
    fill = NA,           
    label.color = NA,     
    label.r = unit(0, "pt")  
  ) +
  scale_shape_manual(values = setNames(style_data$shape, style_data$sample_type)) +
  hexpand(0.2, direction = 1) +
  geom_treescale(x = 0, y = 28) +
  theme_tree2(legend.position = c(0.1, 0.5)) 
  
p
  
  
