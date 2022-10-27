library(stars)
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

ggplot() +
  geom_stars(data = satellite_imagery) +
  facet_wrap(~ band,
             labeller = as_labeller(band_labels)) +
  annotation_scale(location = "bl",
                   pad_x = unit(1, "cm"),
                   pad_y = unit(1, "cm"),
                   data = tibble(band = "1")) +
  annotation_north_arrow(location = "tl",
                         pad_x = unit(1, "cm"),
                         pad_y = unit(1, "cm"),
                         height = unit(0.75, "cm"),
                         width = unit(0.75, "cm"),
                         data = tibble(band = "1")) +
  theme_void()

