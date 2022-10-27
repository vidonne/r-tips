library(tigris)
library(sf)
library(janitor)
library(rmapshaper)
library(leaflet)
library(leaflet.extras)
library(tidyverse)

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

# ==== Data viz ====

leaflet() |> 
  addPolygons(data = texas_border_states,
              weight = 1,
              fillColor = "lightgrey",
              fillOpacity = 1,
              color = "white") |> 
  addPolygons(data = texas_counties,
              weight = 1,
              fillColor = "cornflowerblue",
              fillOpacity = 1,
              color = "black",
              label = ~NAME) |> 
  addPolygons(data = texas_state,
              weight = 2,
              fillOpacity = 0,
              color = "black",
              options = pathOptions(clickable = FALSE))


# Comments

# st_covers(x, y, sparse = FALSE)
# This function will test if the features in x are covered by y. We set spare = FALSE because otherwise the function will return a complicated “sparse geometry predicate”, instead what we get back is a vector containing TRUE for covered parts of x and FALSE for uncovered parts.
# 
# With that in mind, here’s the code I showed again:
#   
#   us_contiguous[st_touches(texas_state, us_contiguous, sparse = FALSE),]
# st_covers() returns a vector of TRUE/FALSE for states from us_contiguous that touch texas_state. Let’s call this vector touching_predicate.
# The code can now be read as follows, us_contiguous[touching_predicate, ]
# This will return those rows from us_contiguous touch texas_state
