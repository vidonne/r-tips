library(tidyverse)
library(mapview)
library(sf)
library(tigris)
library(tidycensus)

states_2010 <- states(year = 2010,
                      cb = TRUE) #cb to clip shp

vars_census_2010 <- 
  load_variables(2010,
                 dataset = "sf1")

vars_census_2010 %>% 
  View()

# H004001 Total households
# H004002 Mortgages households
# H004004 Renter occupied


households_2010 <- get_decennial(geography = "state",
                                 variables = c("H004001", "H004002", "H004004"),
                                 year = 2010)

households_2010 <- households_2010 %>% 
  pivot_wider(values_from = value,
              names_from = variable) %>% 
  mutate(renter_perc = 100 * H004004 / H004001)

states_2010 %>% 
  select(STATE) %>% 
  left_join(households_2010,
            by = c("STATE" = "GEOID")) %>% 
  mapview(zcol = "renter_perc")
