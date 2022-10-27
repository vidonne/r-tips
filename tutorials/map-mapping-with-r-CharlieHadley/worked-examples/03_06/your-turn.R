library(tigris)
library(sf)
library(rmapshaper)
library(tidyverse)
library(readxl)
library(janitor)
library(leaflet)

# ==== States Data =====

us_contiguous <- states() %>% 
  clean_names() %>% 
  mutate(statefp = as.numeric(statefp)) %>% 
  filter(statefp < 60,
         !statefp %in% c(2, 15)) %>% 
  ms_simplify()

us_contiguous <- us_contiguous %>% 
  mutate(region = case_when(region == 1 ~ "Northeast",
                            region == 2 ~ "Midwest",
                            region == 3 ~ "South",
                            region == 4 ~ "West"))

colors_of_regions <- list("Northeast" = "#c03728",
                          "Midwest" = "#919c4c",
                          "West" = "#fd8f24",
                          "South" = "#f5c04a")

# ==== Your Data Viz ==== 

pal_regions <- colorFactor(unlist(colors_of_regions,
                                  use.names = FALSE),
                           us_contiguous$region)

us_contiguous <- us_contiguous |> 
  add_count(region) |>
  mutate(region = fct_reorder(region, n),
         region = fct_rev(region))

us_contiguous |> 
  leaflet() |> 
  addPolygons(weight = 1,
              color = "white",
              fillOpacity = 1,
              fillColor = ~pal_regions(region)) |> 
  addLegend(pal = pal_regions,
            values = ~region,
            opacity = 1,
            title = "Region<br>(in size order)")

