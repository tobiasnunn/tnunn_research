library(httr2)
library(tidyverse)

# read in combined table
combi <- read.delim("02_middle-analysis_outputs/analysis_tables/genera_analysis_combined.tsv")

# filter this so were left with "good samples"

filtered <- filter(combi, sample_type == "ncbi" & taxonomy_check_status == "OK" & is.na(refseq_category) & assembly_status == "current" & match_status != "below_threshold_mismatch")

subset <- filtered %>% group_by(genus) %>% slice_sample(n=10)

local <- filter(combi, sample_type == "bangor" & family != "f__")

countbygenus <- local %>% group_by(genus) %>% count()

# NOTE: improve the automation on this bit, a for loop could do that
fastalist <- filter(subset, 1 == 0)

for (i in 1:nrow(countbygenus)) {
  fastalist <- rbind(fastalist, slice_sample(filter(subset, genus == countbygenus[i,"genus"]), n=10-countbygenus$n[i]))
}


# call the API, get .fastas
urlstring <- 'https://api.ncbi.nlm.nih.gov/datasets/v2/'
api_header <- 'd4f921c91015c68f48f656a99ad5bcf84a08'

for (i in 1:nrow(fastalist)) {
  accession <- fastalist$accession[i]
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
}

#--------------------------------create the control files------------------------
fna_list <- data.frame(filename = list.files("02_middle-analysis_outputs/ncbi_stuff/fasta/", 
                     pattern=glob2rx("GC*.fna"), full.names=FALSE))

# create another column called accession using the content in filename
# fna_list <- separate(fna_list, filename, into = c("accession", "rest"), sep = "_", remove = FALSE, fill = "right")
# fna_list$accession <- paste(fna_list$accession, fna_list$rest, sep = "_")
# fna_list$rest <- NULL

# accession column ~BUT FANCY~
testfna_list <- data.frame(filename = list.files("02_middle-analysis_outputs/ncbi_stuff/fasta/", 
                                             pattern=glob2rx("GC*.fna"), full.names=FALSE))
testfna_list <- testfna_list %>% separate_wider_regex(cols = filename, 
                                      cols_remove = FALSE, patterns = c(accession = "^(?:.*?_.*?)", "_", rest = ".*"))
testfna_list$rest <- NULL

# saving the list to a file in case i have to delete the variables
write_delim(testfna_list, "02_middle-analysis_outputs/analysis_tables/prototypelist.tsv", delim = "\t")

# order alphabetically descending so can remove 4 ive already done (maybe a desc())
testfna_list <- testfna_list %>% arrange(desc(accession))
# manually done the top 4, so now i gotta cut them out of the list
# so i can break the remainder into groups
# save what is left into 3 tsvs, two with 12 and one with 13(manually)
write_delim(testfna_list[5:17,], "02_middle-analysis_outputs/analysis_tables/prototypedatafile1.tsv", delim = "\t", col_names = FALSE)
write_delim(testfna_list[18:29,], "02_middle-analysis_outputs/analysis_tables/prototypedatafile2.tsv", delim = "\t", col_names = FALSE)
write_delim(testfna_list[30:41,], "02_middle-analysis_outputs/analysis_tables/prototypedatafile3.tsv", delim = "\t", col_names = FALSE)
