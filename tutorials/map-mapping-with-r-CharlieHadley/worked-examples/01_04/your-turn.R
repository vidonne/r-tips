library(sf)
library(tidyverse)
library(rnaturalearthdata)
library(mapview)

tiny_countries110 |> 
  st_as_sf() |> 
  filter(region_un %in% c("Seven Seas (open ocean)", "Oceania")) |> 
  mapview()

