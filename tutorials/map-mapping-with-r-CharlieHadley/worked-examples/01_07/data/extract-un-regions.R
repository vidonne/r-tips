library(rnaturalearthdata)
library(sf)

countries_sf <- countries110 %>% 
  st_as_sf()

dir.create("data/un-regions")

countries_sf %>% 
  filter(region_un == "Africa") %>% 
  select(name, name_long, region_un) %>% 
  write_sf("data/un-regions/africa.shp")

countries_sf %>% 
  filter(region_un == "Asia") %>% 
  select(name, name_long, region_un) %>% 
  write_sf("data/un-regions/asia.shp")
