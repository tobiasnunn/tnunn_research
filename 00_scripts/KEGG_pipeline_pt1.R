library(dplyr)
library(tidyr)
library(tidyverse)
library(readxl)

# read in metadata file
metadata <- read_delim("02_middle-analysis_outputs/eggnog_stuff/post_eggnog_pipeline/prototype_metadata.tsv", delim = "\t", show_col_types = FALSE)

# read in all the .xlsx files
for (i in 1:nrow(metadata)) {
  intermed <- read_excel(paste0("02_middle-analysis_outputs/eggnog_stuff/eggnog_outputs/", metadata$accession[i], ".emapper.annotations.xlsx"),
                         skip = 2, col_names = TRUE)
}
