# Load packages
library(raster)
library(ggplot2)

# Load raster data
dem <- raster("data/dem/dem.tif")

# Regular plot
plot(dem)


# Mapping raster data -----------------------------------------------------

# create df format for ggplot
dem.df <- as.data.frame(dem, xy = TRUE)
View(dem.df)


# Map using ggplot
ggplot(dem.df) +
  geom_raster(aes(x = x, y = y, fill = dem))

# Ggplot doesn't know the CRS so need to be added
ggplot(dem.df) +
  geom_raster(aes(x = x, y = y, fill = dem)) +
  coord_sf(crs = 3035) +
  theme_minimal() +
  xlab("") + ylab("")

# Change color palette
ggplot(dem.df) +
  geom_raster(aes(x = x, y = y, fill = dem)) +
  coord_sf(crs = 3035) +
  theme_minimal() +
  xlab("") + ylab("") +
  scale_fill_continuous(type = "viridis", direction = -1)


# Create binned color
dem.df$dem.classed <- cut(dem.df$dem, breaks = seq(1000, 4000, 250))
ggplot(dem.df) +
  geom_raster(aes(x = x, y = y, fill = dem.classed)) +
  coord_sf(crs = 3035) +
  theme_minimal() +
  xlab("") + ylab("") +
  scale_fill_viridis_d(direction = -1)

# Cleaning legend and changing direction
dem.df$dem.classed <- cut(dem.df$dem, breaks = seq(1000, 4000, 250))
ggplot(dem.df) +
  geom_raster(aes(x = x, y = y, fill = dem.classed)) +
  coord_sf(crs = 3035) +
  theme_minimal() +
  xlab("") + ylab("") +
  scale_fill_viridis_d(direction = 1)


# More fun with rasters ---------------------------------------------------

# Use of inferno palette
ggplot(dem.df) +
  geom_raster(aes(x = x, y = y, fill = dem)) +
  coord_sf(crs = 3035) +
  theme_minimal() +
  xlab("") + ylab("") +
  scale_fill_viridis_c(direction = -1, option = "inferno")


# Create contour lines
ggplot(dem.df) +
  geom_contour(aes(x = x, y = y, z = dem), colour = "#000000") +
  coord_sf(crs = 3035) +
  theme_minimal() +
  xlab("") + ylab("")

# Adjust bin width to add some more info
ggplot(dem.df) +
  geom_contour(aes(x = x, y = y, z = dem), colour = "#000000", binwidth = 100) +
  coord_sf(crs = 3035) +
  theme_minimal() +
  xlab("") + ylab("")

# Also possible to use geom_contour_filled
ggplot(dem.df) +
  geom_contour_filled(aes(x = x, y = y, z = dem)) +
  coord_sf(crs = 3035) +
  theme_minimal() +
  xlab("") + ylab("") +
  scale_fill_viridis_d(direction = -1, option = "inferno")

# Combine both raster and contour
ggplot(dem.df) +
  geom_raster(aes(x = x, y = y, fill = dem)) +
  geom_contour(aes(x = x, y = y, z = dem), colour = "#FFFFFF", alpha = 0.4) +
  scale_fill_viridis_c(direction = -1, option = "inferno") +
  coord_sf(crs = 3035) +
  theme_minimal() +
  xlab("") + ylab("")
