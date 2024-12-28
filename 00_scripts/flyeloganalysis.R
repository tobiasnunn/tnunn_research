library(dplyr)
library(tidyverse)
library(gt)
#------------------------------create list / name stuff-------------------------------
flyelog <- list.files("02_middle-analysis_outputs/flyestuff", pattern = ".log", full.names = TRUE)
names <- list.files("02_middle-analysis_outputs/flyestuff", pattern = ".log", full.names = FALSE)
names <- sub("_.*", "", names)
#-----------------------------import data / create-------------------------------
final <- data.frame(accession=character(), key=character(), value=numeric())

for (i in 1:length(names)) {
  #read in the log file but keep only the last 25 rows. Remove rows which start with
  #[, are empty or contain NAs
  log <- tail(read.fwf(flyelog[i], widths = 100), 25) %>%
    filter(., !(grepl("\\[", V1) | V1 == "" | is.na(V1)))
  #create a data frame that puts all the values with a : in the first colum, and all the rows
  #without in the second column and add a column with the accession
  frame <- data.frame(accession = names[i], key = log[grep(':', log$V1),], value = log[-grep(':', log$V1),]) 
  #then remove the : from the key column
  frame$key <- gsub(":", "", as.character(frame$key))
  #add this to the final dataframe
  final <- rbind(final, frame)
}

final <- pivot_wider(final, names_from = key, values_from = value )
#-----------------------------tabulate--------------------------------
tablenames <- c("Total length", "Fragments", "Fragments N50", "Largest frg", "Scaffolds", "Mean coverage")
final[tablenames] <- sapply(final[tablenames], as.numeric)
final %>%
  arrange(desc(`Mean coverage`)) %>%
  gt() %>%
  fmt_number(
    columns = tablenames,
    use_seps = TRUE,
    decimals = 0)  %>%
  tab_source_note(source_note = "Source: flye.log files produced in flye_asm analysis, August 27th 2024") %>%
  opt_row_striping() %>%
  opt_stylize(style = 5, color = "blue") %>%
  data_color(
    columns = `Mean coverage`,
    method = "numeric",
    palette = "Purples",
    domain = c(150, 450),
    reverse = FALSE
  ) %>%
  tab_header(
    title = "Table 3 - Data obtained from flye.log outputs",
    subtitle = md("of samples taken from the skin microbiome of *Dendrobates tinctorius*")
  )
