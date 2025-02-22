library(tidyverse)
library(ape)
library(ggtree)

metabase <- read_delim("outputs/Wolbachia_combined.tsv", delim = "\t")
metabase <- metabase %>% select(accession, species, sample_type)

wolbachia_tree <- ggtree::read.tree("outputs/g_Wolbachia.tree")

tree_output <- ggtree(wolbachia_tree)
tree_output$data$label <- gsub("GB_|RS_|flye_asm_|_part2", "", tree_output$data$label)
tree_output$data <- left_join(tree_output$data, metabase, by = join_by("label" == "accession"))
tree_output$data$label <- paste0(tree_output$data$label, "\n", tree_output$data$species)

tree_output +
  geom_tiplab()

root_test <- root(wolbachia_tree, outgroup = "RS_GCF_001752665.1", edgelabel = TRUE)

ggtree(root_test, branch.length = "none")
