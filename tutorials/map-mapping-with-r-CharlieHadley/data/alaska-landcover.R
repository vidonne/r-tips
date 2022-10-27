library("tidyverse")
library("stars")
library("here")

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