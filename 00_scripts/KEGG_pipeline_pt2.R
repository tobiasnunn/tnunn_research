library(ggplot2)

# read in output from pt1
heatmapbase <- read_delim("02_middle-analysis_outputs/eggnog_stuff/post_eggnog_pipeline/kegg_enriched_pathways.tsv", delim = "\t")

# change to proportions rather than number of genomes:

