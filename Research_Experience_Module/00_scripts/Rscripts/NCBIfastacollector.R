library(httr2)
library(tidyverse)

#--------------------------------get the fastas-------------------------------
# read in combined table
analysis_accession_list <- read.delim("02_middle-analysis_outputs/analysis_tables/genera_analysis_combined.tsv")

# get local samples and remove ones i have already done in prototype / suppressed accessions

excluded_accessions <- rbind(filter(analysis_accession_list, sample_type == "bangor" & family != "f__"), filter(analysis_accession_list, assembly_status == "suppressed"))

existingfastas <- data.frame(filename = list.files("02_middle-analysis_outputs/ncbi_stuff/fasta/", pattern = "*.fna"))
existingfastas <- existingfastas %>% separate_wider_regex(cols = filename, 
                                           cols_remove = FALSE, patterns = c(accession = "^(?:.*?_.*?)", "_", rest = ".*"))
existingfastas$rest <- NULL

list_to_process <- filter(analysis_accession_list, !analysis_accession_list$accession %in% existingfastas$accession & 
                            !analysis_accession_list$accession %in% excluded_accessions$accession)

if(nrow(list_to_process) < 50){
number_to_process <- nrow(list_to_process)
} else{
number_to_process <- 50
}

# call the API, get .fastas
urlstring <- 'https://api.ncbi.nlm.nih.gov/datasets/v2/'
api_header <- 'd4f921c91015c68f48f656a99ad5bcf84a08'

for (i in 1:number_to_process) {
  accession <- list_to_process$accession[i]
  req <- request(base_url = urlstring) %>% 
    req_auth_bearer_token(api_header) %>%
    req_url_path_append("genome", "accession", accession, "download") %>%
    req_url_query( include_annotation_type ='GENOME_FASTA') %>%
    req_perform(path = paste0("02_middle-analysis_outputs/ncbi_stuff/fasta/", accession, '.zip'))
}


# the files come out as .zip files, this is good for space, but we can't pass them into eggnogmapper
# especially as the .fastas are not alone in the .zip, so here is a for loop to unzip:

# right, so to do this one i need a way of saying the "fasta_file_name" while iterating on it
# hmm, the .fna includes that random "ASM709345" string, so i need to make a list of those names?
#but how do i do that without just unzipping all the files?
listed <- list.files("02_middle-analysis_outputs/ncbi_stuff/fasta/", 
           pattern=glob2rx("GC*.zip"), full.names=TRUE)

# now the unzipping

for (i in 1:length(listed)) {
  zipped_fasta_names <- grep('\\.fna$', unzip(listed[i], list=TRUE)$Name, 
                             ignore.case=TRUE, value=TRUE)
  
  unzip(listed[i],
        files=zipped_fasta_names,
        exdir = "02_middle-analysis_outputs/ncbi_stuff/fasta/",
        junkpaths = TRUE)
  file.rename(listed[i], sub("/fasta", "/fasta/zip", listed[i]))
}

# REMINDER: backup .zip files to onedrive
