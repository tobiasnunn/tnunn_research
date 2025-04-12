# right, this file is a sort of alternate to the KEGG_Pipeline files i made
# previously. Because i want to see what a heatmap of KO values looks like 
# as I believe those are what the genes code for, and the pathways are misleading.

#libraries
library(dplyr)
library(tidyr)
library(tidyverse)
library(readxl)
library(jsonlite)
library(tidyjson)
library(ggplot2)
#--------------------------------obtain kos used in eggnog files--------------

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

#-------------------names / lookups--------------------
# bring in the .json file (which contains KOs matched with names so i can do naming and grouping)
KO_json_file <- jsonlite::read_json("01_inputs/ko00001.json", simplifyVector = TRUE) 
# now i have to mess around with it to get it into a good format (this is the hard part)

# i was getting errors with the word data frame, so i slapped KO_match_names into a frame
# and it showed me something good, then i did some hunting around and saw "unnest()" 
# then I added them one at a time until i got what i wanted, 
# sometimes the fanciest thing you can do is the least fanciest thing you can think of. 
#(this took a fair amount of time of looking at very complex and cool code I
# would never be able to do, but look at me now, i got it done in one line)
KO_match_names <- data.frame(KO_json_file) %>% 
  select(-name) %>%
  unnest(cols=everything(),  names_repair = "universal") %>% 
  unnest(cols=everything(),  names_repair = "universal") %>% 
  unnest(cols=everything(),  names_repair = "universal")
# i do love brute force
# anyway, it itsnt perfect, i got errors about "cols... using unnest()" but i like it
# i am gaming
names(KO_match_names) <- c("level1","level2","level3","keggko")
# now i want to separate the code and the name so i can use the code for the labelling
# and then do a table of match names for reference, well see, but it wont hurt to do
# i decided to use REGEX for fancy purposes, i dont get REGEX that good
KO_match_names_expanded <- KO_match_names %>% 
  separate_wider_regex(cols = everything(), patterns = c(code = "[^ ]+", name = ".*"),
                       names_sep = ".", too_few = "align_start") %>% 
  separate_wider_regex(cols = keggko.name, patterns = c(shorthand = "[^;]+", name = "[^\\[]+", rest = ".*"),
                       names_sep = ".", too_few = "align_start") %>% 
  mutate(keggko.name.name = str_trim(str_replace_all(keggko.name.name, ";", "")))

# now I need to create 2 objects, one of the kegg KOs I need for the heatmap and
# another as a lookup table of codes and names

kegg_values <- select(KO_match_names_expanded, starts_with("kegg") | level3.code) %>% 
  rename(keggko.shorthand = keggko.name.shorthand, protein.name = keggko.name.name,
                keggko.reference = keggko.name.rest, lookup.code = level3.code)

#https://magrittr.tidyverse.org/reference/pipe.html
KO_lookups <- select(KO_match_names_expanded, !starts_with("kegg")) %>% 
  unique()

# write those out so i dont have to regenerate later
write_delim(kegg_values, "02_middle-analysis_outputs/KEGG_stuff/kegg_values.tsv", delim = "\t")
write_delim(KO_lookups, "02_middle-analysis_outputs/KEGG_stuff/ko_lookups.tsv", delim = "\t")

#-----------------proportionising---------------------

# If i have already run the first part of the code, it doesnt make sense to
# run it again so i can read back in the file i wrote out here to speed this up
ko_val <- read_delim(file = "02_middle-analysis_outputs/eggnog_stuff/post_eggnog_pipeline/ko_analysis.tsv",
                     delim = "\t")
kegg_values <- read_delim("02_middle-analysis_outputs/KEGG_stuff/kegg_values.tsv", delim = "\t")
KO_lookups <- read_delim("02_middle-analysis_outputs/KEGG_stuff/ko_lookups.tsv", delim = "\t")
# if I read in the genera now, I have what I need to heatmap on after the count
genera <- read_delim("02_middle-analysis_outputs/eggnog_stuff/post_eggnog_pipeline/genera_metadata.tsv",
                     delim = "\t")
# NOTE: taking the unique means that I dont get any data on how "important" a
# gene is to an individual because i cant see how many times it is repeated in 
# the genome, but I believe this makes heatmap construction simpler
unique_ko_and_accession <- unique(ko_val[c("accession", "ko_id")])

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

# Apply the filter using rowwise operations with numeric columns only
# this step was particularly difficult
numeric_cols <- names(ko_pivot)[sapply(ko_pivot, is.numeric)]

data_filtered <- ko_pivot %>%
  rowwise() %>%
  filter(sum(c_across(where(is.numeric)) > 0.8) == 1 & 
           sum(c_across(where(is.numeric)) < 0.5 & c_across(where(is.numeric)) > 0) == length(numeric_cols) - 1) %>%
  ungroup() %>% 
  pivot_longer(cols = -ko_id, names_to = "genus", values_to = "prop")

# the pivot is a complex step, but necessary for ggplot to read it right, cool stuff
# the reason for the & ... > 0 step is because without it i get a ludicrous amount
# of KO values back where most columns are just 0, maybe good for a mega-table
# but for heatmapping the first option is best, and possibly more relevant as it
# shows KOs that appear in all groups, have a look at this to compare:

# data_filtered_with_0 <- ko_pivot %>%
#   rowwise() %>%
#   filter(sum(c_across(where(is.numeric)) > 0.8) == 1 & 
#            sum(c_across(where(is.numeric)) < 0.5) == length(numeric_cols) - 1) %>%
#   ungroup()

# write it out because it is a pain loading it for testing
write_delim(data_filtered, "02_middle-analysis_outputs/KEGG_stuff/datafiltered.tsv", delim = "\t")
#---------------------------------------heatmap generation--------------------
# before I can join, I need to make kegg_values unique (some KOs are in multiple groups
# so appear multiple times in the list)
distinct_kegg_values <- distinct(kegg_values, keggko.code, .keep_all = TRUE)
###NOTE: when mapping I need to say that the groupings may not be accurate because
### many KOs appear in multiple pathways and I dont know their true purpose, it is 
### just an estimate based on where they have been used previously ###

# read data_filtered back in
data_filtered <- read_delim("02_middle-analysis_outputs/KEGG_stuff/datafiltered.tsv", delim = "\t")
# need to add the lookup objects on so I can do naming
data_filtered <- data_filtered %>% 
  left_join(distinct_kegg_values, join_by(ko_id == keggko.code)) %>% 
  left_join(., KO_lookups, join_by(lookup.code == level3.code)) %>% 
  select(ko_id, genus, prop, keggko.shorthand, protein.name, level1.code, level1.name)
# the ., is vital in this working

# testing, the heatmap looked odd and i didnt like that so many were being
# characterised as just one thing, so i decided to try and add a "multiple hierarchies" flag
multi_hierarchy <- kegg_values %>% filter(keggko.code %in% data_filtered$ko_id) %>% 
  left_join(KO_lookups, join_by(lookup.code == level3.code)) %>% 
  group_by(keggko.code, level1.name) %>% count() %>% group_by(keggko.code) %>% count() %>% 
  filter(n > 1)

data_filtered[data_filtered$ko_id %in% multi_hierarchy$keggko.code,]$level1.code <- ""
data_filtered[data_filtered$ko_id %in% multi_hierarchy$keggko.code,]$level1.name <- "Multiple hierarchies"
# heatmaps 
kegg_heatmap <- ggplot(data = data_filtered, mapping = aes(x = fct_rev(genus),
                                                            y = ko_id, 
                                                            fill = prop)) +
  geom_tile(colour = "lightgrey", lwd = 0.5, linetype = 1) +
  labs(x =  "Bacterial Genus", y ="Kegg KO", fill = "proportion\nenriched\ngenomes",
       title = "Comparative prevalance of kegg KO expression between five genera",
       subtitle = "n = 552 samples") +
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5), text = element_text(size = 14)) +
  facet_grid(level1.name ~ ., scales = "free", space = "free") +
  scale_fill_viridis_c(limits = c(0,1), option = "plasma") +
  theme(strip.placement = "outside") +
  theme(strip.text.y = element_text(angle = 0), strip.text = element_text(size = 16)) +
  theme(axis.text = element_text(size = 14), plot.title = element_text(size = 16))

#heatmap without groupings
kegg_heatmap2 <- ggplot(data = data_filtered, mapping = aes(x = fct_rev(genus),
                                                           y = protein.name, 
                                                           fill = prop)) +
  geom_tile(colour = "lightgrey", lwd = 0.5, linetype = 1) +
  labs(x =  "Bacterial Genus", y ="Kegg KO", fill = "proportion\nenriched\ngenomes",
       title = "Comparative prevalance of kegg KO\nexpression between five genera",
       subtitle = "n = 552 samples") +
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5), text = element_text(size = 14)) +
  #facet_grid(level1.name ~ ., scales = "free", space = "free") +
  scale_fill_viridis_c(limits = c(0,1), option = "plasma") +
  theme(strip.placement = "outside") +
  theme(strip.text.y = element_text(angle = 0), strip.text = element_text(size = 16)) +
  theme(axis.text = element_text(size = 14), plot.title = element_text(size = 16))

kegg_heatmap2

ggsave("02_middle-analysis_outputs/KEGG_stuff/KOheatmap_no_group.png", 
       plot = kegg_heatmap2, width = 3700, height = 5500, units = "px")
#NOTE: Pantoea again dominates because it is more different to the other 4 than
# they are to each other

