library(stars)
library(leaflet)
library(leafem)
library(tidyverse)

satellite_imagery <- read_stars("data/L7_ETMS.tif")

band_labels <- c(
  "1" = "Band 1\nVisible Blue\n(450 - 520nm)",
  "2" = "Band 2\nVisible Green\n(520 - 600nm)",
  "3" = "Band 3\nVisible Red\n(630 - 690nm)",
  "4" = "Band 4\nNear-Infrared\n(770nm - 900nm)",
  "5" = "Band 5\nShort-wave Infrared\n(1,550nm - 1,750nm)",
  "6" = "Band 6\nThermal\n(10,400nm - 12,500nm)"
)

# ==== dataviz ====

values_band_4 <- satellite_imagery |> 
  filter(band == 4) |> 
  pull()

pal_band_4 <- colorNumeric("viridis",
                           values_band_4)

leaflet() |> 
  addStarsImage(satellite_imagery,
                band = 4,
                colors = pal_band_4) |> 
  addLegend(pal =  pal_band_4,
            values = values_band_4)
