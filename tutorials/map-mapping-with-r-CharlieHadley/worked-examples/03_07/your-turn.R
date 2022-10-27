library(tigris)
library(sf)
library(rmapshaper)
library(readxl)
library(janitor)
library(leaflet)
library(tidycensus)
library(tidyverse)

us_states <- states() %>% 
  clean_names() %>% 
  mutate(statefp = as.numeric(statefp))

south_atlantic_states <- us_states %>% 
  filter(division == 5)

prisoners_per_state <- get_decennial(geography = "state",
              variables = c("state_prison_population" = "PCT020006")) %>% 
  clean_names() %>% 
  mutate(state_prison_population = if_else(name == "District of Columbia",
                         NA_real_,
                         value))

south_atlantic_prisons <- south_atlantic_states %>% 
  left_join(prisoners_per_state)


popup_state_summary <- function(state, n_prisoners){
  
  pmap(list(state, n_prisoners), function(state, n_prisoners){
    
    if(is.na(n_prisoners)){
      
      paste(state, "does not have any state prisons")
      
    } else {
      
      format_prisons <- scales::number(n_prisoners, big.mark = ",")
      
      paste(
        "There are", format_prisons, "state prisoners in", state
      )
      
    }
    
  })
  
}

# ==== Your turn =====

pal_prison_population <- colorNumeric("viridis", south_atlantic_prisons$state_prison_population, na.color = "pink")


lf_south_atlantic_prisons <- south_atlantic_prisons %>% 
  st_transform(crs = 4326) |> 
  leaflet() %>% 
  addPolygons(weight = 1,
              color = "white",
              fillColor = ~pal_prison_population(state_prison_population),
              popup = ~popup_state_summary(name, state_prison_population),
              fillOpacity = 1) %>% 
  addLegend(pal = pal_prison_population,
            values = ~state_prison_population,
            na.label = "District of Columbia",
            title = "Hello")

# ==== NA position fix ====

css_fix <- "div.info.legend.leaflet-control br {clear: both;}" # CSS to correct spacing
html_fix <- htmltools::tags$style(type = "text/css", css_fix) 

lf_south_atlantic_prisons %>% 
  htmlwidgets::prependContent(html_fix)



