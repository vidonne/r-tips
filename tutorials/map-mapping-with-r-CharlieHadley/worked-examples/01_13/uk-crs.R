library(tidyverse)
library(sf)
library(mapview)
library(maps)

uk_cities <- world.cities %>% 
  st_as_sf(coords = c("long", "lat"), crs = 4326) %>% 
  filter(country.etc == "UK") %>% 
  rename(lad20nm = name)

uk_local_authorities <- read_sf("data/uk_local_authorities")

st_crs(uk_local_authorities)

uk_cities <- uk_cities |> 
  st_transform(crs = st_crs(uk_local_authorities))

uk_local_authorities %>% 
  mutate(cities_in_local_authority = lengths(st_covers(uk_local_authorities, uk_cities))) %>% 
  mapview(zcol = "cities_in_local_authority")
