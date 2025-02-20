# Install required packages if needed
# install.packages(c("terra", "sf"))
library(terra)
library(sf)
library(jsonlite)


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
postcode <- results %>% 
  filter(population <= 0.5 & howMany >= 10)

postcode$bazinga <- postcode$howMany/10

mapview(postcode, xcol = "lng", ycol = "lat", crs = 4269, grid = FALSE, cex = "bazinga")

