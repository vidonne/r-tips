library(rnaturalearthdata)
# remotes::install_github("hrbrmstr/albersusa")
library(albersusa)
library(sf)
library(raster)
library(mapview)

alaska_landcover <- raster("data/alaska_landcover.img")

alaska_landcover %>% 
  mapview()

countries110 %>% 
  mapview()

countries110 %>% 
  st_as_sf() %>% 
  mapview()

mapview(c(countries110, tiny_countries110))

usa_sf() %>% 
  mapview()