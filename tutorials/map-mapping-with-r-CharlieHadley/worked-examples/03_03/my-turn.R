library(sf)
library(rnaturalearthdata)
library(leaflet)
library(tidyverse)
library(leaflet.extras)

countries_sf <- countries110 %>% 
  st_as_sf()

popup_country_pop <- function(country, continent, population) {
  formatted_pop <- scales::number(population,
                                  scale = 1e-6,
                                  suffix = " Million",
                                  accuracy = 0.1)
  paste("<b>", country, "</b>",
        "is in the continent of",
        "<b>", continent, "</b>", "<br>",
        "Estimated population: ", formatted_pop)
}

countries_sf |> 
  leaflet() |> 
  addPolygons(label = ~name,
              popup = ~popup_country_pop(name, continent, pop_est))
