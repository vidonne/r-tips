#
# Packages
#

# install.packages(c("dplyr", "tidyr", "ggplot2", "rnaturalearth", "sf"), dependencies=TRUE)

library(rnaturalearth)
library(dplyr)
library(ggplot2)
library(sf)

#
# Boundaries
#

# Load the world country data boundaries from Natural Earth https://www.naturalearthdata.com/
# Make sure the returned object is of class sf
world <- ne_countries(returnclass = "sf")
# If you view world, you can see that it looks like a regular data frame, with an additional geometry column, which holds the geometry
View(world)

# The sf package comes with plot function. Use max.plot to limit the numbers of attributes to be plotted
plot(world, max.plot = 2)
# Alternatively, you can use dplyr::select() to select the attribute that you would like to plot
plot(select(world, admin))

# Plotting sf objects with ggplot2 is done with geom_sf()
ggplot(data = world) +
  geom_sf()

# Apply the ggplot theme_minimal() style and store the map in the map variable
map <- ggplot(data = world) +
  geom_sf() +
  theme_minimal()
# Plot the map variable
map

# You can update the plotted data with the %+% operator, and with filter() you can filter out single countries
map %+% filter(world, admin == "United States of America")

# For smaller countries you'll notice that the country outline startst to look "jagged"
map %+% filter(world, admin == "Belize")

# Load the 1:10m scale boundary data from Natural Earth
world.hires <- read_sf('data/natural_earth/ne_10m_admin_0_countries/ne_10m_admin_0_countries.shp')
belize.hires <- filter(world.hires, ADMIN == "Belize")
map %+% belize.hires

## With the ne_states function of the rnaturalearth package, you can get subnational administrative boundaries of countries
united.states <- ne_states(country = "United States of America", returnclass = "sf")
map %+% united.states
brazil.states <- ne_states(country = "Brazil", returnclass = "sf")
map %+% brazil.states

## Projections

# Get the coordinate reference system of a sf object with st_crs()
st_crs(world)

## Set the projection of a ggplot2 map with coord_sf()
#World Robinson
map %+% world +
  coord_sf(crs = 54030)
#Bonne
map %+% world +
  coord_sf(crs = 54024)
#Mollweide
map %+% world +
  coord_sf(crs = 54009)

#When no crs is specified, the crs of the first data layer is used (in this case that is WGS84)
map %+% world +
  coord_sf()

## Projections
# Filter out European countries
europe <- filter(world, continent == "Europe")
map %+% europe

# Set the map extent with xlim and ylim
map %+% europe +
  coord_sf(xlim = c(-10,40), ylim = c(30,80))

# Europe in the ETRS89 Lambert Azimuthal Equal-Area projection crs
map %+% europe +
  coord_sf(xlim = c(2500000, 6000000), ylim =c(1150000, 5500000), crs = 3035)

# Conterminous USA in the USA Contiguous Albers Equal Area Conic CRS (EPSG 102003)
united.states <- ne_states(country = "United States of America", returnclass = "sf")
map %+% filter(united.states, name != "Alaska", name != "Hawaii") +
  coord_sf(crs = 102003)

map %+% united.states + coord_sf(crs = 102003)
