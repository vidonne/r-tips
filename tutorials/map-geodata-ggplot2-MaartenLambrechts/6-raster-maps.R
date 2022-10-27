## Rasters
install.packages("raster")
library(raster)

dem <- raster("data/dem/dem.tif")
plot(dem)

dem.df <- as.data.frame(dem, xy = T)

ggplot(dem.df, aes(x = x, y = y, fill = dem)) +
  geom_raster() +
  geom_contour(aes(z = cutout), colour = "#000000", alpha = 0.5) +
  coord_sf(crs = 3035) +
  theme_minimal() +
  scale_fill_viridis_c(direction = -1, option = "inferno")