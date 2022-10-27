library(tidyverse)
library(readxl)
library(sf)
library(mapview)

airport_locations <- read_excel("data/airport-locations.xlsx")

airport_locations |>
  st_as_sf(coords = c("longitude", "latitude"), crs = 4326) |> 
  mapview()
