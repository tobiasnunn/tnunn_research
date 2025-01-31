library(dplyr)
library(tidyr)
library(tidyverse)
library(gt)
library(readxl)
library(tidyjson)
library(purrr)
#-----------------------------------import---------------------------------

# DIAMOND RESULTS
headers <- c("qseqid",	"sseqid",	"pident",	"length",	"mismatch",	"gapopen",	"qstart",	"qend",	"sstart",	"send",	"evalue",	"bitscore")
dires <- read.delim("02_middle-analysis_outputs/CheckM2_20241228/diamond_output/DIAMOND_RESULTS.tsv", header = FALSE)
names(dires) <- headers

# EGGNOG RESULTS

eggnog_files <- list.files("02_middle-analysis_outputs/eggnog_stuff", pattern = ".xlsx", full.names = TRUE)
eggnog_file_list <- lapply(eggnog_files, function(x) read_excel(x, skip = 2, col_names = TRUE))
accession_names <- list.files("02_middle-analysis_outputs/eggnog_stuff", pattern = ".xlsx", full.names = FALSE)
accession_names <- gsub("flye_asm_|_part2.*", "", accession_names)
names(eggnog_file_list) <- accession_names

#----------------------------------manipulation------------------------

#DIAMOND

dires$accession <- gsub("flye_asm_|_part2.*", "", dires$qseqid)

dires$ko_value <- gsub(".*~", "", dires$sseqid)

dires <- dires %>%
  separate_rows(ko_value, sep = "&")

#EGGNOG

eggnog_kos <- eggnog_file_list %>% sapply(., "[[", "KEGG_ko")

# because the number of kos is different, pad to the maximum length with nas 
mx <- max(lengths(eggnog_kos))
eggnog_kos <- data.frame(lapply(eggnog_kos, `length<-`, mx))
eggnog_kos <- pivot_longer(eggnog_kos, 
                           cols = everything(), 
                           names_to = "accession", 
                           values_to = "ko_value")

eggnog_kos <- eggnog_kos[!eggnog_kos$ko_value == "-",] %>%
  separate_rows(ko_value, sep = ",")

eggnog_kos$ko_value <- gsub("ko:", "", eggnog_kos$ko_value)
#note: this line only works because there are no accessions with X in, safer
#would be to remove the first character only
eggnog_kos$accession <- gsub("X", "", eggnog_kos$accession)
eggnog_kos <- eggnog_kos[!is.na(eggnog_kos$accession),]

#-------------------------Direct comp of diamond and eggnog--------------
# previous comparisons took place between one of the methods and a 
# "total" list containing KOs from both, but, having built up the code for this
# can i now compare them to each other directly?

#DIAMOND
comparisondiamond <- dires[c("accession", "ko_value")]
comparisondiamond$accko <- paste(comparisondiamond$accession, comparisondiamond$ko_value, sep = "-")
comparisondiamond <- comparisondiamond %>% arrange(accko)
comparisondiamond$index <- comparisondiamond %>% group_by(accko) %>% mutate(id = row_number())
comparisondiamond$index_number <- unlist(comparisondiamond[["index"]][["id"]])
comparisondiamond$comparison_value <- paste(comparisondiamond$accko,
                                            comparisondiamond$index_number, sep = "-")
comparisondiamond <- data.frame(Accession = comparisondiamond$accession, compvalue = comparisondiamond$comparison_value)


#eggNog-mapper
eggnog_kos$accko <- paste(eggnog_kos$accession,eggnog_kos$ko_value, sep = "-")
comparisonegg <- data.frame(accession = eggnog_kos$accession, accko = eggnog_kos$accko)
comparisonegg <- comparisonegg %>% arrange(accko)
comparisonegg$index <- comparisonegg %>% group_by(accko) %>% mutate(id = row_number())
comparisonegg$index_number <- unlist(comparisonegg[["index"]][["id"]])
comparisonegg$comparison_value <- paste(comparisonegg$accko,
                                            comparisonegg$index_number, sep = "-")
comparisonegg <- data.frame(Accession = comparisonegg$accession, compvalue = comparisonegg$comparison_value)

length(comparisondiamond$compvalue[comparisondiamond$compvalue %in% comparisonegg$compvalue])
length(comparisondiamond$compvalue)
length(comparisonegg$compvalue)

# shared in DIAMOND-total
length(comparisondiamond$compvalue[comparisondiamond$compvalue %in% comparisonegg$compvalue]) / length(comparisondiamond$compvalue)
# shared in egg-total
length(comparisondiamond$compvalue[comparisondiamond$compvalue %in% comparisonegg$compvalue]) / length(comparisonegg$compvalue)

# by group? maybe using a for loop so the comparisons above can be run by accession
bygroup <- data.frame(Accession = character(), DIAMOND_per = integer(), eggNog_per = integer())

for (i in 1:length(accession_names)) {
  # i <- 1
  selecter <- accession_names[i]
  comparisondiamondaccession <- subset(comparisondiamond, comparisondiamond$Accession == selecter)
  comparisoneggnogaccession <- subset(comparisonegg, comparisonegg$Accession == selecter)
  # comparisondiamondaccession <- comparisondiamond[grep(selecter, comparisondiamond$compvalue)]
  # shared in DIAMOND-byaccession
  DIApercent <- length(comparisondiamondaccession$compvalue[comparisondiamondaccession$compvalue %in% comparisoneggnogaccession$compvalue]) / length(comparisondiamondaccession$compvalue)
  # shared in egg-byaccession
  eggpercent <- length(comparisondiamondaccession$compvalue[comparisondiamondaccession$compvalue %in% comparisoneggnogaccession$compvalue]) / length(comparisoneggnogaccession$compvalue)
  
  bygroup <- bygroup %>% add_row(Accession = selecter, DIAMOND_per = DIApercent, eggNog_per = eggpercent)
}

write.csv(bygroup, file = "03_final_outputs/misc/DIAMONDeggcomp.csv", row.names = FALSE)


compttest <- t.test(comparisondiamond$compvalue, comparisonegg$compvalue)
compttest

#---------------------------plots----------------------------------------
#whenever i did this before, they had me do it with a graph, so why not do one here
groupbox <- bygroup %>%
  select(DIAMOND_per, eggNog_per) %>%
  pivot_longer(everything(), names_to = "variable", values_to = "value") %>%
  ggplot(aes(x=variable,y=value)) +
  geom_boxplot(fill = c("purple","yellow")) + 
  geom_jitter(alpha=0.3, width = 0.1) + 
  ylim(0.80,1) +
  xlab("System") +
  ylab("% similarity")
groupbox

#--------------------------------------------------old stuff, NOT OUTPUT-------------------------------------------
# #test
# frog <- c(1,1,1,1,35,69)
# toad <- c(1,1,1,1,1,2,5,43)
# pond <- frog[frog %in% toad]
# dnop <- toad[toad %in% frog]
# # dopn <- frog[toad %in% frog]


#9oooooooooooooooooooooooooooooooooo54rrrtrgfffff
# write u# write u# write up investigation into DIAMOND_RESULTS.tsv and output a table with some key metrics
# like how many are in both and how many are in only one, maybe scale up to all accessions. 
# prelim to know what our options are when heatmapping
# remember to talk about the excel stuff

#----------------------------------[NOT RUN]combined lists[NOT RUN]------------------------
# we now have two lists with accessions and ko values
# we want one master list per accession and then we want to know
# which are present in the eggnog file for that accession and
# which are present in the diamond file for that accession

# unique_egg <- unique(eggnog_kos[c("accession", "ko_value")])
# unique_diamond <- unique(dires[c("accession", "ko_value")])
# combined <- rbind(unique_egg, unique_diamond )
# combined <- unique(combined[c("accession", "ko_value")])
# combined <- combined[!is.na(combined$accession), ]
# # creating a combined accession and ko column to make it easier to match to combined
# unique_egg$accko <- paste(unique_egg$accession, unique_egg$ko_value, sep = "-")
# unique_diamond$accko <- paste(unique_diamond$accession, unique_diamond$ko_value, sep = "-")
# combined$accko <- paste(combined$accession, combined$ko_value, sep = "-")
#-----------------------------------[NOT RUN]comparison[NOT RUN]--------------------------
# 
# combined$egg <- combined$accko %in% unique_egg$accko
# combined$diamond <- combined$accko %in% unique_diamond$accko
# 
# unique <- combined %>% 
#   group_by(accession) %>% 
#   summarise(
#     tot_rows = n(), 
#     diamond = length(accession[diamond == TRUE]), 
#     egg = length(accession[egg == TRUE]), 
#     diamond_per = diamond / tot_rows,
#     egg_per = egg / tot_rows)
#------------------------------------[ignore]graphing----------------------------
# write.csv(unique, "02_middle-analysis_outputs/CheckM2_20241228/uniquecomp.csv", row.names = FALSE)
#------------------------------------cumulative-------------------------
# *deleted for unknown reasons*