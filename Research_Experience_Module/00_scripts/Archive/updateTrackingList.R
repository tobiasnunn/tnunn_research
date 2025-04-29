# This will read the relevant directories and update the tracker file
# with the details of the files that exist
# 1. read the fasta files
# 2. read the json files
# 3. read the eggnog Excel files

# TODO: add handling for the fastas being archived once eggnog-mapper has
# completed


library(dplyr)

tracking_list <- read.delim('02_middle-analysis_outputs/ncbi_stuff/tracker_file.tsv', 
                            sep = "\t")

#---------------1. read the fasta files-----------------------------------------
# these are in zip files in ncbi_stuff/fasta

file_list <- list.files('02_middle-analysis_outputs/ncbi_stuff/fasta', 
                        pattern = "*.zip", 
                        full.names = TRUE)

zipped_fasta_names <- c()

for (i in 1:length(file_list))
{
    zipped_fasta_names <- append(zipped_fasta_names, grep('\\.fna$', unzip(file_list[i], list=TRUE)$Name, 
                             ignore.case=TRUE, value=TRUE))
  
}

fasta_df <- data.frame(filename = zipped_fasta_names)
fasta_df$accession <- sub("^([^_]*_[^_]*).*", "\\1", fasta_df$filename)

# add on the local fastas
file_list <- list.files('01_inputs', 
                        pattern = "*.fasta", 
                        full.names = FALSE)
fasta_names <- data.frame(filename = file_list)
fasta_names$accession <- gsub("flye_asm_|_part2.fasta", "", fasta_names$filename)

fasta_df <- rbind(fasta_names, fasta_df)

tracking_list[which(tracking_list$accession %in% fasta_df$accession),]$fasta_obtained = TRUE


tracking_list <- tracking_list %>%
  left_join(
    fasta_df %>%           
      select(accession, new_file_name = filename), 
    by = "accession"
  ) %>%
  mutate(
    fasta_file_name = if_else(
      is.na(new_file_name),
      as.character(fasta_file_name),
      as.character(new_file_name) 
    )
  ) %>%
  select(-new_file_name)


#-----------------------4. write back to tracking file--------------------------
write_delim(tracking_list, 
            file = '02_middle-analysis_outputs/ncbi_stuff/tracker_file.tsv', 
            delim = "\t",
            quote = "needed",
            col_names = TRUE)
