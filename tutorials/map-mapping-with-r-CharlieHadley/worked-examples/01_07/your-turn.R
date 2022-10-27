library("tidyverse")
library("sf")
library("mapview")

england_sf <- read_sf("data/uk-local-authorities/england.shp")
scotland_sf <- read_sf("data/uk-local-authorities/scotland.shp")

wales_sf <- read_sf("data/uk-local-authorities/wales.shp")

uk_sf <- england_sf |> 
  bind_rows(scotland_sf) |> 
  bind_rows(wales_sf)

brexit <- read_csv("data/esw_referendum_results.csv")

uk_sf |> 
  left_join(brexit,
            by = c("geo_code" = "area_code")) |> 
  mapview(zcol = "result")
