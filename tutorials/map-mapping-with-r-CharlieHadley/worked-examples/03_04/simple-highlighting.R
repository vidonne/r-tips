library(tigris)
library(sf)
library(janitor)
library(rmapshaper)
library(leaflet)
library(leaflet.extras)
library(tidyverse)

us_states <- states(resolution = "500k") %>% 
  clean_names() %>% 
  mutate(statefp = as.numeric(statefp))

us_contiguous <- us_states %>% 
  filter(statefp < 60,
         !statefp %in% c(2, 15)) %>% 
  ms_simplify()

texas_state <- us_contiguous %>% 
  filter(name == "Texas")

# ==== Data viz ====

leaflet() |> 
  addPolygons(data = us_contiguous,
              weight = 1,
              fillColor = "lightgrey",
              fillOpacity = 1,
              label = ~name,
              color = "white") |> 
  addPolygons(data = texas_state,
              weight = 1,
              fillColor = "cornflowerblue",
              fillOpacity = 1,
              label = ~name,
              color = "black") |> 
  setMapWidgetStyle(style = list(background = "bisque"))
