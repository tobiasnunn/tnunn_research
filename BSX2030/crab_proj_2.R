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
  ylab("Mean chromatophore stage") +
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
meancrab <- ggplot(means, aes(time, mean_reading, color = factor(pigment),
                            fill = factor(pigment))) +
  geom_line(lwd = 1, alpha = 0.8) +
  geom_point(size=2, aes(shape = factor(pigment))) +
  theme_light() +
  xlab("time (minutes)") +
  ylab("Mean chromatophore stage") +
  labs(fill = "Colour", colour = "Colour", shape = "Colour") +
  scale_colour_manual(values = c("grey27", "firebrick1")) +
  scale_fill_manual(values = c("black", "red3")) +
  ylim(1,6) + 
  annotate(
    geom = "curve", x = 37, y = 5.8, xend = 50, yend = 5.1, 
    curvature = -.3, arrow = arrow(length = unit(2, "mm"))
  ) +
  annotate(geom = "text", x = 20, y = 5.8, label = "__ injection",
           hjust = "left")
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
