library(tidyverse)
library(sf)
library(countrycode)
library(rnaturalearthdata)
library(mapview)

countries_sf <- countries110 %>%
  st_as_sf() %>% 
  select(name, region_un, iso_a3)

countries_data <- tribble(
  ~country_name, ~choropleth_variable,
  "United Kingdom", 23,
  "USA", 30,
  "Peru", 26,
  "South Africa", 31,
  "Holland", 20
)


countries_sf %>% 
  left_join(countries_data,
            by = c("name" = "country_name")) %>% 
  mapview(zcol = "choropleth_variable")

countryname("Holland", "iso3c")

countries_data <- countries_data %>% 
  mutate(iso_3c = countryname(country_name, "iso3c"))

countries_sf %>% 
  left_join(countries_data,
            by = c("iso_a3" = "iso_3c")) %>% 
  mapview(zcol = "choropleth_variable")
