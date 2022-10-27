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

# ==== Data viz ====

us_airport_passengers_2019 <- us_airport_passengers_2019 %>% 
  arrange(desc(total_passengers))

popup_airport <- function(airport, passengers){
  
  format_passengers <- scales::number(passengers, scale = 1E-6, suffix = " Million", accuracy = 1)
  
  paste(
    airport, "flew", format_passengers, "passengers in 2019"
  )
  
}

pal_total_passengers <- colorBin("viridis", us_airport_passengers_2019$total_passengers)

leaflet() %>% 
  addPolygons(data = us_contiguous_sf,
              fillColor = "darkolivegreen",
              fillOpacity = 1,
              color = "white",
              weight = 1) %>% 
  addCircleMarkers(data = us_airport_passengers_2019,
                   radius = ~ sqrt(total_passengers) * 6E-3,
                   fillColor = ~pal_total_passengers(total_passengers),
                   fillOpacity = 0.8,
                   label = ~airport,
                   color = "black",
                   popup = ~popup_airport(airport, total_passengers),
                   weight = 1) %>% 
  addLegend(pal = pal_total_passengers,
            values = ~total_passengers,
            data = us_airport_passengers_2019,
            opacity = 0.8)


