library("tidyverse")
library("sf")
library("rmapshaper")

## ==== UK shapefiles ====

download.file(url = "https://opendata.arcgis.com/datasets/ae90afc385c04d869bc8cf8890bd1bcd_1.zip?outSR=%7B%22latestWkid%22%3A27700%2C%22wkid%22%3A27700%7D",
              destfile = "data/original_uk_local_authorities.zip")

unzip(zipfile = "data/original_uk_local_authorities.zip",
      exdir = "data/original_uk_local_authorities")


original_uk_local_authorities <-  read_sf("data/original_uk_local_authorities")

uk_local_authorities <- original_uk_local_authorities %>%
  ms_simplify(keep = 0.05)

dir.create("data/uk_local_authorities")

uk_local_authorities %>% 
  write_sf("data/uk_local_authorities/uk_local_authorities.shp")

unlink("data/original_uk_local_authorities/", recursive = TRUE)
unlink("data/original_uk_local_authorities.zip")

