library(readxl)
library(tidyverse)


rawdata <- (read_xlsx("mydata.xlsx", sheet = "Light Mon PM") %>% 
  filter(!is.na(`Red 0`)) %>% 
  filter(`Group Initials/Team Name` == "condor") %>% 
  select( -c(`...8`, `...15`, `Group Initials/Team Name`)) %>% 
  pivot_longer(!`Crab No.`, names_to = "attribute", values_to = "reading")) %>% 
  separate_wider_delim(cols = "attribute", names = c("pigment", "time"),
                       delim = " ") %>% 
  rename(crab = `Crab No.`) %>% 
  mutate(time = as.numeric(time))

# fun plot
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

# means
means <- rawdata %>%
  group_by(pigment, time) %>%
  summarise(mean_reading = mean(reading))

# mean plot
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


# stats

# parametric or not?
shapiro.test(means$mean_reading) # parametric (p = 0.62)

# next stats
anova <- aov(reading~pigment+time, rawdata)
summary(anova)
# maybe the multi is right? but i think the oneway is what i want to do
apple <- aov(reading~time, rawdata)
apple
# no, still not right
kruskal.test(reading ~ time, data = rawdata)
