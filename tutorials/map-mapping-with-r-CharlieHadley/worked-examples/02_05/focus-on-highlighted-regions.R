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

# ==== New code =====

texas_border_states <- us_contiguous[st_touches(texas_state, us_contiguous, sparse = FALSE), ]

texas_counties <- counties(state = "TX") %>% 
  ms_simplify()

ggplot() +
  geom_sf(data = texas_border_states,
          color = "white") +
  geom_sf_label(data = texas_border_states,
                aes(label = name)) +
  geom_sf(data = texas_counties,
          aes(fill = if_else(NAMELSAD == "Travis County",
                             "Capital",
                             "Not capital")),
          color = "white",
          size = 0.2) +
  scale_fill_manual(values = c("Capital" = "red",
                               "Not capital" = "cornflowerblue"),
                    name = "") +
  geom_sf(data = texas_state,
          fill = "transparent") +
  theme_void()
