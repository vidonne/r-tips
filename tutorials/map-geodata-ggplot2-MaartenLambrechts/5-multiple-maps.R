#
# Multiple maps
#

library(dplyr)
library(tidyverse)
library(ggplot2)
library(sf)

# Load the world country boundary data
world <- st_read("data/natural_earth/ne_110m_admin_0_countries/ne_110m_admin_0_countries.shp")

# Load the fertility data
fertility <- read.csv("data/API_SP.DYN.TFRT.IN_DS2_en_csv_v2/API_SP.DYN.TFRT.IN_DS2_en_csv_v2.csv", stringsAsFactors=FALSE)
# Convert the fertility data to long format and remove the "X" character from the years
fertility.long <- pivot_longer(fertility, cols = 5:63, names_to = "Year", values_to = "Value") %>%
  mutate(Year = as.numeric(gsub("X", "", Year))) %>%
  #remove columns with missing data
  select(-X2019, -X2020, -X)
# We are using only the data for the years 1968 - 2018
fertility.decades <- filter(fertility.long, (Year %% 10) == 8)

# Join the data. Use a right join, to have a row in the joined data for each row in fertility.decades
world.fertility.decades <- right_join(world, fertility.decades, by = c("iso_a3" = "Country.Code"))

# Plot the map
ggplot(world.fertility.decades, aes(fill = Value)) +
  geom_sf(color = "#ffffff", size = 0.1) +
  scale_fill_viridis_c(direction = -1, option = "inferno") +
  coord_sf(crs = 54009) +
  theme_minimal() +
  facet_wrap(~Year, ncol = 2)

# Facetted map with classed values
world.fertility.decades$fert.class <- cut(world.fertility.decades$Value, breaks = c(0:9))

ggplot(world.fertility.decades, aes(fill = fert.class)) +
  geom_sf(color = "#ffffff", size = 0.1) +
  scale_fill_viridis_d(direction = -1, option = "inferno", name = "Fertility rate", labels = c("<1", "1-2", "2-3", "3-4", "4-5", "5-6", "6-7", "7-8", ">8", "Missing data"), na.value = "#dddddd") +
  coord_sf(crs = 54009) +
  theme_minimal() +
  facet_wrap(~Year, ncol = 2)
