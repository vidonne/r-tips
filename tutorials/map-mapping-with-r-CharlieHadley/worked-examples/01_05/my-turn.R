library(maps)
library(tidyverse)
library(sf)

bristol_cities <- world.cities %>% 
  filter(name == "Bristol") %>% 
  select(name, lat, long)

interesting_places <- tribble(
  ~name, ~long, ~lat,
  "Black Country Museum", -2.0774153, 52.5201088,
  "Johannesburg", 28.045556, -26.04444
)

interesting_places %>% 
  bind_rows(bristol_cities) %>% 
  st_as_sf(coords = c("long", "lat"), crs = 4326) %>% 
  mapview()
