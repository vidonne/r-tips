library(raster)
library(stars)
library(tidyverse)
library(ggspatial)

# ==== raster ===

alaska_landuse <- raster("data/recoded_alaska_landcover.img")

landuse_types <- read_csv("data/landuse-codes.csv")

colors_landuse <- c("0" = "cadetblue3", "1" = "darkolivegreen", "2" = "darkgreen", "4" = "chocolate", "5" = "antiquewhite")

labels_landuse <- landuse_types %>% 
  filter(value %in% unique(values(alaska_landuse))) %>% 
  select(value, label) %>% 
  deframe()

ggplot() +
  layer_spatial(alaska_landuse,
                aes(fill = stat(as.character(band1)))) +
  scale_fill_manual(values = colors_landuse,
                    labels = labels_landuse,
                    name = "Land use types") +
  annotation_scale() +
  annotation_north_arrow(location = "tl", 
                         pad_x = unit(2, "cm"),
                         pad_y = unit(1, "cm")) +
  theme_void()
