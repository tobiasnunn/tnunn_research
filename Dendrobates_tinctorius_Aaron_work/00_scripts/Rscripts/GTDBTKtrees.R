library(tidyverse)
library(ape)
library(ggtree)
library(ggtext)
library(phylocanvas)
library(tidyverse)

metabase <- read_delim("02_middle-analysis_outputs/analysis_tables/treestuff_combined.tsv", delim = "\t")
metabase <- metabase %>% select(accession, cutacc, genus, species, sample_type)
metabase$species <- gsub("s__", "", metabase$species)

metabase$display_label <- ifelse(
  metabase$sample_type == "bangor",
  paste0("**", metabase$accession, "**"),  # Just bold accession for bangor
  paste0(metabase$accession, "  *", metabase$species, "*")  # Accession and italic species for others
)

treebase <- ape::read.tree("02_middle-analysis_outputs/gtdbtk_stuff/20241224_de_novo_wf/gtdbtk.bac120.decorated.tree")

#---------------------------regular big tree-----------------------------
# i think this would look good as a circular
tree <- keep.tip(treebase, metabase$accession)

# style stuff
style_data <- data.frame(
  sample_type = c("bangor", "reference", "ncbi", "suppressed"),
  color = c("black", "darkgreen", "blue", "darkred"),  # Example colors
  shape = c(20, 8, 18, 25)  # Different point shapes: circle, triangle, square
)
# to make the %<+% work the join column either needs to be the first column
# or have the name "node"
megatree <- ggtree(tree) %<+% metabase %<+% style_data + 
  geom_tippoint(aes(shape = sample_type, colour = color), size = 2.5) +
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
   hexpand(0.5, direction = 1) +
   geom_treescale(x = 0, y = 28) +
  theme_tree2(legend.position = c(0.1, 0.8)) 

megatree
ggsave("02_middle-analysis_outputs/gtdbtk_stuff/output_trees/bigger_funny.png", 
       plot = megatree, width = 3500, height = 14500, units = "px")



#--------------------------genus trees-------------------------
cutbase <- metabase %>% 
  filter(genus == "g__Brevibacterium")
# filter(cutacc == "1Dt1h") hmm, no way to do this really, need the family
cuttree <- keep.tip(treebase, cutbase$accession)

pantotree <- ggtree(cuttree, aes(colour = sample_type, shape = sample_type)) %<+% cutbase %<+% style_data + 
  geom_tippoint(size = 2.5) +
 geom_richtext(
   aes(label = display_label),
   size = 3,
   hjust = -0.03,
   label.padding = grid::unit(0, "pt"),
   fill = NA,
   label.color = NA,
   label.r = unit(0, "pt")
 ) +
 geom_nodelab(size = 2.5, hjust = 1.2, vjust = -0.2, color = "black") +
 scale_shape_manual(values = setNames(style_data$shape, style_data$sample_type)) +
 scale_color_manual(values = setNames(style_data$color, style_data$sample_type)) +
 hexpand(0.5, direction = 1) +
 hexpand(0.03, direction = -1) +
 geom_treescale(x = 0.37, y = 2) +
 theme_tree2(legend.position = c(0.1, 0.8))

pantotree

ggsave("02_middle-analysis_outputs/gtdbtk_stuff/output_trees/Brevi_tree.png", 
       plot = pantotree, width = 3000, height = 3000, units = "px")

#TODO: automate the creation, maybe using a for loop or something, but 
# doing that would mean having to somehow get R to do the height itself

#----------------------------interactive tree test zone--------------------
# or i could make it interactive with a zoom? could i do that?
# i have just seen something about the "phylocanvas" package
q <- phylocanvas(tree = tree, treetype = "rectangular", nodesize = 15, textsize = 15,
            linewidth = 2, showscalebar = TRUE)
#phylocanvasOutput(q, width = "100%", height = "1000px")
style_node(q, nodeid = "flye_asm_2Dt1e_part2", color = "yellow")
# info on "nodestyles" was hard to come by, i found this:
# Available Parameters:
#   You can customize node styles using parameters such as color, shape, 
#nodesizeratio, strocolor, fillcolor, linewidth, labelcolor, 
#labeltextsize, labelfont, and labelformat. 
# oh ho, and you can use "style_node()" to do personalised stylings
# perhaps, for example, a list of 10... (i think the above params are for that)
# ok, i think nodestyles = has been degraded in favour of style_nodes()