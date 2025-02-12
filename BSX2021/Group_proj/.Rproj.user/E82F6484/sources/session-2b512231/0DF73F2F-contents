library(httr2)
library(tidyverse)
library(sf)
library(mapview)
library(gt)
library(jsonlite)

#https://documenter.getpostman.com/view/664302/S1ENwy59

urlstring <- 'https://api.ebird.org/v2/'

#https://api.ebird.org/v2/data/obs/{{regionCode}}/recent

api_key <- 'atica6eedkde'

# req <- request(base_url = urlstring) %>% 
#   #req_auth_bearer_token(api_key) %>%
#   req_url_path_append("data", "obs", "GB-WLS-CWY", "recent") %>%
#   req_headers('X-eBirdApiToken' = api_key) %>%
#   req_headers(Accept = 'application/json') %>%
#   req_perform(path = "2025-02-09_conwy.json")

# resp <- req %>% resp_body_json()
# resp2 <- req %>% resp_body_json()

#recent and nearby
#https://api.ebird.org/v2/data/obs/geo/recent?lat={{lat}}&lng={{lng}}

#Pontio coords
#53.227645, -4.129681

req <- request(base_url = urlstring) %>% 
  req_url_path_append("data", "obs", "geo", "recent") %>%
  req_url_query(lat = 53.227645, lng = -4.129681, dist = 5) %>%
  req_headers('X-eBirdApiToken' = api_key) %>%
  req_headers(Accept = 'application/json') %>%
  req_perform(path = paste0("data/", Sys.Date(), "_nearby.json"))

jsonfiles <- list.files(path = "data/", pattern = "*nearby.json", full.names = TRUE)
# TODO: how get most recent file when there are multiple?

df <- bind_rows(read_json(jsonfiles[1]))

#maps
mapview(df, xcol = "lng", ycol = "lat", crs = 4269, grid = FALSE)

# table of birds
topten <- slice_max(df, order_by = howMany, n = 10)
mindate <- date(min(topten$obsDt))
maxdate <- date(max(topten$obsDt))

topten %>%
  select(comName, sciName, locName, howMany, obsDt) %>%
  gt() %>%
  opt_row_striping() %>% 
  opt_stylize(style = 1, color = "pink")  %>%
  tab_header(
    title = paste("Top 10 bird sightings within 5 Km of Pontio between", mindate, "and", maxdate),
    subtitle = md("by number of birds reported")
  ) %>%
  cols_label(comName = "Common name",
             sciName = "Scientific name",
             locName = "Location name",
             howMany = "Quantity",
             obsDt = "Date/time of observation") %>%
  tab_footnote(
    footnote=paste("Data retrieved from eBird API on", gsub("data//*|*_nearby.json", "", jsonfiles[1])),
    locations = NULL,
    placement = c("auto")
  )

#TODO: bubble map (points big if more bird)
