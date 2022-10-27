library(tidyverse)
library(readxl)
library(janitor)
library(tidygeocoder)
library(sf)
library(mapview)

international_addresses <- read_excel("data/street-addresses.xlsx",
                                      sheet = "International Addresses") %>% 
  clean_names()

int_geocode <- international_addresses |> 
  geocode(street = street_address,
          city = city,
          state = region,
          postalcode = postal_code,
          country = country,
          method = "iq")

int_geocode |> 
  st_as_sf(coords = c("long", "lat"), crs = 4326) |> 
  mapview()
