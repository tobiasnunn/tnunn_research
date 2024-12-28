library(dplyr)
library(tidyr)
library(tidyverse)
library(gt)
#------------------------import tsv------------------------------
checkm <- read.delim("02_middle-analysis_outputs/CheckM/storage/bin_stats_ext.tsv", header = FALSE)
colnames(checkm) <- c("accession", "checkmdata")
#------------------------cleaning data------------------------
checkm[] <- lapply(checkm, function(x) gsub("\\{|'|#|, 'GCN0.*|flye_asm_|_part2", "", x))
#-------------------------cutting out unwanted stuff---------------------
checkm <- checkm %>%
  separate_rows(checkmdata, sep = ",") %>%
  separate_wider_delim(cols = checkmdata, delim = ":", names = c("key", "value")) %>%
  mutate(across(where(is.character), str_trim)) %>%
  pivot_wider(names_from = key, values_from = value)
checkm <- transform(checkm, 
                    Completeness = as.numeric(Completeness), 
                    Contamination = as.numeric(Contamination),
                    GC = as.numeric(GC),
                     `GC std` = as.numeric(`GC std`),
                     `Genome size` = as.numeric(`Genome size`),
                    contigs = as.numeric(contigs),
                    `Coding density` = as.numeric(`Coding density`),
                    `predicted genes` = as.numeric(`predicted genes`),
                    `Longest contig` = as.numeric(`Longest contig`)
                    )
#--------------------------table creation------------------------------
columnnames <- c("accession", "marker lineage","Completeness", "Contamination","GC","GC std", "Genome size", "contigs", "Longest contig", "Coding density", "predicted genes")
checkm[columnnames] %>%
  arrange(desc(Completeness)) %>%
  gt() %>%
  fmt_number(
    columns = c(Completeness, Contamination, `Coding density`),
    decimals = 2,
    use_seps = TRUE) %>%
  fmt_percent(
    columns = c(GC, `GC std`, `Coding density`),
    decimals = 3,
    use_seps = TRUE) %>%
  fmt_number(
    columns = c(`Genome size`, `predicted genes`, `Longest contig`),
    decimals = 0,
    use_seps = TRUE) %>%
  tab_source_note(source_note = "Source: CheckM lineage_wf performed on 2024-12-25") %>%
  opt_row_striping() %>%
  opt_stylize(style = 5, color = "blue") %>%
  data_color(
    columns = Completeness,
    method = "numeric",
    palette = "Purples",
    domain = c(90, 100),
    reverse = FALSE
  ) %>%
  tab_header(
    title = "Table 1 - subset of data obtained from CheckM analysis",
    subtitle = md("of samples taken from the skin microbiome of *Dendrobates tinctorius*, including metrics of quality.")
  )
