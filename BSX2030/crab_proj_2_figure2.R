# libraries
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

# setup block
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

# normal graph 

#x <- filter(combinedcycles, combinedcycles$cycle == "normal")
# right, i figured out how to filter it to just the ones on the normal cycle, but i think i need to do the means thing again, because otherwise there are going to be like 100 lines on the thing.
normal_means <- filter(combinedcycles, pigment == "Red") %>%
  group_by(cycle, time) %>%
  summarise(mean_reading = mean(reading, na.rm=TRUE))

normal_graph <- ggplot(normal_means, aes(time, mean_reading, 
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
  scale_x_continuous(breaks=unique(normal_means$time), minor_breaks = NULL) +
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
  geom_label(aes(x = 47, y = 4, label = "RPCH injection"), fill = "#D99594", colour = "black")
normal_graph

# inverse graph
# i really haveant the faintest why this is being so difficult
# she left fucking NAs in the dataset, only 4 of them and only in inverted, wtf
# so i remedied it with the na.rm=TRUE bit, jesus, that was painful
inverted_means <- filter(combinedcycles, pigment == "Black") %>%
  group_by(cycle, time) %>%
  summarise(mean_reading = mean(reading, na.rm=TRUE))



inverse_graph <- ggplot(inverted_means, aes(time, mean_reading, 
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
  scale_x_continuous(breaks=unique(normal_means$time), minor_breaks = NULL) +
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
inverse_graph

# combining
combi <- plot_grid(normal_graph, inverse_graph, labels = c('A', 'B'), label_size = 12)
combi
ggsave("secondgraph.png", plot = combi, units = "cm", height = 10, width = 20)

#stats tables
##for loops
#table making
# normal
p_values_normal <- data.frame(pigment=c("Red", "Red", "Red","Red","Red", 
                                        "Black","Black","Black","Black","Black"), 
                              start_time=c(0,30,50,70,75),
                              end_time=c(30,50,70,75,100),
                              p_value=c(NA),
                              significant=c(NA))
# loop, store result
for (i in 1:nrow(p_values_normal)) {
  #i <- 1
  x <- filter(rawdaynight, time==p_values_normal$start_time[i] & pigment==p_values_normal$pigment[i])
  y <- filter(rawdaynight, time==p_values_normal$end_time[i] & pigment==p_values_normal$pigment[i])
  z <- wilcox.test(x$reading, y$reading, paired = TRUE, correct = FALSE, alternative = "t")
  p_values_normal$p_value[i] <- z$p.value
  if (z$p.value < 0.05) {
    p_values_normal$significant[i] <- c("*")
  }
}

# inverse
p_values_inverse <- data.frame(pigment=c("Red", "Red", "Red","Red","Red", 
                                        "Black","Black","Black","Black","Black"), 
                              start_time=c(0,30,50,70,75),
                              end_time=c(30,50,70,75,100),
                              p_value=c(NA),
                              significant=c(NA))
# loop, store result
for (i in 1:nrow(p_values_inverse)) {
  #i <- 1
  x <- filter(rawnightday, time==p_values_inverse$start_time[i] & pigment==p_values_inverse$pigment[i])
  y <- filter(rawnightday, time==p_values_inverse$end_time[i] & pigment==p_values_inverse$pigment[i])
  z <- wilcox.test(x$reading, y$reading, paired = TRUE, correct = FALSE, alternative = "t")
  p_values_inverse$p_value[i] <- z$p.value
  if (z$p.value < 0.05) {
    p_values_inverse$significant[i] <- c("*")
  }
}
