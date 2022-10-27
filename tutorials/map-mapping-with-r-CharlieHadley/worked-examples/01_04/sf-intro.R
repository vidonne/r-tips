library(albersusa)
library(mapview)
library(tidyverse)
library(sf)

us_counties <- counties_sf("laea")

us_counties$geometry

us_counties %>% 
  mapview()

us_counties %>% 
  select(name, lsad)

us_counties %>% 
  st_drop_geometry()

starwards %>% 
  count(homeworld)


us_counties %>% 
  count(lsad) %>% 
  mapview()

us_counties %>% 
  filter(lsad == "County")