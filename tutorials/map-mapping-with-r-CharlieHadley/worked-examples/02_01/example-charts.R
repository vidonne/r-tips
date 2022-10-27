library(tidyverse)
library(sf)
library(rnaturalearthdata)

msleep |> 
  ggplot(aes(x = sleep_total,
             y = sleep_rem)) + 
  geom_point(aes(color = vore)) +
  scale_color_brewer(palette = "Dark2")

msleep |> 
  count(vore) |> 
  ggplot(aes(x = n, y = vore)) +
  geom_col()



world_sf <- countries110 %>% 
  st_as_sf()

world_sf |> 
  ggplot() +
  geom_sf(aes(fill = type))

quakes_sf <- quakes %>% 
  st_as_sf(coords = c("long", "lat"),
           crs = 4326)

quakes_sf |> 
  ggplot() +
  geom_sf()

ggplot() +
  geom_sf(data = world_sf,
          aes(fill = type)) +
  geom_sf(data = quakes_sf) +
  theme_minimal()
