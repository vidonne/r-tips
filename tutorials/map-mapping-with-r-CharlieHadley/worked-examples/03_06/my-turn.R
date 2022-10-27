library(tigris)
library(sf)
library(rmapshaper)
library(readxl)
library(janitor)
library(leaflet)
library(tidyverse)

# ==== Streaming Data ====
# Data obtained from https://kiss951.com/2021/05/20/national-streaming-day-list-of-the-most-popular-streaming-services-in-each-state/

most_popular_streaming_service <- read_csv("data/most-popular-streaming-service.csv") %>% 
  clean_names()

# ==== States Data =====

us_contiguous <- states() %>% 
  clean_names() %>% 
  mutate(statefp = as.numeric(statefp)) %>% 
  filter(statefp < 60,
         !statefp %in% c(2, 15)) %>% 
  ms_simplify()

us_most_popular_streaming_sf <- us_contiguous %>% 
  left_join(most_popular_streaming_service,
            by = c("name" = "state"))

# ==== Initial Data Visualisation ====

pal_streaming_service <- colorFactor("Set2", us_most_popular_streaming_sf$streaming_service,
                                     na.color = "yellow")

us_most_popular_streaming_sf |> 
  leaflet() |> 
  addPolygons(weight = 1,
              color = "white",
              fillColor = ~pal_streaming_service(streaming_service),
              fillOpacity = 1) |> 
  addLegend(pal = pal_streaming_service,
            values = ~streaming_service,
            opacity = 1,
            na.label = "Unknown")


# ==== Ordering services in the legend ====

us_most_popular_streaming_sf <- us_most_popular_streaming_sf |> 
  add_count(streaming_service) |> 
  mutate(streaming_service = fct_reorder(streaming_service, n),
         streaming_service = fct_rev(streaming_service))

pal_streaming_service <- colorFactor("Set2", us_most_popular_streaming_sf$streaming_service,
                                     na.color = "yellow")

us_most_popular_streaming_sf |> 
  leaflet() |> 
  addPolygons(weight = 1,
              color = "white",
              fillColor = ~pal_streaming_service(streaming_service),
              fillOpacity = 1) |> 
  addLegend(pal = pal_streaming_service,
            values = ~streaming_service,
            opacity = 1,
            na.label = "Unknown")

# ==== Custom/manual color palette

colors_services <- list(
  "Amazon Prime" = "#2A96D9",
  "ESPN" = "#BE0002",
  "Hulu" = "#35B12E",
  "Netflix" = "black"
)



pal_branded_streaming_service <- colorFactor(unlist(colors_services, use.names = FALSE), us_most_popular_streaming_sf$streaming_service,
                                     na.color = "yellow")

us_most_popular_streaming_sf |> 
  leaflet() |> 
  addPolygons(weight = 1,
              color = "white",
              fillColor = ~pal_branded_streaming_service(streaming_service),
              fillOpacity = 1) |> 
  addLegend(pal = pal_branded_streaming_service,
            values = ~streaming_service,
            opacity = 1,
            na.label = "Unknown",
            title = "Streaming service<br>(most to least popular)")
