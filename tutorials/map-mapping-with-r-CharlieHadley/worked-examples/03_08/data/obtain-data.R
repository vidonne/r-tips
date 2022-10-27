library(raster)
library(tidyverse)
library(stars)
library(here)

## ==== Alaska landcover data ====

url <- "http://qgis.org/downloads/data/qgis_sample_data.zip"
temp <- tempfile(tmpdir = here(), fileext = ".zip")
download.file(url, temp)
unzip(temp, exdir = "data/gis-example-data")
unlink(temp) #delete the zip file

file.copy("data/gis-example-data/qgis_sample_data/raster/landcover.img", "data/alaska_landcover.img")

dir.create("data/shapefiles_alaksa")
file.copy(list.files("data/gis-example-data/qgis_sample_data/shapefiles/", pattern = "regions", full.names = TRUE), "data/shapefiles_alaksa/")

unlink("data/gis-example-data/", recursive = TRUE)

## ==== Recode ====


alaska_landcover <- raster("data/alaska_landcover.img")

alaska_landuse_codes <- read_csv("data/landuse-codes.csv")

original_landuse_codes <- sort(unique(values(alaska_land_use)))

new_landuse_codes <- alaska_landuse_codes %>% 
  arrange(value) %>% 
  filter(value %in% original_landuse_codes) %>% 
  pull(category_code)

recoded_landuse_types <- matrix(
  c(original_landuse_codes, 
    new_landuse_codes), 
  ncol = 2)

alaska_land_use <- reclassify(alaska_landcover, rcl = recoded_landuse_types)

alaska_sf <- read_sf("data/shapefiles_alaksa")

crop_alaska <- crop(alaska_land_use, alaska_sf)

rasterize_alaska <- rasterize(alaska_sf, crop_alaska)

alaska_landuse_cropped <- mask(crop_alaska, rasterize_alaska)

alaska_landuse_cropped %>% 
  writeRaster("data/recoded_alaska_landcover.img", overwrite = TRUE)

## === Landsat 7 data ====

landsat7_data <- read_stars(system.file("tif/L7_ETMs.tif", package = "stars"))

landsat7_data %>% 
  write_stars("data/L7_ETMS.tif")

