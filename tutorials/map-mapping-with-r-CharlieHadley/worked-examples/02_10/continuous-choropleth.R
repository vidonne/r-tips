library(tigris)
library(sf)
library(rmapshaper)
library(tidyverse)
library(readxl)
library(janitor)
library(mapview)
library(tidycensus)
library(ggspatial)

us_states <- states() %>% 
  clean_names() %>% 
  mutate(statefp = as.numeric(statefp))

south_atlantic_states <- us_states %>% 
  filter(division == 5) %>% 
  ms_simplify()

prisons_per_state <- get_decennial(geography = "state",
                                   variables = c("state_prisons" = "PCT020006")) %>% 
  clean_names() %>% 
  mutate(value = if_else(name == "District of Columbia",
                         NA_real_,
                         value))

south_atlantic_prisons <- south_atlantic_states %>% 
  left_join(prisons_per_state)

# ==== Your turn =====

south_atlantic_prisons %>%
  ggplot() +
  geom_sf(aes(fill = value,
              shape = "District of Columbia"),
          color = "white",
          size = 0.1) +
  scale_fill_viridis_c(labels = scales::number_format(big.mark = ","),
                       na.value = "pink") +
  guides(fill = guide_colorbar(order = 1,
                               title = "State Prisons"),
         shape = guide_legend(override.aes = list(fill = "pink"),
                              order = 2,
                              title = "")) +
  labs(title = "State prisons per state in the South Atlantic") +
  annotation_scale() +
  annotation_north_arrow(location = "tl") +
  theme_void()





