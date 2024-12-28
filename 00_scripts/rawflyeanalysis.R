library(dplyr)
library(tidyverse)
library(gt)
#------------------------------create list-------------------------------
flyeout <- list.files("02_middle-analysis_outputs/flyestuff", pattern = ".txt", full.names = TRUE)
flyeframe <- lapply(flyeout, read.delim)
names <- list.files("02_middle-analysis_outputs/flyestuff", pattern = ".txt", full.names = FALSE)
names <- sub("_.*", "", names)
names(flyeframe) <- names
#------------------------------create table------------------------------
flyetable <- bind_rows(flyeframe, .id = "accession")
processedtable <- flyetable %>%
  group_by(accession) %>%
  summarise(number_of_contigs = n(), 
            total_length = sum(length, na.rm = TRUE),
            largest_fragment = max(length),
            mean_fragments = mean(length))
# i couldnt get a value of coverage that matched the flye.log file, i dont know how
# its colculated, so i excluded it for now
#--------------------------------styling-------------------------------
processedtable %>%
  arrange(desc(number_of_contigs)) %>%
  gt() %>%
  fmt_number(
    columns = c(number_of_contigs, total_length, largest_fragment),
    use_seps = TRUE,
    drop_trailing_zeros = TRUE) %>%
  fmt_number(
    columns = c(mean_fragments),
    decimals = 2,
    use_seps = TRUE) %>%
  tab_source_note(source_note = "Source: assembly_info.txt files produced in flye_asm analysis, August 27th 2024") %>%
  opt_row_striping() %>%
  opt_stylize(style = 5, color = "blue") %>%
  data_color(
    columns = number_of_contigs,
    method = "numeric",
    palette = "Purples",
    domain = c(0, 200),
    reverse = FALSE
  ) %>%
  tab_header(
    title = "Table 2 - Data obtained from flye outputs",
    subtitle = md("of samples taken from the skin microbiome of *Dendrobates tinctorius*")
  ) %>%
  tab_footnote(
    footnote = md("coverage could not be calculated from this method as no result matched what was found in the *flye.log* files")
  ) %>%
  cols_label(accession = "Accession",
             number_of_contigs = "Number of contigs",
             total_length = "Total length",
             largest_fragment = "Largest fragment",
             mean_fragments = "Mean fragments")
