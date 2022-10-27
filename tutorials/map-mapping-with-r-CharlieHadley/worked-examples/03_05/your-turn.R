library(tidyverse)
library(sf)
library(tigris)
library(rmapshaper)
library(janitor)
library(leaflet)

us_airport_passengers <- read_csv("data/us-airport-passenger-numbers_2019.csv")

us_airport_passengers_2019 <- us_airport_passengers %>% 
  mutate(airport = str_remove_all(airport, "[\\[].*[\\]]")) %>% 
  filter(year == 2019) %>% 
  slice_max(total_passengers, n = 10) %>% 
  st_as_sf(coords = c("long", "lat"))

us_contiguous_sf <- states() %>% 
  clean_names() %>% 
  mutate(statefp = as.numeric(statefp)) %>% 
  filter(statefp < 60,
         !statefp %in% c(2, 15)) %>% 
  ms_simplify()

popup_airport <- function(airport, passengers){
  
  format_passengers <- scales::number(passengers, scale = 1E-6, suffix = " Million", accuracy = 1)
  
  paste(
    airport, "flew", format_passengers, "passengers in 2019"
  )
  
}


# ==== Data viz ====

us_airport_passengers_2019 <- us_airport_passengers_2019 |> 
  arrange(desc(total_passengers))

size_passenger <- function(tot_passenger) {
  sqrt(tot_passenger) * 2e-3
}

leaflet() |> 
  addPolygons(data = us_contiguous_sf,
              fillColor = "grey",
              fillOpacity = 1,
              color = "white",
              weight = 1) |> 
  addCircleMarkers(data = us_airport_passengers_2019,
                   fillColor = "blue",
                   color = "black",
                   weight = 1,
                   label = ~airport,
                   popup = ~popup_airport(airport, total_passengers),
                   radius = ~size_passenger(total_passengers))


