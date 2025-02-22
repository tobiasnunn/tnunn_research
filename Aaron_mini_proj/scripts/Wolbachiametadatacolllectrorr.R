library(httr2)
library(tidyverse)
library(jsonlite)
library(tidyr)
library(purrr)
library(tidyjson)
library(writexl)
#-----------------------------1. import data---------------
# lookup what genus each of our local samples is in, AUTOMATE
# using gtdb-tk file
# read it in:

treetax <- read.delim('hawk_outputs/wolbachia_out/infer/gtdbtk.bac120.decorated.tree-taxonomy', 
                        sep = "\t", 
                        header = FALSE,
                        col.names = c('accession', 'path')) %>% 
  separate_wider_delim(
    path, 
    delim = "; ", 
    names = c("domain", "phylum", "class", "order", "family", "genus", "species"), 
    too_few = "align_start",
    too_many = "merge")



#----------------------------2. identify Wolbachia and clean-----------
# find Wolbachia
treetax <- treetax %>% 
  filter(genus == "g__Wolbachia")
# get rid of extra text "GB/RS_" and "flye_asm_/_part2":
treetax$accession <- gsub("GB_|RS_|flye_asm_|_part2", "", treetax$accession)
ncbi_samples <- treetax %>% 
  filter(species != "s__")
#-----------------------------3. API time---------------------
urlstring <- 'https://api.ncbi.nlm.nih.gov/datasets/v2/'
api_header <- 'd4f921c91015c68f48f656a99ad5bcf84a08'

for (i in 1:nrow(ncbi_samples)) {
  accession <- ncbi_samples$accession[i]
  req <- request(base_url = urlstring) %>% 
    req_auth_bearer_token(api_header) %>%
    req_url_path_append("genome", "accession", accession, "dataset_report") %>%
    req_url_query(filters.assembly_version='all_assemblies') %>%
    req_headers(Accept = 'application/json') %>%
    req_perform(path = paste0("outputs/ncbi_json/", accession, '.json'))
}

# code block explaination: create variable with accession ID / create req[a httr2 object
# of type request(basically, a packet or box of stuff we hand to the API so it knows
# what we want from the NCBI website)] and pass in the NCBI website API URL / add onto 
# req the key i need so they know i am a trusted individual / append into the url string
# other fields that specify what command i want to run / filters.assembly_version is
# a field inside the command i want to run, setting it to all means i get back
# supressed accessions as well, as that is good to note / we want files of type JSON /
# this line says where i want the files to be stored once they are pulled down, this uses
# relative file paths because i am in an R project

# NOTE: the command req_dry_run() piped at the end of the API call is good for testing
# so you know all the parameters are right / also using i <- 1 in order to itterate
# over the lines of a for loop one at a time to avoid trouble and see if it works /
# i forgot to take out the local samples, not a biggie, but something to do in future


#--------------------------------read in jsons and manipulate--------------------- 
filenames <- list.files("outputs/ncbi_json/", 
                        pattern=glob2rx("GC*.json"), full.names=TRUE)
jsonlist <- lapply(filenames, jsonlite::read_json) %>% sapply(., "[[", 1)
reports <- tibble(report=jsonlist)

expand <- data.frame(spread_all(jsonlist, recursive = TRUE, sep = "."))

write_xlsx(expand, path = "outputs/Wolbachia_metadata_table.xlsx", col_names = TRUE)

#get the fields i want to see
metadata <- reports %>%
  hoist(report,
        "accession",
        "average_nucleotide_identity",
        "assembly_info",
        "checkm_info") %>%
  hoist(assembly_info,
        "assembly_status",
        "refseq_category") %>%
  hoist(average_nucleotide_identity,
        "taxonomy_check_status",
        "match_status") %>%
  hoist(checkm_info,
        "completeness",
        "completeness_percentile",
        "contamination") %>%
  select(c("accession", "assembly_status", "refseq_category", "taxonomy_check_status", "match_status",
           "completeness", "completeness_percentile", "contamination"))

Wolbachia_combined <- treetax %>% 
  left_join(metadata, by = "accession")

Wolbachia_combined$sample_type <- "ncbi"

Wolbachia_combined$sample_type[Wolbachia_combined$refseq_category == "reference genome"] <- "reference"
Wolbachia_combined$sample_type[Wolbachia_combined$species == "s__"] <- "bangor"
# supressed samples
#Wolbachia_combined$sample_type[Wolbachia_combined$assembly_status == "suppressed"] <- "suppressed"

# now take only the columns with useful stuff
write_delim(Wolbachia_combined, file = "outputs/Wolbachia_combined.tsv", delim = "\t")
