library(tidyverse)
library(sf)
library(mapview)
library(rnaturalearthdata)

oceania_sf <- countries110 %>% 
  st_as_sf() %>% 
  filter(continent == "Oceania")


quakes_geo_proj <- quakes %>% 
  st_as_sf(coords = c("long", "lat"), crs = 4326)




# ==== ggplot2 ====

ggplot() +
  geom_sf(data = st_transform(oceania_sf, crs = crs_quakes)) +
  geom_sf(data = quakes_projected) +
  coord_sf(crs = crs_quakes)


