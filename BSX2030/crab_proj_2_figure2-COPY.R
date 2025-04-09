# libraries and setup-----------------------------------------------------


library(dplyr)
library(tidyr)
library(flextable)
library(equatags)
library(officer)
library(readxl)
library(tidyverse)
library(ggplot2)
library(gt)
library(cowplot)


rawdaynight <- (readxl::read_xlsx("lightvsdark.xlsx", sheet = 1) %>% 
                  select( -c(`...8`)) %>% 
                  pivot_longer(!`Crab No.`, names_to = "attribute", values_to = "reading")) %>% 
  separate_wider_delim(cols = "attribute", names = c("pigment", "time"),
                       delim = " ") %>% 
  rename(crab = `Crab No.`) %>% 
  mutate(crab = paste0("N", crab)) %>% 
  mutate(time = as.numeric(time)) %>% 
  mutate(cycle = "normal")

rawnightday <- (readxl::read_xlsx("lightvsdark.xlsx", sheet = 2) %>% 
                  select( -c(`...8`)) %>% 
                  pivot_longer(!`Crab No.`, names_to = "attribute", values_to = "reading")) %>% 
  separate_wider_delim(cols = "attribute", names = c("pigment", "time"),
                       delim = " ") %>% 
  rename(crab = `Crab No.`) %>% 
  mutate(crab = paste0("I", crab)) %>% 
  mutate(time = as.numeric(time)) %>% 
  mutate(cycle = "inverse")

combinedcycles <- rbind(rawdaynight, rawnightday)

rm(rawdaynight)
rm(rawnightday)

#------------------------------------stats tables------------------------------------


## p_values table creation-------------------------------------------------


pigment <- data.frame(pigment = c("Red", "Black"))
cycle <- data.frame(cycle = c("normal", "inverse"))

p_values <- data.frame(
  start_time=c(0,30,50,70,75,30,70),
  end_time=c(30,50,70,75,100,70,100),
  p_value=c(NA),
  significant=c(NA)) %>% 
  cross_join(cycle)  %>%
  cross_join(pigment) %>% 
  arrange(pigment, cycle, start_time, end_time) %>% 
  select(pigment, cycle, start_time, end_time, p_value, significant)

## for loop with wilcoxon--------------------------------------------------


for (i in 1:nrow(p_values)) {
  #i <- 1
  x <- filter(combinedcycles,
              time==p_values$start_time[i] & 
                cycle==p_values$cycle[i] & 
                pigment==p_values$pigment[i])
  
  y <- filter(combinedcycles, 
              time==p_values$end_time[i] & 
                cycle==p_values$cycle[i] & 
                pigment==p_values$pigment[i])
  
  z <- wilcox.test(x$reading, 
                   y$reading, 
                   paired = TRUE, 
                   correct = FALSE, 
                   alternative = "t")
  
  p_values$p_value[i] <- z$p.value
  if (z$p.value < 0.05) {
    p_values$significant[i] <- "*"
  }
}


## table design ------------------------------------------------------------


### data transformation-----------------------------------------------------


p_ivot_values <- select(p_values, -significant) %>% 
  unite("time_diff", start_time:end_time, sep = " - ") %>% 
  pivot_wider(names_from = time_diff, values_from = p_value)

rm(cycle, pigment, p_values)
#### scientific notation -----------------------------------------------------

 
# needed claude for this bit, very complecated thing to do, need to get better
# so i can do this alone

# Get the names of all numeric columns
numeric_cols <- names(p_ivot_values)[sapply(p_ivot_values, is.numeric)]

# Create a named list for formatting
format_list <- setNames(
  replicate(length(numeric_cols), 
            function(x) formatC(x, format = "e", digits = 3), 
            simplify = FALSE),
  numeric_cols
)

# also needed help to colour cells grey, heres the funct for that
# Create a function that will color cells based on their values
color_if_greater <- function(x) {
  ifelse(as.numeric(x) > 0.05, "grey70", "black")
}
### table styling---------------------------------------------------------------


p_table <- flextable(p_ivot_values) %>% 
  set_header_labels(pigment = "Pigment",
                    cycle = "Cycle") %>% 
  theme_vanilla() %>% 
  add_footer_lines("Data collected on 2025-03-10 at Deiniol Road, Brambell Building, 1st Floor Lab B1") %>% 
  color(part = "footer", color = "#666666") %>% 
  set_caption(caption = "P values for Wilcoxon Paired Rank Test") %>% 
  add_header_row(colwidths = c(2, 7),
                 values = c("", "P values for start time - end time (mins from primary injection)")) %>% 
  align(i = 1, j = 3, 
        align = "center", 
        part = c("header")) %>%  
  set_table_properties(width = 1, 
                       layout = "autofit") %>% 
  set_formatter(values = format_list) %>%
  footnote(i = 1, j = 2,
           part = "header",
           ref_symbols = "*",
           value = as_paragraph("P values taken between pairs of times when measurements were taken for a Wilcoxon Paired Rank Test")) %>% 
  # Apply to all numeric columns
  color(
    color = color_if_greater,
    part = "body",
    j = numeric_cols
  )
p_table
# also needed clauds help for the grey text

### table styling CONDOR---------------------------------------------------------------

rawdata <- (read_xlsx("PDH Prac Chromatophore Data 2025.xlsx", sheet = "Light Mon PM") %>% 
              filter(!is.na(`Red 0`)) %>% 
              filter(`Group Initials/Team Name` == "condor") %>% 
              select( -c(`...8`, `...15`, `Group Initials/Team Name`)) %>% 
              pivot_longer(!`Crab No.`, names_to = "attribute", values_to = "reading")) %>% 
  separate_wider_delim(cols = "attribute", names = c("pigment", "time"),
                       delim = " ") %>% 
  rename(crab = `Crab No.`) %>% 
  mutate(time = as.numeric(time))


# fun plot ----------------------------------------------------------------


crab <- ggplot(rawdata, aes(time, reading, color = factor(pigment),
                            fill = factor(pigment))) +
  geom_line(lwd = 1, alpha = 0.8) +
  geom_point(size=2, aes(shape = factor(pigment))) +
  theme_light() +
  xlab("time (minutes)") +
  ylab("Chromatophore stage") +
  labs(fill = "Colour", colour = "Colour", shape = "Colour") +
  scale_colour_manual(values = c("grey27", "firebrick1")) +
  scale_fill_manual(values = c("black", "red3")) +
  facet_wrap(~crab)
crab



# stats table------------------------------------


## p_values table creation-------------------------------------------------


pigment <- data.frame(pigment = c("Red", "Black"))
#cycle <- data.frame(cycle = c("normal", "inverse"))

p_values_condor <- data.frame(
  start_time=c(0,30,50,70,75,30,70),
  end_time=c(30,50,70,75,100,70,100),
  p_value=c(NA),
  significant=c(NA)) %>% 
  #cross_join(cycle)  %>%
  cross_join(pigment) %>% 
  arrange(pigment, start_time, end_time) %>% 
  select(pigment, start_time, end_time, p_value, significant)
# if including cycle, that needs to be added in the arrange and select

## for loop with wilcoxon--------------------------------------------------


for (i in 1:nrow(p_values_condor)) {
  #i <- 1
  x <- filter(rawdata,
              time==p_values_condor$start_time[i] & 
                #cycle==p_values_condor$cycle[i] & 
                pigment==p_values_condor$pigment[i])
  
  y <- filter(rawdata, 
              time==p_values_condor$end_time[i] & 
                #cycle==p_values_condor$cycle[i] & 
                pigment==p_values_condor$pigment[i])
  
  z <- wilcox.test(x$reading, 
                   y$reading, 
                   paired = TRUE, 
                   correct = FALSE, 
                   alternative = "t")
  
  p_values_condor$p_value[i] <- z$p.value
  if (z$p.value < 0.05) {
    p_values_condor$significant[i] <- "*"
  }
}


## table design ------------------------------------------------------------


### data transformation-----------------------------------------------------


p_ivot_values_condor <- select(p_values_condor, -significant) %>% 
  unite("time_diff", start_time:end_time, sep = " - ") %>% 
  pivot_wider(names_from = time_diff, values_from = p_value)

rm(x,y,z,rawdata, pigment, p_values_condor)
# tabling -----------------------------------------------------------------


## functionising -----------------------------------------------------------


crab_flextable <- function(x) {
  # lists of column types for formatting
  numeric_cols <- names(x)[sapply(x, is.numeric)]
  text_cols <- names(x)[sapply(x, is.character)]
  # formatting function
  format_list <- setNames(
    replicate(length(numeric_cols), 
              function(x) formatC(x, format = "e", digits = 3), 
              simplify = FALSE),
    numeric_cols
  )
  # crude way of making the first letter capital in text headers
  x <- x %>% rename_with(str_to_title)
  # cell colour function
  color_if_greater <- function(x) {
    ifelse(as.numeric(x) > 0.05, "grey70", "black")
  }
  # the table itself
  flextable(x) %>% 
    theme_vanilla() %>% 
    #footer stuff
    add_footer_lines("Data collected on 2025-03-10 at Deiniol Road, Brambell Building, 1st Floor Lab B1") %>% 
    color(part = "footer", color = "#666666") %>% 
    # caption that for some reason wont load into word
    set_caption(caption = paste("P values for Wilcoxon Paired Rank Test ",  length(numeric_cols), " ", length(text_cols))) %>% 
    # header stuff
    add_header_row(colwidths = c(length(text_cols), length(numeric_cols)),
                   values = c("", "P values for start time - end time (mins from primary injection)")) %>% 
    align(i = 1, j = length(text_cols)+1, 
          align = "center", 
          part = c("header")) %>% 
    # good formatting for transfer to word
    set_table_properties(width = 1, 
                         layout = "autofit") %>% 
    # making the numbers scientific notation
    set_formatter(values = format_list) %>%
    # footnote
    footnote(i = 1, j = 2,
             part = "header",
             ref_symbols = "*",
             value = as_paragraph("P values taken between pairs of times when measurements were taken for a Wilcoxon Paired Rank Test")) %>% 
    # Apply to all numeric columns
    color(
      color = color_if_greater,
      part = "body",
      j = numeric_cols
    )
}

p_table_condor <- crab_flextable(p_ivot_values_condor)
p_table_condor

p_table <- crab_flextable(p_ivot_values)
p_table


p_table_condor <- flextable(p_ivot_values_condor) %>% 
  set_header_labels(pigment = "Pigment") %>% 
  theme_vanilla() %>% 
  add_footer_lines("Data collected on 2025-03-10 at Deiniol Road, Brambell Building, 1st Floor Lab B1") %>% 
  color(part = "footer", color = "#666666") %>% 
  set_caption(caption = "P values for Wilcoxon Paired Rank Test") %>% 
  add_header_row(colwidths = c(2, 6),
                 values = c("", "P values for start time - end time (mins from primary injection)")) %>% 
  align(i = 1, j = 3, 
        align = "center", 
        part = c("header")) %>%  
  set_table_properties(width = 1, 
                       layout = "autofit") %>% 
  set_formatter(values = format_list) %>%
  footnote(i = 1, j = 2,
           part = "header",
           ref_symbols = "*",
           value = as_paragraph("P values taken between pairs of times when measurements were taken for a Wilcoxon Paired Rank Test")) %>% 
  # Apply to all numeric columns
  color(
    color = color_if_greater,
    part = "body",
    j = numeric_cols
  )
p_table_condor
# also needed clauds help for the grey text

# a lesson on NAs -----------------------------------------------


# how i figured out the problem with the inverse values, it was the random-ass NAs she didnt remove
# despite the fact thats what she said she did
# red_means <- filter(combinedcycles, combinedcycles$cycle == "normal") %>%
#   group_by(pigment, time) %>%
#   summarise(mean_reading = mean(reading))
# 
# black_means <- filter(combinedcycles, combinedcycles$cycle == "inverse") %>% 
#   group_by(pigment, time) %>% 
#   mutate(mean_reading = mean(reading))
# 
# black_means <- filter(combinedcycles, combinedcycles$cycle == "inverse") %>% 
#   group_by(pigment, time) %>%
#   summarise(mean_reading = mean(reading, na.rm = TRUE))
