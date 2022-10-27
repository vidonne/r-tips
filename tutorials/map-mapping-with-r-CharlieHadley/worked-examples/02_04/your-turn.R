library(tidyverse)
library(sf)
library(tigris)
library(rmapshaper)
library(janitor)

us_airport_passengers <- read_csv("data/us-airport-passenger-numbers_2019.csv")

us_airport_passengers_2019 <- us_airport_passengers %>% 
  filter(year == 2019) %>% 
  st_as_sf(coords = c("long", "lat"), crs = 4326) |> 
  arrange(desc(total_passengers))

us_contiguous_sf <- states() %>% 
  clean_names() %>% 
  mutate(statefp = as.numeric(statefp)) %>% 
  filter(statefp < 60,
         !statefp %in% c(2, 15)) %>% 
  ms_simplify()


ggplot() +
  geom_sf(data = us_contiguous_sf) +
  geom_sf(data = us_airport_passengers_2019,
          aes(size = total_passengers),
          alpha = 0.7,
          pch = 21, fill = "#0072bc", color = "white")
          
# ==== let's go a bit further ====

airport_passenger_extremes <- us_airport_passengers_2019 %>% 
  slice(c(1, nrow(.)))

airport_passenger_extremes_coords <- st_coordinates(airport_passenger_extremes) %>% 
  as_tibble() %>% 
  rename(long = X,
         lat = Y)

airport_passenger_extremes <- airport_passenger_extremes %>% 
  st_drop_geometry() %>% 
  bind_cols(airport_passenger_extremes_coords)

ggplot() +
  geom_sf(data = us_contiguous_sf) +
  geom_sf(data = us_airport_passengers_2019,
          aes(size = total_passengers),
          pch = 21,
          alpha = 0.7,
          fill = "grey70") +
  geom_label_repel(data = airport_passenger_extremes,
                   aes(x = long,
                       y = lat,
                       label = airport),
                   nudge_y = c(-2, 2)) +
  scale_size_area(max_size = 10) +
  theme_void() +
  theme(legend.position = "bottom")