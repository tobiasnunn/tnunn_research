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
  #i <- 3
  log <- tail(read.fwf(flyelog[i], widths = 100), 25)
  cut <- as.data.frame(log[-grep('\\[', log$V1),]) 
  names(cut) <- c("data")
  cut <- as.data.frame(cut[!(is.na(cut$data) | cut$data==""), ])
  names(cut) <- c("data")
  key <- cut[grep(':', cut$data),]
  value <- cut[-grep(':', cut$data),]
  frame <- data.frame(key, value)
  frame$accession <- names[i]
  frame$key <- gsub(":", "", as.character(frame$key))
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
write.csv(final, file = "03_final_outputs/metadata_and_quality_tables/flyelog.csv", row.names = FALSE)
