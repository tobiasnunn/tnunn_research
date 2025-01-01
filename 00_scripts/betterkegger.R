#--------------------------------import libraries and setup---------------------
library(optparse)
library(tidyverse)
library(readxl)
library(purrr)
library(ggpubr)
library(data.table)

if (!require("BiocManager"))
  install.packages("BiocManager")
BiocManager::install("MicrobiomeProfiler")
library(MicrobiomeProfiler)
#---------------------------------body-----------------------------------------
# read metadata / excel files <- store just KEGG KO column in dat.l
# stretch: only store only values that arent -
# stretch stretch goal: remove the "ko:" at the point of storing it in data.l (?str_replace_all)
#stretchstrechstrech goal: Kegg kos in a single list, dataframe that has the sample name and then a single ko on each line
metdata <- read_tsv("C:/Users/tobyn/OneDrive/Work/tnunn_research/2024-25 Research/frog bacteria/02 data/dendrobatestinctoriusmetadatafile.tsv")
data.l <- vector(mode = "list", length = length(metdata$mag_id))
mydir <- "C:/Users/tobyn/OneDrive/Work/tnunn_research/2024-25 Research/frog bacteria/02 data/02_frog_files_for_kegg_and_cog/"
myext <- ".xlsx"

# reading in and data sanitisation

for( mag in seq_along(metdata$mag_id) ) {
  intermed <- read_excel(paste0(mydir, metdata$mag_id[mag], myext), skip = 2, col_names = TRUE)
  data.l[[mag]] <- str_replace_all(intermed$KEGG_ko[-which(intermed$KEGG_ko == "-")], "ko:", "")
}
names(data.l) <- metdata$mag_id

#next step, make it a frame
# then flatten out entries with multiple kos

sampleIDtab <- data.table(sample = names(data.l), ko_list = data.l)
sampleIDtab <- sampleIDtab[, .(ko_list=unlist(ko_list)), by=.(sample)]
# then expand where the are multiples in the same row
sampleIDtab <- sampleIDtab %>% separate_longer_delim(c("ko_list"), delim=",")

# unique list of KOs
uniquetab <- data.frame(unique(sampleIDtab$ko_list))
colnames(uniquetab) <- c("KO")

resultsframe <- data.frame(KO = character(), pathway = character())

for (i in 1:nrow(uniquetab)) {
  #i <- 2
  KOval <- uniquetab[i,1]
  KOresult <- enrichKO(KOval, pAdjustMethod = "BH")
  if (!(is.null(KOresult)))
  {
    #add rows to results_df
    #resultsframe <- resultsframe %>% add_row(KO = KOval, pathway = KO@result[which(KO@result$p.adjust < 0.05), ]$ID)
    resultsframe <- resultsframe %>% add_row(KO = KOval, pathway = KOresult@result[which(KOresult@result$p.adjust < 0.05), ]$ID)
  }
}
# currently not working