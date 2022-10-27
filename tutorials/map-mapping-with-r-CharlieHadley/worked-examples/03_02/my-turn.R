library(maps)
library(sf)
library(rnaturalearthdata)
library(leaflet)
library(tidyverse)
library(leaflet.extras)

germany_sf <- countries50 %>%
  st_as_sf() %>%
  filter(name == "Germany")

germany_cities <- world.cities %>%
  filter(country.etc == "Germany") %>%
  slice_max(pop, n = 5) %>%
  st_as_sf(coords = c("long", "lat"),
           crs = 4326)

# ==== dataviz ====

leaflet() |> 
  addProviderTiles(providers$OpenStreetMap) |> 
  addPolygons(data = germany_sf) |> 
  addCircleMarkers(data = germany_cities)

leaflet() |> 
  setMapWidgetStyle(style = list(background = "cornflowerblue")) |> 
  addPolygons(data = germany_sf,
              fillColor = "forestgreen") |> 
  addCircleMarkers(data = germany_cities,
                   label = ~name,
                   popup = ~as.character(pop))

# !!! need to transform column to character to have it show in the popup
