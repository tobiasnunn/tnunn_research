library(httr2)
library(tidyverse)

#-----------------------------1. import data---------------
# lookup what genus each of our local samples is in, AUTOMATE
# using gtdb-tk file
# read it in:

treetax <- read.delim('02_middle-analysis_outputs/gtdbtk_stuff/20241224_de_novo_wf/gtdbtk.bac120.decorated.tree-taxonomy', 
                        sep = "\t", 
                        header = FALSE,
                        col.names = c('accession', 'path')) %>% 
  separate_wider_delim(
    path, 
    delim = "; ", 
    names = c("domain", "phylum", "class", "order", "family", "genus", "species"), 
    too_few = "align_start",
    too_many = "merge")



#----------------------------2. identify Bangor genera and clean-----------
# find Bangor genera:
bangor <- filter(treetax, grepl("flye", accession))
genera <- filter(treetax, genus %in% bangor$genus)

# get rid of extra text "GB/RS_" and "flye_asm_/_part2":
genera$accession <- gsub("GB_|RS_|flye_asm_|_part2", "", genera$accession)

#-----------------------------3. API time---------------------
urlstring <- 'https://api.ncbi.nlm.nih.gov/datasets/v2/'
api_header <- 'd4f921c91015c68f48f656a99ad5bcf84a08'

for (i in 1:587) {
  accession <- genera$accession[i]
  req <- request(base_url = urlstring) %>% 
    req_auth_bearer_token(api_header) %>%
    req_url_path_append("genome", "accession", accession, "dataset_report") %>%
    req_url_query(filters.assembly_version='all_assemblies') %>%
    req_headers(Accept = 'application/json') %>%
    req_perform(path = paste0("02_middle-analysis_outputs/ncbi_stuff/json/", accession, '.json'))
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