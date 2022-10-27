library(sf)
library(mapview)

england_and_wales <- read_sf("data/Counties_and_Unitary_Authorities_(December_2015)_Boundaries")

england_and_wales %>% 
  mapview()

us_data <- read_sf("data/sr20_500k")

us_counties <- read_sf("data/sr20_500k/county_bas20_sr_500k.shp")

us_states <- read_sf("data/sr20_500k/state_bas20_sr_500k.shp")

us_states %>% 
  mapview()

us_counties %>% 
  mapview()
