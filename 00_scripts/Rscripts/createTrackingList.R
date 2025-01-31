# I have got c. 1800 accessions to keep track of. For each one, I need:
#  - a fasta file
#  - a json file from NCBI (excluding the local samples)
#  - an eggnog analysis file
#
# This script will create a file with the list of accessions in, and placeholders
# to store TRUE/FALSE for each type of file I have

library(tidyverse)
inputfile <- read.delim('02_middle-analysis_outputs/gtdbtk_stuff/20241224_de_novo_wf/gtdbtk.bac120.decorated.tree-taxonomy', 
                        sep = "\t", 
                        header = FALSE,
                        col.names = c('accession', 'path')
                       ) %>% 
  separate_wider_delim(
    path, 
    delim = "; ", 
    names = c("domain", "phylum", "class", "order", "family", "genus", "species"), 
    too_few = "align_start",
    too_many = "merge")


local <- filter(inputfile, grepl("flye", accession))

outputfile <- filter(inputfile, family %in% c('f__Sphingomonadaceae', 'f__Microbacteriaceae')|genus %in% local$genus)

outputfile$accession <- gsub("GB_|RS_|flye_asm_|_part2", "", outputfile$accession)

outputfile <- outputfile[,c('accession', 'family', 'genus', 'species')] 

outputfile$fasta_obtained = FALSE
outputfile$json_obtained = FALSE
outputfile$eggnog_obtained = FALSE
outputfile$fasta_file_name = ""

local$accession <- gsub("GB_|RS_|flye_asm_|_part2", "", local$accession)

outputfile[which(outputfile$accession %in% local$accession), ]$fasta_obtained <- TRUE
outputfile[which(outputfile$accession %in% local$accession), ]$json_obtained <- NA

write_delim(outputfile, 
            file = '02_middle-analysis_outputs/ncbi_stuff/tracker_file.tsv', 
            delim = "\t",
            quote = "needed",
            col_names = TRUE)
