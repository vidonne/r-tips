library(maps)
library(tidyverse)
library(sf)
library(rnaturalearthdata)
library(ggrepel)

brazil_cities <- world.cities %>% 
  filter(country.etc == "Brazil",
         pop > 1e6) %>% 
  mutate(capital = as.logical(capital)) %>% 
  arrange(desc(pop))

brazil_cities_sf <- brazil_cities %>% 
  st_as_sf(coords = c("long", "lat"), crs = 4326)

brazil_sf <- countries50 %>% 
  st_as_sf() %>% 
  filter(name == "Brazil")

biggest_smallest_city <- brazil_cities %>% 
  slice(c(1,nrow(.)))

point_max_size <- 15

ggplot() +
  geom_sf(data = brazil_sf) +
  geom_sf(data = brazil_cities_sf,
          aes(fill = capital,
              size = pop),
          shape = 21) +
  geom_label_repel(
    data = biggest_smallest_city,
    aes(x = long,
        y = lat,
        label = name),
    point.size = scales::rescale(biggest_smallest_city$pop, c(1, point_max_size)),
    nudge_y = c(-3, 0),
    nudge_x = c(0, 6)
  ) +
  scale_fill_manual(
    labels = c("TRUE" = "Capital City",
               "FALSE" = "City"),
    values = c("TRUE" = "#ffa600",
               "FALSE" = "#bc5090"),
    name = ""
  ) +
  scale_size_area(
    max_size = point_max_size,
    labels = scales::number_format(suffix = " Million",
                                   scale = 1e-6),
    name = "City size"
  ) +
  theme_void() +
  guides(size = guide_legend(override.aes = list(fill = "#bc5090")),
         fill = guide_legend(override.aes = list(size = 5))) +
  labs(title = "Cities in Brazil with more than 1 Million residents",
       subtitle = "Labels show the smallest and largest cities")
