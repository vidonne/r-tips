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

# ==== leaflegend solution ====

bubble_base_size <- 20

generated_circles <- makeSizeIcons(value = sort(brazil_cities_sf$pop),
                                   'circle',
                                   baseSize = bubble_base_size,
                                   opacity = 0.8,
                                   color = 'black',
                                   fillColor = "lightgrey")

leaflet() %>% 
  addPolygons(data = brazil_sf,
              weight = 1,
              fillColor = "darkolivegreen",
              fillOpacity = 1,
              opacity = 0) %>% 
  addMarkers(data = arrange(brazil_cities_sf, pop),
             label = ~name,
             icon = generated_circles) %>% 
  addLegendSize(shape = 'circle',
                color = 'black',
                baseSize = bubble_base_size,
                values = brazil_cities_sf$pop,
                orientation = 'horizontal',
                numberFormat = function(x) {scales::number(x, scale = 1E-6, suffix = " Million") },
                position = 'bottomright',
                title = "City population"
  )

                