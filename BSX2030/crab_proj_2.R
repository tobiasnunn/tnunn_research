
# libraries and setup -----------------------------------------------------


library(readxl)
library(tidyverse)

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


# means -------------------------------------------------------------------


means <- rawdata %>%
  group_by(pigment, time) %>%
  summarise(mean_reading = mean(reading))


## plotting the means ------------------------------------------------------


meancrab <- ggplot(means, aes(time, mean_reading, 
                              color = factor(pigment), 
                              fill = factor(pigment))) +
  geom_line(lwd = 1, alpha = 0.8) +
  geom_point(size=2, aes(shape = factor(pigment))) +
  theme_light() +
  xlab("time (minutes)") +
  ylab("Mean chromatophore stage") +
  labs(fill = "Colour", colour = "Colour", shape = "Colour") +
  scale_colour_manual(values = c("grey27", "firebrick1")) +
  scale_fill_manual(values = c("black", "red3")) +
  scale_x_continuous(breaks=unique(means$time), minor_breaks = NULL) +
  # claude-made
  scale_y_continuous(
    limits = c(1, 6),   # Use limits here instead of ylim()
    breaks = 1:6,       # Create breaks at integers 1 through 6
    minor_breaks = NULL # Remove default minor breaks if any
  ) +
  theme(
    panel.grid.major.y = element_line(color = "gray80"),  # Horizontal major gridlines
    panel.grid.minor.y = element_blank()                 # No minor gridlines
    ) +
  # redo prev bit
  # saline annotation
  annotate(
    geom = "curve", x = 12.5, y = 5, xend = 0, yend = 4.1, 
    curvature = .3, arrow = arrow(length = unit(2, "mm"))
  ) + 
  annotate(geom = "rect", xmin = 12.5, xmax = 26.3, ymin = 4.88, ymax = 5.1,
           alpha = .7, colour = "grey60", fill = "#FFFD78") +
  annotate(geom = "text", x = 13.5, y = 5, label = "Saline injection",
            hjust = "left") + 
  # PDH annotation
   annotate(
     geom = "curve", x = 19, y = 2, xend = 30, yend = 2.9, 
     curvature = .3, arrow = arrow(length = unit(2, "mm"))
   )  + 
  annotate(geom = "rect", xmin = 6.3, xmax = 19, ymin = 1.88, ymax = 2.1,
           alpha = .7, colour = "grey40", fill = "#A6C9EC") +
   annotate(geom = "text", x = 18, y = 2, label = "PDH injection",
            hjust = "right") +
  # RPCH annotation
   annotate(
     geom = "curve", x = 58, y = 3, xend = 70, yend = 4.2, 
     curvature = .3, arrow = arrow(length = unit(2, "mm"))
   ) + 
  annotate(geom = "rect", xmin = 44, xmax = 58, ymin = 2.88, ymax = 3.1,
           alpha = .7, colour = "grey20", fill = "#D99594") +
   annotate(geom = "text", x = 57, y = 3, label = "RPCH injection",
            hjust = "right")
meancrab

# img output
ggsave("firstgraph.png", plot = meancrab, units = "cm", height = 10, width = 14)

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

#### scientific notation -----------------------------------------------------


# needed claude for this bit, very complecated thing to do, need to get better
# so i can do this alone

# Get the names of all numeric columns
numeric_cols <- names(p_ivot_values_condor)[sapply(p_ivot_values_condor, is.numeric)]

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
