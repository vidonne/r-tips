library(tigris)
library(sf)
library(rmapshaper)
library(tidyverse)
library(readxl)
library(janitor)

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

# ==== Your Data Viz ==== 

order_of_regions <- us_contiguous |> 
  count(region, sort = TRUE) |> 
  pull(region)

colors_of_regions <- list("Northeast" = "#c03728",
                          "Midwest" = "#919c4c",
                          "West" = "#fd8f24",
                          "South" = "#f5c04a")

colors_of_region <- colors_of_regions[order_of_regions]

us_contiguous %>% 
  mutate(region = fct_relevel(region, order_of_regions)) |> 
  ggplot() +
  geom_sf(aes(fill = region)) +
  scale_fill_manual(values = colors_of_regions) +
  theme_void()


