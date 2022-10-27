library(tidyverse)
library(mapview)
library(sf)
library(tigris)
library(tidycensus)


states_2015 <- states(year = 2015, cb = TRUE)


vars_acs_2015 <- load_variables(2015, "acs5", cache = TRUE)

view(vars_acs_2015)

# B25003_001 Total
# B25003_003 Renter

household_2015 <- get_acs(geography = "state",
        variables = c("B25003_001", "B25003_003"),
        year = 2015)

household_2015 <- household_2015 |> 
  select(-moe) |> 
  pivot_wider(values_from = estimate,
              names_from = variable) |> 
  mutate(renter_perc = 100 * B25003_003 / B25003_001)

states_2015 |> 
  select(GEOID) |> 
  left_join(household_2015) |> 
  mapview(zcol = "renter_perc")
