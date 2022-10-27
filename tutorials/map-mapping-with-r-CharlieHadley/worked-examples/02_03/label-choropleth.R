library(tigris)
library(janitor)
library(rmapshaper)
library(tidyverse)

us_states <- states(resolution = "500k") %>% 
  clean_names() %>% 
  mutate(statefp = as.numeric(statefp))
  
us_contiguous <- us_states %>% 
  filter(statefp < 60,
         !statefp %in% c(2, 15)) %>% 
  ms_simplify()



us_contiguous %>% 
  ggplot() +
  geom_sf() +
  geom_sf_label(aes(label = name))
