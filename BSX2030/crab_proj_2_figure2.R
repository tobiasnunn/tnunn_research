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

#--------------------------red graph-----------------------------


# NOTE: the asterisks were put on using the data from the stats area after the fact

#x <- filter(combinedcycles, combinedcycles$cycle == "normal")
# right, i figured out how to filter it to just the ones on the normal cycle, but i think i need to do the means thing again, because otherwise there are going to be like 100 lines on the thing.
red_means <- filter(combinedcycles, pigment == "Red") %>%
  group_by(cycle, time) %>%
  summarise(mean_reading = mean(reading, na.rm=TRUE))

red_graph <- ggplot(red_means, aes(time, mean_reading, 
                                         color = factor(cycle), 
                                         fill = factor(cycle),
                                         linetype = factor(cycle))) +
  geom_line(lwd = 1, alpha = 0.8) +
  geom_point(size=2, aes(shape = factor(cycle))) +
  theme_light() +
  xlab("time (minutes)") +
  ylab("Mean chromatophore stage") +
  labs(fill = "Cycle", colour = "Cycle", shape = "Cycle", linetype = "Cycle") +
  scale_colour_manual(values = c("firebrick1", "firebrick1")) +
  scale_fill_manual(values = c("red3", "red3")) +
  scale_linetype_manual(values = c("inverse" = "dotted", "normal" = "solid")) +
  scale_x_continuous(breaks=unique(red_means$time), minor_breaks = NULL) +
  # claude-made
  scale_y_continuous(
    limits = c(1, 5),   # Use limits here instead of ylim()
    breaks = 1:5,       # Create breaks at integers 1 through 6
    minor_breaks = NULL # Remove default minor breaks if any
  ) +
  theme(
    panel.grid.major.y = element_line(color = "gray80"),  # Horizontal major gridlines
    panel.grid.minor.y = element_blank()                 # No minor gridlines
  ) +
  # redo prev bit
  # saline annotation
  annotate(
    geom = "curve", x = 15, y = 3.2, xend = 0, yend = 2.3, 
    curvature = .3, arrow = arrow(length = unit(2, "mm"))
  )  + 
  geom_label(aes(x = 25, y = 3.2, label = "Saline injection"), fill = "#FFFD78", colour = "black") +
  # PDH annotation
  annotate(
    geom = "curve", x = 50, y = 1.5, xend = 30, yend = 2.2, 
    curvature = -.3, arrow = arrow(length = unit(2, "mm"))
  ) + 
  geom_label(aes(x = 58, y = 1.5, label = "PDH injection"), fill = "#A6C9EC", colour = "black") +
  # RPCH annotation
  annotate(
    geom = "curve", x = 58, y = 4, xend = 70, yend = 3.2, 
    curvature = -.3, arrow = arrow(length = unit(2, "mm"))
  ) + 
  geom_label(aes(x = 47, y = 4, label = "RPCH injection"), fill = "#D99594", colour = "black") +
  # asterisking for stat significance
  annotate(geom = "text", x = 30, y = 2.5, label = "*",
           hjust = "center", size = 7) +
  annotate(geom = "text", x = 50, y = 2.9, label = "**",
           hjust = "center", size = 7) +
  annotate(geom = "text", x = 70, y = 3.12, label = "***",
           hjust = "center", size = 7) +
  annotate(geom = "text", x = 75, y = 2.08, label = "****",
           hjust = "center", size = 7) + 
  annotate(geom = "text", x = 100, y = 2, label = "****",
           hjust = "center", size = 7) +
  annotate(geom = "text", x = 30, y = 2.42, label = "a",
           hjust = "center", size = 4) +
  annotate(geom = "text", x = 70, y = 2.9, label = "b",
           hjust = "center", size = 4) +
  annotate(geom = "text", x = 75, y = 2.62, label = "c",
           hjust = "center", size = 4) +
  annotate(geom = "text", x = 100, y = 2.32, label = "c",
           hjust = "center", size = 4)
red_graph

rm(red_means)
#--------------------------black graph---------------------------------------
# i really haveant the faintest why this is being so difficult
# she left fucking NAs in the dataset, only 4 of them and only in inverted, wtf
# so i remedied it with the na.rm=TRUE bit, jesus, that was painful
black_means <- filter(combinedcycles, pigment == "Black") %>%
  group_by(cycle, time) %>%
  summarise(mean_reading = mean(reading, na.rm=TRUE))



black_graph <- ggplot(black_means, aes(time, mean_reading, 
                                            color = factor(cycle), 
                                            fill = factor(cycle),
                                            linetype = factor(cycle))) +
  geom_line(lwd = 1, alpha = 0.8) +
  geom_point(size=2, aes(shape = factor(cycle))) +
  theme_light() +
  xlab("time (minutes)") +
  ylab("Mean chromatophore stage") +
  labs(fill = "Cycle", colour = "Cycle", shape = "Cycle", linetype = "Cycle") +
  scale_colour_manual(values = c("grey27", "grey27")) +
  scale_fill_manual(values = c("black", "black")) +
  scale_linetype_manual(values = c("inverse" = "dotted", "normal" = "solid")) +
  scale_x_continuous(breaks=unique(black_means$time), minor_breaks = NULL) +
  # claude-made
  scale_y_continuous(
    limits = c(1, 5),   # Use limits here instead of ylim()
    breaks = 1:5,       # Create breaks at integers 1 through 6
    minor_breaks = NULL # Remove default minor breaks if any
  ) +
  theme(
    panel.grid.major.y = element_line(color = "gray80"),  # Horizontal major gridlines
    panel.grid.minor.y = element_blank()                 # No minor gridlines
  ) +
  # redo prev bit
  # saline annotation
  annotate(
    geom = "curve", x = 11, y = 4.5, xend = 0, yend = 4, 
    curvature = .3, arrow = arrow(length = unit(2, "mm"))
  )  + 
  geom_label(aes(x = 21, y = 4.5, label = "Saline injection"), fill = "#FFFD78", colour = "black") +
  # PDH annotation
  annotate(
    geom = "curve", x = 44, y = 2.5, xend = 30, yend = 2.9, 
    curvature = -.3, arrow = arrow(length = unit(2, "mm"))
  ) + 
  geom_label(aes(x = 52, y = 2.5, label = "PDH injection"), fill = "#A6C9EC", colour = "black") +
  # RPCH annotation
  annotate(
    geom = "curve", x = 58, y = 4.8, xend = 70, yend = 4, 
    curvature = -.3, arrow = arrow(length = unit(2, "mm"))
  ) + 
  geom_label(aes(x = 47, y = 4.8, label = "RPCH injection"), fill = "#D99594", colour = "black")
black_graph

rm(black_means)

## cowplot-ing-------------------------------------------------------------


combi <- plot_grid(red_graph, black_graph, labels = c('A', 'B'), label_size = 12)
combi
ggsave("secondgraph.png", plot = combi, units = "cm", height = 10, width = 20)

rm(black_graph)
rm(red_graph)
rm(combi)

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
