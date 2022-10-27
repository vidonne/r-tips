library(rnaturalearthdata)
library(sf)
library(tidyverse)

class(countries110)

countries_sf <- countries110 %>% 
  st_as_sf()

class(countries_sf)