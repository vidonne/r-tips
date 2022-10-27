library(tidyverse)
library(sf)
library(rnaturalearthdata)
library(countrycode)
library(gapminder)

gapminder_2007 <- gapminder %>% 
  filter(year == 2007) |> 
  mutate(iso3c = countryname(country, "iso3c"))

countries_sf <- countries110 %>%
  st_as_sf()

countries_sf |> 
  left_join(gapminder_2007, by = c("iso_a3" = "iso3c")) |> 
  mapview(zcol = "lifeExp")
