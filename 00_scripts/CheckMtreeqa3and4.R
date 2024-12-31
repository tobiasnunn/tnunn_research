library(dplyr)
library(tidyverse)
library(gt)
library(ggtree)
#---------------------load tree-------------------------------------
taxtree <- read.tree(file = "02_middle-analysis_outputs/CheckM/checkmtreeqa/checkmtreeqa_taxtree.tree")

Rtree <- ggtree(taxtree) + geom_tiplab()
#---------------------prune-----------------------------------------
short <- viewClade(Rtree, MRCA(Rtree, "'flye_asm_3Dt2j_part2'", "'flye_asm_1Dt100g_part2'"))
short

short <- viewClade(Rtree, MRCA(Rtree, "'flye_asm_3Dt2h_part2'", "'flye_asm_2Dt1l_part2'"))
short

short <- viewClade(Rtree, MRCA(Rtree, "'IMG_647000216|k__Bacteria;p__Actinobacteria;c__Actinobacteria;o__Actinomycetales;f__Brevibacteriaceae;g__Brevibacterium;s__Brevibacterium_mcbrellneri'", "'flye_asm_1Dt1h_part2'"))
short

short <- viewClade(Rtree, MRCA(Rtree, "'flye_asm_1Dt100h_part2'", "'flye_asm_2Dt1e_part2'"))
short

short <- viewClade(Rtree, MRCA(Rtree, "'flye_asm_1Dt2d_part2'", "'IMG_649633081|k__Bacteria;p__Proteobacteria;c__Gammaproteobacteria;o__Enterobacteriales;f__Enterobacteriaceae;g__Pantoea;s__'"))
short
# manual export to pdf, rough guide is 1400 width, then let autofill hight.