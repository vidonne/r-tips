library(tigris)
library(sf)
library(janitor)
library(tidyverse)
library(rmapshaper)

us_states <- states(resolution = "500k") %>% 
  clean_names() %>% 
  mutate(statefp = as.numeric(statefp))

us_contiguous <- us_states %>% 
  filter(statefp < 60,
         !statefp %in% c(2, 15)) %>% 
  ms_simplify()

texas_state <- us_contiguous %>% 
  filter(name == "Texas")

ggplot() +
  geom_sf(data = us_contiguous,
          color = "white") +
  geom_sf(data = texas_state,
          fill = "cornflowerblue") +
  theme_void()


