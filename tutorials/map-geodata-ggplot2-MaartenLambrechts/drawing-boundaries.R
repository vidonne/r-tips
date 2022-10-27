# Load packages 
library(dplyr)
library(tidyr)
library(ggplot2)
library(rnaturalearth)
library(sf)


# Loading simple features -------------------------------------------------

# Load data from rnaturalearth
world <- ne_countries(returnclass = "sf")
View(world)
print(world, n = 0)

# Plot from sf package
plot(world, max.plot = 2)
plot(select(world, admin))



# Mapping boundaries with ggplot2 -----------------------------------------

# First ggplot2 map
ggplot(data = world) +
  geom_sf()

# Adding theme
map <- ggplot(data = world) +
  geom_sf() +
  theme_minimal()
map

# Single country map
# ggplot2‘s %+% operator to override
map %+% filter(world, admin == "United States of America")

# Single small country map
map %+% filter(world, admin == "Belize")
# Quality isn't great due to resolution

# Load high res from Natural Earth with ne_download()
world_hires <- ne_download(scale = 10, type = "countries",
                           category = "cultural",
                           returnclass = "sf")

# Load data from tuto, if already downloaded
world_hires_direct <- read_sf('data/natural_earth/ne_10m_admin_0_countries/ne_10m_admin_0_countries.shp') 

# Filter Belize and map it
belize_hires <- filter(world_hires, ADMIN == "Belize")
map %+% belize_hires

# Admin 1 level (subnational) administrative boundaries from Natural Earth
world.admin1 <- ne_download(scale = 10, type = "states", category = "cultural", returnclass = "sf")
# Alternatively, you can load the same data set from the additional data provided with this tutorial
# world.admin1 <- read_sf("hires-data/ne_10m_admin_1_states_provinces/ne_10m_admin_1_states_provinces.shp")

united.states <- filter(world.admin1, admin == "United States of America")
map %+% united.states

# Or Brazil
brazil.states <- filter(world.admin1, admin == "Brazil")
map %+% brazil.states


# Projections -------------------------------------------------------------

# Robinson
map %+% world +
  coord_sf(crs = 'ESRI:54030')
# https://github.com/r-spatial/sf/issues/1645#issuecomment-820311789 
# When not an EPSG proj need to add the provider "ESRI:54030" insted of 54030

# Bonne
map %+% world +
  coord_sf(crs = 'ESRI:54024')

# More on projections

# Filter on europe > Issue of zoom because of Russia
europe <- filter(world, continent == "Europe")
map %+% europe

# Set some limits to fix it
map %+% europe +
  coord_sf(xlim = c(-10, 40), ylim = c(30, 80))
# Limits are better but still issue of CRS

# Limit + CRS
map %+% europe +
  coord_sf(xlim = c(-10, 40), ylim = c(30, 80), crs = 3035)
# Map look broken at least zoom seems wrong >
# WGS84 uses degrees and 3035 meters
map %+% europe +
  coord_sf(xlim = c(2500000, 6000000), ylim =c(1150000, 5500000), crs = 3035)

# Same example with USA and Albers Equal Area
map %+% filter(united.states, name != "Alaska", name != "Hawaii") +
  coord_sf(crs = "ESRI:102003")

# Without filtering Alaska and Hawai
map %+% united.states +
  coord_sf(crs = "ESRI:102003")

