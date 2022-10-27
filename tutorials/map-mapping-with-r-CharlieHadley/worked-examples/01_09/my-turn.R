library(tidyverse)
library(readxl)
library(janitor)
library(tidygeocoder)
library(sf)
library(mapview)

uk_addresses <- read_excel("data/street-addresses.xlsx",
                           sheet = "UK Addresses") %>%
  clean_names()


geo("221B Baker Street")

uk_addresses <- uk_addresses %>% 
  geocode(street = street_address,
          city = city,
          postalcode = post_code,
          country = country,
          method = "iq")

uk_addresses %>% 
  st_as_sf(coords = c("long", "lat"), crs = 4326) %>% 
  mapview()
