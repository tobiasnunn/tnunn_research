library(tidyverse)

#--------------------------------create the control files------------------------

analysis_accession_list <- read.delim("02_middle-analysis_outputs/analysis_tables/genera_analysis_combined.tsv")

# get local samples and remove ones i have already done in prototype / suppressed accessions

excluded_accessions <- rbind(filter(analysis_accession_list, sample_type == "bangor"), filter(analysis_accession_list, assembly_status == "suppressed"))

existingfastas <- data.frame(filename = list.files("02_middle-analysis_outputs/ncbi_stuff/fasta/", pattern = "*.fna"))
existingfastas <- existingfastas %>% separate_wider_regex(cols = filename, 
                                                          cols_remove = FALSE, patterns = c(accession = "^(?:.*?_.*?)", "_", rest = ".*"))
existingfastas$rest <- NULL

# which fastas have already been eggnog'ed
eggnogfiles <- data.frame(filename = list.files("02_middle-analysis_outputs/eggnog_stuff/eggnog_outputs/", pattern = "*.xlsx"))
eggnogfiles$accession <- sub("\\.(emapper).*", "", eggnogfiles$filename)
rm(analysis_accession_list)

list_to_process <- filter(existingfastas, !existingfastas$accession %in% eggnogfiles$accession & 
                            !existingfastas$accession %in% excluded_accessions$accession)

# order alphabetically descending so can remove 4 ive already done (maybe a desc())
list_to_process <- list_to_process %>% arrange(desc(accession))
rm(existingfastas, excluded_accessions, eggnogfiles)
#loop them into groups for the control files
total_loops <- ceiling(nrow(list_to_process) / 25)

for (i in 1:total_loops) {
  end_num <- (i * 25)
  start_num <- end_num - 24
  #print(paste0("start_num: ", start_num, "   ",  "end_num: ", end_num))
  batch <- list_to_process[start_num:end_num,]
  batch <- batch[!is.na(batch$accession),]
  dir.create(file.path("02_middle-analysis_outputs/ncbi_stuff/fasta", paste0("batch_", i)), showWarnings = FALSE)
  # identify the folders
  current.folder <- "02_middle-analysis_outputs/ncbi_stuff/fasta/"
  new.folder <- paste0("02_middle-analysis_outputs/ncbi_stuff/fasta/batch_", i, "/")
  
  # copy the files to the new folder
  file.rename(paste0(current.folder, batch$filename), paste0(new.folder, batch$filename))
} 

# i did an oopsie and put them all in directories before i created the control scripts
# now i have to code a way to create the files by itterating over the directories
# bit of a hastle but ok in the long run
# this file wants to by a tsv of two columns, the accession, then the full name
directory_list <- data.frame(directory = list.dirs(path = "02_middle-analysis_outputs/ncbi_stuff/fasta/"),
                             name_dir = list.dirs(path = "02_middle-analysis_outputs/ncbi_stuff/fasta/", full.names = FALSE)) %>% 
  filter(grepl("*batch*", directory))

for (i in 1:nrow(directory_list)) {
  #i <- 1
  file_list <- data.frame(file_name = list.files(path = directory_list$directory[i]))
  file_list <- file_list %>% separate_wider_regex(cols = file_name, 
                                                  cols_remove = FALSE, patterns = c(accession = "^(?:.*?_.*?)", "_", rest = ".*"))
  file_list$rest <- NULL
  write_delim(file_list, paste0("02_middle-analysis_outputs/eggnog_stuff/control_files/genera_control_file_", directory_list$name_dir[i], ".tsv"), 
              delim = "\t", col_names = FALSE)
}






#dir.create(file.path("02_middle-analysis_outputs/ncbi_stuff/fasta", paste0("batch_", i)), showWarnings = FALSE)
#OUTMODED CODE
# manually done the top 4, so now i gotta cut them out of the list
# so i can break the remainder into groups
# save what is left into 3 tsvs, two with 12 and one with 13(manually)
# write_delim(testfna_list[5:17,], "02_middle-analysis_outputs/analysis_tables/prototypedatafile1.tsv", delim = "\t", col_names = FALSE)
# write_delim(testfna_list[18:29,], "02_middle-analysis_outputs/analysis_tables/prototypedatafile2.tsv", delim = "\t", col_names = FALSE)
# write_delim(testfna_list[30:41,], "02_middle-analysis_outputs/analysis_tables/prototypedatafile3.tsv", delim = "\t", col_names = FALSE)
