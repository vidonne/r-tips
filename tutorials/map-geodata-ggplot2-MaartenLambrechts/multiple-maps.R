# Load packages 
library(dplyr)
library(tidyr)
library(ggplot2)
library(rnaturalearth)
library(sf)

# Shapefile
world <- read_sf("data/natural_earth/ne_110m_admin_0_countries/ne_110m_admin_0_countries.shp")

fertility <- read.csv("data/API_SP.DYN.TFRT.IN_DS2_en_csv_v2/API_SP.DYN.TFRT.IN_DS2_en_csv_v2.csv", stringsAsFactors=FALSE)

# Turn to long format for ggplot
fertility.long <- pivot_longer(fertility, cols = 5:63, names_to = "Year", values_to = "Value") %>%
  mutate(Year = as.numeric(gsub("X", "", Year))) %>%
  select(-X2019, -X2020, -X)

# Filter every decades
fertility.decades <- filter(fertility.long, (Year %% 10) == 8)

# Use right_join to make sure the geometry is in every year
world.fertility.decades <- right_join(world, fertility.decades, by = c("iso_a3" = "Country.Code"))

# Use facet to make multiple maps
ggplot(world.fertility.decades, aes(fill = Value)) +
  geom_sf(color = "#ffffff", size = 0.1) +
  scale_fill_viridis_c(direction = -1, option = "inferno") +
  coord_sf(crs = "ESRI:54009") +
  theme_minimal() +
  facet_wrap(~Year, ncol = 2)

# With binned cat
world.fertility.decades$fert.class <- cut(world.fertility.decades$Value, breaks = c(0:9))

ggplot(world.fertility.decades, aes(fill = fert.class)) +
  geom_sf(color = "#ffffff", size = 0.1) +
  scale_fill_viridis_d(direction = -1, option = "inferno",
                       name = "Fertility rate",
                       labels = c("<1", "1-2", "2-3", "3-4", "4-5", "5-6", "6-7", "7-8", ">8", "Missing data"), na.value = "#dddddd") +
  coord_sf(crs = "ESRI:54009") +
  theme_minimal() +
  facet_wrap(~Year, ncol = 2)


