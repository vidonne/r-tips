library(maps)
library(sf)
library(rnaturalearthdata)
library(leaflet)
library(tidyverse)
library(leaflegend)


brazil_cities <- world.cities %>% 
  filter(country.etc == "Brazil",
         pop > 1e6) %>% 
  mutate(capital = as.logical(capital))

brazil_cities_sf <- brazil_cities %>% 
  st_as_sf(coords = c("long", "lat"), crs = 4326)

brazil_sf <- countries50 %>% 
  st_as_sf() %>% 
  filter(name == "Brazil")


city_label <- function(city, population){
  
  formatted_pop <- scales::number(population, 
                                  scale = 1E-6,
                                  suffix = " Million",
                                  accuracy = 0.1)
  
  paste(
    "<b>", city, "</b>",
    "<br>",
    "Estimated population:", formatted_pop
  )
}


# ==== Data Viz ====

brazil_cities_sf <- brazil_cities_sf |> 
  arrange(desc(pop))

scale_pop <- function(pop) {
  sqrt(pop) * 1e-2
}

leaflet() |> 
  addPolygons(data = brazil_sf,
              fillColor = "darkolivegreen",
              fillOpacity = 1,
              weight = 1,
              color = "black") |> 
  addCircleMarkers(data = brazil_cities_sf,
                   fillColor = "grey",
                   fillOpacity = 1,
                   weight = 1,
                   popup = ~city_label(name, pop),
                   radius = ~scale_pop(pop))







