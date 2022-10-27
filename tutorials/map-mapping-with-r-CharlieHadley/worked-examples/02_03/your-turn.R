library(maps)
library(tidyverse)
library(sf)
library(rnaturalearthdata)
library(ggrepel)

switzerland_sf <- countries50 %>% 
  st_as_sf() %>% 
  filter(name == "Switzerland")

city_df <- world.cities %>% 
  filter(country.etc == "Switzerland") %>% 
  slice_max(pop, n = 10)

city_sf <- city_df |> 
  st_as_sf(coords = c("long", "lat"), crs = 4326)

ggplot() +
  geom_sf(data = switzerland_sf) +
  geom_sf(data = city_sf) +
  geom_text_repel(data = city_df,
                  aes(x = long, y = lat,
                      label = name)) +
  theme_void()
  