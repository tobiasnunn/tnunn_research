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
#----------------------------------testing-------------------------------------
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

#------------------------------------great tits-------------------------------------
                        ### FIND SPECIES ###  
#need to do an API call for the speciesCode before i can do THE API call
#https://api.ebird.org/v2/ref/taxonomy/ebird

reqname <- request(base_url = urlstring) %>% 
  req_url_path_append("ref", "taxonomy", "ebird") %>%
  req_url_query(fmt = "csv") %>%
  req_headers('X-eBirdApiToken' = api_key) %>%
  req_headers(Accept = 'application/json') %>%
  req_perform(path = paste0("data/", Sys.Date(), "_name.csv"))

namecsv <- list.files(path = "data/", pattern = "*name.csv", full.names = TRUE)

code <- read_delim(file = namecsv, delim = ",") %>% 
  filter(COMMON_NAME == "Great Tit") %>% select(SPECIES_CODE)
# gretit1, but i can prob just pass in code

# TODO: try and get it working for JSON format

                        ### create map ###
#https://api.ebird.org/v2/data/obs/{{regionCode}}/recent/{{speciesCode}}

reqtit <- request(base_url = urlstring) %>% 
  req_url_path_append("data", "obs", "GB", "recent", "gretit1") %>%
  req_url_query(back = 30) %>%
  req_headers('X-eBirdApiToken' = api_key) %>%
  req_headers(Accept = 'application/json') %>%
  req_perform(path = paste0("data/", Sys.Date(), "_tit.json"))

titfiles <- list.files(path = "data/", pattern = "*tit.json", full.names = TRUE)

gretit <- bind_rows(read_json(titfiles[1]))

#maps

mapview(gretit, xcol = "lng", ycol = "lat", crs = 4269, grid = FALSE)

#TODO: SORTED figure out how mapview() works so i dont have to reuse the coords of pontio
# i did do it right :)
#TODO: bubble map (points big if more bird)


                    ### Create hotspot table ###
# doing the table from the info returned there would be challenging, so im going to try use one of the hotspot commands
#https://api.ebird.org/v2/ref/hotspot/{{regionCode}}

hotreq <- request(base_url = urlstring) %>% 
  req_url_path_append("ref", "hotspot", "GB") %>%
  req_url_query(back = 30, fmt = "json") %>%
  req_headers('X-eBirdApiToken' = api_key) %>%
  req_headers(Accept = 'application/json') %>%
  req_perform(path = paste0("data/", Sys.Date(), "_hotspot.json"))

hotfiles <- list.files(path = "data/", pattern = "*hotspot.json", full.names = TRUE)

hotspots <- bind_rows(read_json(hotfiles[1]))
#hmm, i can get *something* from this, though i am not sure what, it can give me codes, latitudes, maybe i can cross-reference
# the two lists? so that i get the hotspots where Great Tits were found then either bubble it or filter it so only the like top
# 30 locations in all the UK are shown on the map, call it the "candidate map" with the "candidate table" or something