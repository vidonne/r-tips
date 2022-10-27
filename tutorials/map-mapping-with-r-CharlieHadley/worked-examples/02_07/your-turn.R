library(tigris)
library(sf)
library(rmapshaper)
library(tidyverse)
library(readxl)
library(janitor)
library(mapview)
library(tidycensus)

us_states <- states() %>% 
  clean_names() %>% 
  mutate(statefp = as.numeric(statefp))

south_atlantic_states <- us_states %>% 
  filter(division == 5) %>% 
  ms_simplify()

prisoners_per_state <- get_decennial(geography = "state",
              variables = c("state_prison_population" = "PCT020006")) %>% 
  clean_names() %>% 
  mutate(state_prison_population = if_else(name == "District of Columbia",
                         NA_real_,
                         value))

south_atlantic_prisons <- south_atlantic_states %>% 
  left_join(prisoners_per_state)


# ==== Your turn =====

south_atlantic_prisons |> 
  ggplot() +
  geom_sf(aes(fill = value, shape = "District of Columbia")) +
  scale_fill_viridis_c(na.value = "pink") +
  theme_void() +
  guides(shape = guide_legend(override.aes = list(fill = "pink", order = 2), title = NULL), fill = guide_colorbar(order = 1))
