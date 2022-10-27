library(raster)
library(tidyverse)
library(stars)
library(leaflet)

alaska_landuse <- raster("data/recoded_alaska_landcover.img")

landuse_types <- read_csv("data/landuse-codes.csv")

colors_landuse <- c("0" = "cadetblue3", "1" = "darkolivegreen", "2" = "darkgreen", "4" = "chocolate", "5" = "antiquewhite")

labels_landuse <- landuse_types %>% 
  filter(value %in% unique(values(alaska_landuse))) %>% 
  select(value, label) %>% 
  deframe()

# ==== dataviz ====

pal_alaska <- colorFactor(as.character(colors_landuse),
                          values(alaska_landuse))

labels_landuse

lf_alaska_map <- leaflet() |> 
  addRasterImage(x = alaska_landuse,
                 colors = pal_alaska) |> 
  addLegend(pal = pal_alaska,
            values = values(alaska_landuse),
            labFormat = labelFormat(transform = function(x) labels_landuse[as.character(x)]))



# ==== Alaska bounds ====

lf_alaska_map %>% 
  fitBounds(lng1 = -170, lng2 = -139, lat1 = 52, lat2 = 71)




