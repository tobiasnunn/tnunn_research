# This script does the following:
# 1. Imports a .tree file from the specified directory
# 2. Takes the tip labels which refer to NCBI samples and constructs an API call
#     to get a dataset per sample
# 3. Parses the dataset to pull out the pieces of information of most interest to us:
#     - species name
#     - sample status, i.e. reference, suppressed
# 4. Combines this with the information about the samples taken in the Bangor lab to
#     produce a phylo tree plot with appropriate colours and symbols
# 5. Saves this to a png in the same directory
# the local sample data comes from: C:\Users\tobyn\OneDrive\Work\tnunn_research\2024-25 Research\frog bacteria\02 data\scriptmakerdatasets version 1.xlsx


# Loading packages
library(httr)
library(jsonlite)
library(tidyverse)
library(ape)
library(ggtree)
library(readxl)


## SET UP FILES AND CONSTANTS ##

# all the tree files are shown below, uncomment the required line to run the code
# CTRL+shift+ENTER will run all the lines of code
 treefilename <- '1Dt100h_2Dt1e.tree'
# treefilename <- '2Dt1l.tree'
# treefilename <- 'sphingomonas.tree'
# treefilename <- '1Dt1h.tree'
# treefilename <- '3Dt2h.tree'
# treefilename <- '1Dt2d.tree'

treefiledirectory <- 'C:/Users/tobyn/OneDrive/Work/tnunn_research/2024-25 Research/frog bacteria/02 data/'
# treefiledirectory <- '~/OneDrive/Work/re-run phylo trees/'

# order of colours needs to match order of node types - local, other_ncbi, reference, suppressed
colour_array <- c("darkblue", "black", "darkgreen", "red3")

urlstring <- 'https://api.ncbi.nlm.nih.gov/datasets/v2/genome/accession/'

api_header <- 'd4f921c91015c68f48f656a99ad5bcf84a08'

##IMPORT THE TREE AND EXTRACT ALL THE TIP LABELS

#load in the tree file

tree <- read.tree(paste(treefiledirectory, treefilename, sep=""))

p <- ggtree(tree)

#get the tip labels
myTipLabels <- data.frame(original_name = get_taxa_name(p))

#add a column for the name without the leading RS or GB
myTipLabels <- myTipLabels %>% mutate(converted_name = str_replace(original_name, 'RS_|GB_', ''))

#get the non-local tip labels and concatenate into a string separated by the url encoding
#for comma
list_of_accessions <- myTipLabels %>% filter(!grepl("flye", converted_name))
list_of_accessions <- paste(list_of_accessions$converted_name, collapse='%2C')

#combine into one string
combined_string <- paste(urlstring,list_of_accessions, '/dataset_report', sep="")
combined_string

#CALL THE API AND PROCESS THE RESULTS

#call the API
api_response <- GET(combined_string, query = list(filters.assembly_version='all_assemblies', page_size=40), add_headers(api_key=api_header, Accept='application/json'))

#TODO: add some error handing here on the api_reponse, check the status code is 200 before proceeding

api_content <- content(api_response, "text", encoding = "UTF-8")
api_json <- fromJSON(api_content)

api_reports <- api_json$reports
# now we need to extract info from different sub-objects of the JSON
# from organism, the organism_name
# from assembly_info the status (i.e. suppressed or not)
# from assembly_info the refseq_category

api_reports <- api_reports %>% unnest(assembly_info) %>% unnest(organism)

api_reports <- select(api_reports, accession, organism_name, assembly_status, refseq_category)

api_reports <- api_reports %>% mutate(node_type = case_when(refseq_category == "reference genome" ~ "reference", assembly_status == "suppressed" ~ "suppressed", TRUE ~ "other_ncbi"))

api_reports <- api_reports %>% mutate(tiplabel = paste(accession, organism_name, sep="\n"))

#GET THE DATA ABOUT THE LOCAL SAMPLES

#Now load in all the local samples

localsamples <- read_excel(paste(treefiledirectory, 'scriptmakerdatasets version 1.xlsx', sep=''), 
                                            sheet = "Provided by Alberto")

mylocalsamples <- select(localsamples, ID, Blastn) %>% mutate(accession = paste('flye_asm_', ID, '_part2', sep='')) %>% mutate(node_type = "local")
mylocalsamples$accession <- gsub('-', '', mylocalsamples$accession)

#And select the ones that match with our list of tip labels

mylocalsamples <- subset(mylocalsamples, accession %in% myTipLabels$converted_name)
mylocalsamples <- mylocalsamples %>% mutate(tiplabel = paste(accession, Blastn, sep="\n"))

#Now we need to take data from mydf and mylocal samples, and match it back to myTipLabels 
#merging to itself leads to duplicate columns, so append mydf and mylocal first, before the merge

combined_data <- select(api_reports, accession, tiplabel, node_type)
mylocalsamples <- select(mylocalsamples, accession, tiplabel, node_type)

combined_data <- rbind(combined_data, mylocalsamples)
colnames(combined_data) = c("converted_name", "fullname","node_type")

#now match the data back to the original tip labels

myTipLabels <- merge(x = myTipLabels, y=combined_data, by="converted_name", all.x=TRUE)
colnames(myTipLabels) = c( "converted_name", "label", "full_name", "node_type")
myTipLabels <- myTipLabels[, c(2, 1, 3, 4)]

p <- p %<+% myTipLabels

titleaccession <- c(mylocalsamples$accession)
Title2 <- paste(titleaccession, sep = "", collapse = ", ")
Title <- paste('Phylogenetic tree for ', Title2, sep = "")

#png(paste(treefiledirectory, treefilename, '.png', sep=""), width = 1000, height = 1000, res = 100)

p + (aes(,,fill = node_type, color = node_type, shape = node_type, label = full_name)) + 
  xlim(0, 2) + theme_tree2() +
  geom_tiplab(aes(label=full_name), size = 2.4) +
  scale_color_manual(values = colour_array ) +
  scale_fill_manual(values = colour_array) +
  scale_shape_manual(values = c(21, 21, 23, 8) ) +
  geom_tippoint(size = 2, alpha = 1) +
  ggtitle( Title, subtitle= 'created using gtdb-tk') 

#dev.off()



# TODO:
# 1. add error handling for API call to ensure there is a status 200
# 2. for loop in so it will do for each tree file auto stylie 
# 3. add processing to calculate the righ width and height based on the number of taxa
# 4. calculate the right xlim value by using the distance attributes
# 5. iterate over the directory with the tree files and do all of em
# 6. output to outputs folder

