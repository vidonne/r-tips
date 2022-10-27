library(sf)
library(tidyverse)
library(mapview)
library(gapminder)

gapminder_2007 <- gapminder %>% 
  filter(year == 2007)

africa_sf <- read_sf("data/un-regions/africa.shp")

asia_sf <- read_sf("data/un-regions/asia.shp")

world_sf <- africa_sf %>% 
  bind_rows(asia_sf)

world_sf %>% 
  left_join(gapminder_2007,
            by = c("name" = "country")) %>% 
  mapview(zcol = "pop")
