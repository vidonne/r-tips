library(tidyverse)
library(sf)
library(janitor)
library(rmapshaper)

# ==== Tidy up data files ====

download.file("https://borders.ukdataservice.ac.uk/ukborders/easy_download/prebuilt/shape/infuse_dist_lyr_2011.zip", "data/infuse_local_authorities.zip")

unzip("data/infuse_local_authorities.zip",
      exdir = "data/infuse_local_authorities")

infuse_sf <- read_sf("data/infuse_local_authorities/")

esw_referendum_results <-
  read_csv(
    "https://data.london.gov.uk/download/eu-referendum-results/52dccf67-a2ab-4f43-a6ba-894aaeef169e/EU-referendum-result-data.csv"
  ) %>%
  clean_names()  %>%
  select(area_code, area, votes_cast, remain, leave) %>%
  mutate(result = ifelse(remain > leave, "Remain", "Leave")) %>% 
  rename(area_name = area)

esw_referendum_results %>% 
  write_csv("data/esw_referendum_results.csv")

not_in_esw <- infuse_sf %>% 
  filter(!geo_code %in% esw_referendum_results$area_code) %>% 
  st_drop_geometry() %>% 
  select(geo_code, name) %>% 
  rename(area_code = geo_code)

ews_sf <- infuse_sf %>% 
  left_join(not_in_esw,
            by = c("name" = "name")) %>% 
  mutate(area_code = ifelse(is.na(area_code),
                            geo_code,
                            area_code)) %>% 
  mutate(area_code = case_when(
    name == "Northumberland" ~ "E06000057",
    name == "Cornwall,Isles of Scilly" ~ "E06000052",
    name == "East Hertfordshire" ~ "E07000242",
    name == "Welwyn Hatfield" ~ "E07000241",
    name == "St Albans" ~ "E07000240",
    TRUE ~ area_code
  )) %>% 
  select(area_code, name) %>% 
  filter(str_starts(area_code, "E|W|S")) %>% 
  rename(geo_code = area_code)

ews_sf <- ews_sf %>% 
  ms_simplify()

# ==== Extract out E, S, W ====

dir.create("data/uk-local-authorities")

ews_sf %>% 
  filter(str_starts(geo_code, "E")) %>% 
  write_sf("data/uk-local-authorities/england.shp")


ews_sf %>% 
  filter(str_starts(geo_code, "S")) %>% 
  write_sf("data/uk-local-authorities/scotland.shp")


ews_sf %>% 
  filter(str_starts(geo_code, "W")) %>% 
  write_sf("data/uk-local-authorities/wales.shp")

# ==== Delete old files ====

unlink("data/infuse_local_authorities/", recursive = TRUE)
unlink("data/infuse_local_authorities.zip")


