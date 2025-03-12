library(tidyverse)
library(ape)
library(ggtree)
library(ggtext)
library(phylocanvas)

metabase <- read_delim("02_middle-analysis_outputs/analysis_tables/genera_analysis_combined.tsv", delim = "\t")
metabase <- metabase %>% select(accession, species, sample_type)
metabase$species <- gsub("s__", "", metabase$species)

treebase <- ape::read.tree("02_middle-analysis_outputs/gtdbtk_stuff/20241224_de_novo_wf/gtdbtk.bac120.decorated.tree")

# just worked out why this errors, when its looking in the tree, it needs the GB_/RS_ on front
# in the other file I had two columns for that (one with one without), but this one has them removed
# by default, so i need to add them back in
metabase$fullacc <- metabase$accession 
metabase$fullacc <- gsub("GCA", "GB_GCA", metabase$fullacc)
metabase$fullacc <- gsub("GCF", "RS_GCF", metabase$fullacc)
# right, that was a right fucking pain, i don't get why this can only work this way
# theres gotta be a way to do it cleverly, but im waay too fucking hangry right now
# and again more shit, this time its that the home samples are wrong
metabase[metabase$sample_type == "bangor",]$fullacc <-
  paste0("flye_asm_", metabase[metabase$sample_type == "bangor",]$fullacc, "_part2")
# ok, another pain in the ass sorted, onto thing 3, im missing 1Dt100h
metabase[nrow(metabase) + 1,] <- list('1Dt100h', '', 'bangor', 'flye_asm_1Dt100h_part2')
#I might genuinly be the GOAT

tree <- keep.tip(treebase, metabase$fullacc)
rm(treebase)

metabase$display_label <- ifelse(
  metabase$sample_type == "bangor",
  paste0("**", metabase$accession, "**"),  # Just bold accession for bangor
  paste0(metabase$accession, "  *", metabase$species, "*")  # Accession and italic species for others
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

ggsave("02_middle-analysis_outputs/gtdbtk_stuff/output_trees/big_funny.png", 
       plot = p, width = 4800, height = 4800, units = "px")

# thats all well and good, but i need to split the tree into three elements to see shit
# or i could make it interactive with a zoom? could i do that?
# i have just seen something about the "phylocanvas" package
#q <- 
phylocanvas(tree = tree, treetype = "rectangular", nodesize = 15, textsize = 15,
            linewidth = 2, showscalebar = TRUE)

style_node(q, nodeid = "flye_asm_2Dt1e_part2", color = "yellow")
# info on "nodestyles" was hard to come by, i found this:
# Available Parameters:
#   You can customize node styles using parameters such as color, shape, 
#nodesizeratio, strocolor, fillcolor, linewidth, labelcolor, 
#labeltextsize, labelfont, and labelformat. 
# oh ho, and you can use "style_node()" to do personalised stylings
# perhaps, for example, a list of 10... (i think the above params are for that)
# ok, i think nodestyles = has been degraded in favour of style_nodes()