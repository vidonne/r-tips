library(raster)
library(tidyverse)
library(sf)
library(mapview)

france_adm0 <- getData(country = "FRA", level = 0)

france_adm0 |> 
  st_as_sf() |> 
  mapview()


france_adm2 <- getData(country = "FRA", level = 2)

france_adm2 |> 
  st_as_sf() |> 
  mapview()
