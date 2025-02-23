# Install required packages if needed
# install.packages(c("terra", "sf"))
library(terra)
library(sf)
library(jsonlite)
library(tidyverse)
library(dplyr)
library(mapview)
library(ggplot2)
library(psych)
library(RVAideMemoire)

bird <- read_json(path = "data/2025-02-17_tit.json", simplifyVector = TRUE)

# Download WorldPop UK 2020 data (100m resolution)
# URL from WorldPop website - this is an example, verify the exact URL
# download.file(
#   "https://data.worldpop.org/GIS/Population/Global_2000_2020/2020/GBR/gbr_ppp_2020.tif",
#   "uk_population_2020.tif",
#   mode = "wb"
# )

# Read the raster
pop_raster <- rast("data/gbr_ppp_2020.tif")


# Convert to spatial points
locations_sf <- st_as_sf(bird, 
                         coords = c("lng", "lat"),
                         crs = 4326)  # WGS84

# Extract population values for all points
pop_values <- terra::extract(pop_raster, locations_sf)

# Combine with original data
results <- cbind(bird, population = pop_values$gbr_ppp_2020)

# Replace NA with 0 for unpopulated areas
results$population <- replace_na(results$population, 0)

print(results)

# Basic summary
summary(results$population)

#------------------------------------final touches--------------------

###post code to filter###
#atm i pull straight from the other doc

# raw map
nofilter <- results

mapview(nofilter, xcol = "lng", ycol = "lat", crs = 4269, grid = FALSE, cex = "howMany")

# one filter
onefilt <- results %>% 
  filter(howMany >= 10)

mapview(onefilt, xcol = "lng", ycol = "lat", crs = 4269, grid = FALSE, cex = "howMany")

# 2 filters
postcode <- results %>%
  filter(population <= 0.5 & howMany >= 10)

mapview(postcode, xcol = "lng", ycol = "lat", crs = 4269, grid = FALSE, cex = "howMany")


#---------------------------------dumbell---------------------------------
# First, load the required libraries


# Example data - replace with your own
data <- data.frame(
  category = c("City control", "Forest control", "Test site A", "Test site B", "Test site C","Test site D",
               "Test site E","Test site F","Test site G","Test site H","Test site I","Test site J"),
  low = c(4000, 4321, 3569, 2908, 3333, 2908, 3534,2888, 3332,2502, 3404,3258),
  high = c(5559, 6000, 5464, 4987, 6969,4987, 7011,5606, 6904,4977, 6894, 7001)
)
# Reverse the order of categories
data$category <- factor(data$category, levels = rev(unique(data$category)))
# Create the plot
ggplot(data) +
  # Add segments (vertical lines)
  geom_segment(aes(x = category, xend = category, 
                   y = low, yend = high),
               color = "#747474",
               linewidth = 2) +
  # Add points for low values
  geom_point(aes(x = category, y = low),
             color = "#215F9A", size = 5) +
  # Add points for high values
  geom_point(aes(x = category, y = high),
             color = "#9CBD7D", size = 5) +
  # Customize the theme
  theme_minimal() +
  # Add labels
  labs(title = "Comparing high and low frequencies in different sites",
       subtitle = "for bird song in Great Tits",
       x = "Test site",
       y = "Frequency (Hz)",
       caption = "figure x - sample data only ... of sites across the UK chosen at random from a 
       list of viable locations... comparing average highest and lowest frequency observed for the 
       Test species in each site across the time being measured for") +
  # Make it vertical
  coord_flip() 

#----------------------------------boxplot------------------------------------------------
# do i need to pivot before it can plot?
box <- read_delim("data/box.csv", delim = ",")

box2 <- box %>% pivot_longer(cols = everything(),names_to = "site")

ggplot(box2) + 
  geom_boxplot(aes(x = site, y = value, alpha = 0.5), fill = "#215F9A") +
  theme_minimal() +
  stat_boxplot(aes(x = site, y = value), geom = "errorbar", width = 0.2)

#-------------------------extra plots-----------------------------
# violin
ggplot(box2, aes(x = site, y = value)) +
  geom_violin(aes(fill = after_stat(density))) +
  scale_fill_viridis_c() +
  geom_boxplot(width = 0.2, fill = "white", alpha = 0.5) +
  theme_minimal() +
  labs(title = "Frequency of song by Site",
       x = "Site",
       y = "Frequency (Hz)",
       fill = "Density") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))
# ridgeline
library(ggridges)
ggplot(box2, aes(x = value, y = site, fill = site)) +
  geom_density_ridges(alpha = 0.6, scale = 0.9) +
  scale_fill_viridis_d() +  # Using viridis discrete color palette
  theme_ridges() +
  labs(title = "Average Highest Frequency by Site",
       x = "Frequency",
       y = "Site") +
  theme(legend.position = "none")  # Remove legend since fill color matches y-axis
#-------------------------stats--------------------------------------
#https://rcompanion.org/rcompanion/d_06.html
library(lattice)

# little weird stacked histogram, i like it
histogram(~ value | site,
          data=box2,
          layout=c(1,7)) #  columns and rows of individual plots

byf.shapiro(value~site, box2)
# right yeah, they all rather wildly differ from a normal distribution because that isnt a parameter i can set in fucking Mockaroo

# so test, para = 1-way ANOVA / non-para = Kruskal-Wallis
# the data here is weird so K-W

#3: Kruskal-Wallis
# again, according to https://www.sthda.com/english/wiki/kruskal-wallis-test-in-r
kruskal.test(value ~ site, data = box2)
# the above link says the Dunn test works for this
#If there are several values to compare, it can be beneficial to have R convert this table to a compact letter display for you.  The cldList function in the rcompanion package can do this.

### Dunn test

library(FSA)

PT = dunnTest(value ~ site,
              data=box2,
              method="bh")    # Can adjust p-values;
# See ?p.adjust for options

PT

PTD = PT$res

library(rcompanion)

cldList(comparison = PTD$Comparison,
        p.value    = PTD$P.adj,
        threshold  = 0.05)

### Order groups by median

Data$Health = factor(Data$Health,
                     levels=c("OAD", "Normal", "Asbestosis"))


# 1: (1 way ANOVA);
anova <- aov(Diametermm~Site, bat_data)
summary(anova)

# post hoc Tukey test
TukeyHSD(anova)