# right, this file is a sort of alternate to the KEGG_Pipeline files i made
# previously. Because i want to see what a heatmap of KO values looks like 
# as I believe those are what the genes code for, and the pathways are misleading.

#libraries
library(dplyr)
library(tidyr)
library(tidyverse)
library(readxl)

# this is going to bring in the excel files output by eggNOG-mapper so i can
#analyse the KO values. 
eggnogfiles <- data.frame(filename = list.files("02_middle-analysis_outputs/eggnog_stuff/eggnog_outputs/", pattern = "*.xlsx"))
eggnogfiles$accession <- sub("\\.(emapper).*", "", eggnogfiles$filename)

ko_val <- data.frame(accession = character(), ko_id = character())

for (i in 1:nrow(eggnogfiles))
{
  #read in the ko_id column of the spreadsheet
  #clean the data
  fullfilename <- paste0("02_middle-analysis_outputs/eggnog_stuff/eggnog_outputs/",
                         eggnogfiles$filename[i])
  intermed <- read_excel(fullfilename, range = "L4:L60000", col_names = c("ko_id"))
  intermed <- intermed[intermed$ko_id != "-" & !is.na(intermed$ko_id),] %>% 
    mutate(ko_id = str_replace_all(ko_id, "ko:", "")) %>%  separate_longer_delim(ko_id, delim = ",")
  intermed$accession <- eggnogfiles$accession[i]
  intermed <- select(intermed, accession, ko_id)
  ko_val <- rbind(ko_val, intermed)
}

#write it out
write_delim(ko_val, file = "02_middle-analysis_outputs/eggnog_stuff/post_eggnog_pipeline/ko_analysis.tsv",
            delim = "\t")

# now i want to see if this is actually the right trajectory to be on
# if they all have all of the genes then map id is valid
# so lets run a unique and see

# NOTE: taking the unique means that I dont get any data on how "important" a
# gene is to an individual because i cant see how many times it is repeated in 
# the genome, but I believe this makes heatmap construction simpler
unique_ko_and_accession <- unique(ko_val[c("accession", "ko_id")])
# if I read in the genera now, i have what i need to heatmap on after the count
genera <- read_delim("02_middle-analysis_outputs/eggnog_stuff/post_eggnog_pipeline/genera_metadata.tsv",
                     delim = "\t")
unique_ko_and_accession <- unique_ko_and_accession %>% left_join(genera, by = "accession")
# now i need to do a count
ko_count <- unique_ko_and_accession %>% group_by(ko_id, genus) %>% count(name = "count")

# for future reference(and because its cool) here is a non-grouped count
#ko_count_no_genus <- unique_ko_and_accession %>% group_by(ko_id) %>% count(name = "count")

# in order to make proportions i need to add a column for total genera size
# i can do this by doing another count, this time on genus alone
genera_count <- genera %>% group_by(genus) %>% count(name = "total")

# i now need to left join counts 1 and 3
# after that I have what I need, lets make the proportion column
ko_count <- (ko_count %>% left_join(genera_count, by = "genus")) %>% 
  mutate(proportion = count / total)
# I had to do this kind of a funky way, i was having an error because it was
#trying to do both steps at the same time, but i needed it to do 1, then 2
# so i saw online that putting brackets forced a step to happen first, kind of
# like BIDMAS for computer science, so that is what i did, and it worked :)
#https://dplyr.tidyverse.org/articles/programming.html

# ok, so now i need to get the frame into a fromat i can do good stuff on
# this involves a pivot wider to make the "proportion" column the values

ko_pivot <- ko_count %>% select(ko_id, genus, proportion) %>% 
  pivot_wider(names_from = genus, values_from = proportion, values_fill = 0)
# values_fill = 0 cause any NAs that may pop up to replace with 0, which works for this

# now i need to filter it where values in a column are more than 0.8, and the 
# others are less than 0.5, this is neither rowise nor columnwise, so i think
# i was barking up the wrong tree in regards to my last heatmaps (it was not 80%
# of the enrichments seen across all genera, just for the specific ones).

data_filtered <- ko_pivot %>% 
  filter(if_any(everything(), ~ . > 0.5))
