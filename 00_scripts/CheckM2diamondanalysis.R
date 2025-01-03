library(dplyr)
library(tidyr)
library(tidyverse)
library(gt)
library(readxl)
library(tidyjson)
library(purrr)
# statistical packages
# prob not all used, but i am not sure what does what, so i ported all of them
library(ggplot2)
library(psych)
library(RVAideMemoire)
library(stats)
library(tidyverse)
library(cowplot)
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

#----------------------------------combined lists------------------------
# we now have two lists with accessions and ko values
# we want one master list per accession and then we want to know
# which are present in the eggnog file for that accession and
# which are present in the diamond file for that accession

unique_egg <- unique(eggnog_kos[c("accession", "ko_value")])
unique_diamond <- unique(dires[c("accession", "ko_value")])
combined <- rbind(unique_egg, unique_diamond )
combined <- unique(combined[c("accession", "ko_value")])
combined <- combined[!is.na(combined$accession), ]
# creating a combined accession and ko column to make it easier to match to combined
unique_egg$accko <- paste(unique_egg$accession, unique_egg$ko_value, sep = "-")
unique_diamond$accko <- paste(unique_diamond$accession, unique_diamond$ko_value, sep = "-")
combined$accko <- paste(combined$accession, combined$ko_value, sep = "-")
#-----------------------------------comparison--------------------------

combined$egg <- combined$accko %in% unique_egg$accko
combined$diamond <- combined$accko %in% unique_diamond$accko

unique <- combined %>% 
  group_by(accession) %>% 
  summarise(
    tot_rows = n(), 
    diamond = length(accession[diamond == TRUE]), 
    egg = length(accession[egg == TRUE]), 
    diamond_per = diamond / tot_rows,
    egg_per = egg / tot_rows)
#------------------------------------graphing----------------------------
write.csv(unique, "02_middle-analysis_outputs/CheckM2_20241228/uniquecomp.csv", row.names = FALSE)
#------------------------------------cumulative-------------------------
# two tables, the stuff for the unique values is above
#this section will be for the full table to have a look at most frequent per accession

eggcum <- eggnog_kos[!is.na(eggnog_kos$accession),] %>% 
  group_by(accession, ko_value) %>% 
  summarise(
    tot_rows = n()) %>%
    slice_max(
      order_by = tot_rows,
      n = 5,
      with_ties = FALSE,
      na_rm = TRUE
    )

diacum <- dires[!is.na(dires$accession),] %>% 
  group_by(accession, ko_value) %>% 
  summarise(
    tot_rows = n()) %>%
  slice_max(
    order_by = tot_rows,
    n = 5,
    with_ties = FALSE,
    na_rm = TRUE
  )

cumcomb <- bind_cols(eggcum, diacum)
names(cumcomb) <- c("accession.e", "ko_value.e", "tot_rows.e", "accession.d", "ko_value.d", "tot_rows.d")

write.csv(cumcomb, "02_middle-analysis_outputs/CheckM2_20241228/cumcomb.csv", row.names = FALSE)

#----------------------------------statistical analysis----------------------
# let's start by doing a comparison of the unique percentages, then a wholesale difference analysis
shapiro.test(unique$diamond_per)
shapiro.test(unique$egg_per)
# p1 = 0.6 / p2 = 0.06 - not sig dif from normal (parametric)
# diff btwn groups -> Parametric -> 1 ind var -> two categories -> unpaired -> Variances homogeneous?

# F-test for variance

res <- var.test(unique$diamond_per, unique$egg_per)
res
?var.test
# right, that is a lot, p=0.27
ser <- var.test(unique$egg_per, unique$diamond_per)
ser
# there are differences, im going to assume the first one is right
# what does it mean when p>0.05? why can noone give me a good answer for this?
# ok, im just going to take a guess, if it is like the shapiro then a p>0.05
# meaning they are not significantly different, thus the variances are homogeneous
# in the end i dont think it matters, theres only one function for t.test, oh well

# Student's t-test

ttest <- t.test(unique$diamond_per, unique$egg_per)
# p = 0.14 so they are ...
#he Independent-Samples t Test The null hypothesis is that the means of the two populations are the same: µ1 = µ2
# so we accept the null because p> 0.05 so they are statistically the same, i think

#--------------------------------testing non-unique---------------------------
# due to the nature of the pipeline, i am going to need to do some stuff to
# prepare the data for transformation
cum_egg <- eggnog_kos[c("accession", "ko_value")]
cum_egg <- cum_egg[!is.na(cum_egg$accession), ]
cum_diamond <- dires[c("accession", "ko_value")]
cumbined <- rbind(cum_egg, cum_diamond)
#combined <- unique(combined[c("accession", "ko_value")])
cumbined <- cumbined[!is.na(cumbined$accession), ]
# creating a combined accession and ko column to make it easier to match to combined
cum_egg$accko <- paste(cum_egg$accession, cum_egg$ko_value, sep = "-")
cum_diamond$accko <- paste(cum_diamond$accession, cum_diamond$ko_value, sep = "-")
cumbined$accko <- paste(cumbined$accession, cumbined$ko_value, sep = "-")

cumbined$egg <- cumbined$accko %in% cum_egg$accko
cumbined$diamond <- cumbined$accko %in% cum_diamond$accko

cumulative <- cumbined %>% 
  group_by(accession) %>% 
  summarise(
    tot_rows = n(), 
    diamond = length(accession[diamond == TRUE]), 
    egg = length(accession[egg == TRUE]), 
    diamond_per = diamond / tot_rows,
    egg_per = egg / tot_rows)

# testing
shapiro.test(cumulative$diamond_per)
shapiro.test(cumulative$egg_per)

cumttest <- t.test(cumulative$diamond_per, cumulative$egg_per)
cumttest
# hell, p < 0.05 so they are different

#---------------------------plots----------------------------------------
#whenever i did this before, they had me do it with a graph, so why not do one here
unibox <- unique %>% 
  select(diamond_per, egg_per) %>% 
  pivot_longer(everything(), names_to = "variable", values_to = "value") %>%
  ggplot(aes(x=variable,y=value)) +
  geom_boxplot(fill = c("purple","yellow")) +geom_jitter(alpha=0.3, width = 0.1) + ylim(0.85,1)

cumbox <- cumulative %>% 
  select(diamond_per, egg_per) %>% 
  pivot_longer(everything(), names_to = "variable", values_to = "value") %>%
  ggplot(aes(x=variable,y=value)) +
  geom_boxplot(fill = c("purple","yellow")) +geom_jitter(alpha=0.3, width = 0.1) + ylim(0.85,1)

plot_grid(unibox, cumbox, labels=c("Unique", "Cumulative"), ncol = 2, nrow = 1)

#-------------------------Direct comp of diamond and eggnog--------------
# previous comparisons took place between one of the methods and a 
# "total" list containing KOs from both, but, having built up the code for this
# can i now compare them to each other directly?

comparisondiamond <- data.frame(accko = cum_diamond$accko)
comparisondiamond <- comparisondiamond %>% arrange(accko)
comparisondiamond$index <- comparisondiamond %>% group_by(accko) %>% mutate(id = row_number())
comparisondiamond$index_number <- unlist(comparisondiamond[["index"]][[2]])
comparisondiamond$comparison_value <- paste(comparisondiamond$accko,
                                            comparisondiamond$index_number, sep = "-")
comparisondiamond <- data.frame(compvalue = comparisondiamond$comparison_value)


comparisonegg <- data.frame(accko = cum_egg$accko)
comparisonegg <- comparisonegg %>% arrange(accko)
comparisonegg$index <- comparisonegg %>% group_by(accko) %>% mutate(id = row_number())
comparisonegg$index_number <- unlist(comparisonegg[["index"]][[2]])
comparisonegg$comparison_value <- paste(comparisonegg$accko,
                                            comparisonegg$index_number, sep = "-")
comparisonegg <- data.frame(compvalue = comparisonegg$comparison_value)

length(comparisondiamond$compvalue[comparisondiamond$compvalue %in% comparisonegg$compvalue])
length(comparisondiamond$compvalue)
length(comparisonegg$compvalue)

length(comparisondiamond$compvalue[comparisondiamond$compvalue %in% comparisonegg$compvalue]) / length(comparisondiamond$compvalue)
length(comparisondiamond$compvalue[comparisondiamond$compvalue %in% comparisonegg$compvalue]) / length(comparisonegg$compvalue)

compttest <- t.test(comparisondiamond$compvalue, comparisonegg$compvalue)
compttest
#test
frog <- c(1,1,1,1,35,69)
toad <- c(1,1,1,1,1,2,5,43)
pond <- frog[frog %in% toad]
dnop <- toad[toad %in% frog]
# dopn <- frog[toad %in% frog]


#9oooooooooooooooooooooooooooooooooo54rrrtrgfffff
# write u# write u# write up investigation into DIAMOND_RESULTS.tsv and output a table with some key metrics
# like how many are in both and how many are in only one, maybe scale up to all accessions. 
# prelim to know what our options are when heatmapping
# remember to talk about the excel stuff