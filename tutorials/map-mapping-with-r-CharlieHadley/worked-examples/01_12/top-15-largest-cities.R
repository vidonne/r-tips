library(tidyverse)
library(sf)
library(mapview)
library(maps)

sf_use_s2(FALSE)

top_15_largest_cities <- world.cities %>% 
  slice_max(pop, n = 15)

cities_sf <- top_15_largest_cities |> 
  st_as_sf(coords = c("long", "lat"),
           crs = 4326)

cities_sf |> 
  mapview()

cities_sf |> 
  st_buffer(10) |> 
  mapview()

cities_sf |> 
  st_is_longlat()

cities_sf |> 
  st_transform(3857) |> 
  st_buffer(1000e3) |> 
  mapview()
