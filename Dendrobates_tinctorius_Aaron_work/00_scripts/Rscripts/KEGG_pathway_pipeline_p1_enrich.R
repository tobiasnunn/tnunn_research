#get all the KOs for a given eggnog file and then chuck the whole lot at 
#enrichKO in one go
library(tidyverse)
library(MicrobiomeProfiler)
library(readxl)

eggnog_directory <- "02_middle-analysis_outputs/eggnog_stuff/eggnog_outputs/"

eggnog_files <- data.frame(filepath = list.files(eggnog_directory, 
                           pattern = "*.xlsx", full.names = TRUE),
                           filename = list.files(eggnog_directory, 
                                                 pattern = "*.xlsx", full.names = FALSE)) 

eggnog_files$accession <- sub("\\.(emapper).*", "", eggnog_files$filename)


for (i in 1:nrow(eggnog_files))
{
  intermed <- read_excel(eggnog_files$filepath[i], range = "L4:L60000", col_names = c("ko_id"))
  intermed <- intermed[intermed$ko_id != "-" & !is.na(intermed$ko_id),] %>% 
    mutate(ko_id = str_replace_all(ko_id, "ko:", "")) %>%  separate_longer_delim(ko_id, delim = ",")
  enriched <- enrichKO(intermed$ko_id)
  if (! is.null(enriched))
  {
    result_data <- enriched@result %>%
      filter(p.adjust < 0.05)
    result_data$accession <- eggnog_files$accession[i]
    write_delim(result_data, file = paste0(eggnog_directory, eggnog_files$accession[i], "_ko_pathway.tsv"), delim = "\t")
  }

}
