library(tidycensus)
library(tidyverse)
library(tigris)
library(sf)
library(janitor)
library(rmapshaper)

us_contiguous <- states() %>% 
  clean_names() %>% 
  mutate(statefp = as.numeric(statefp)) %>% 
  filter(statefp < 60,
         !statefp %in% c(2, 15)) %>% 
  ms_simplify()


education_breakdown <- get_acs(
  geography = "state",
  year = 2019,
  variables = c(
    "Didn't graduate high school" = "B06009_002",
    "High school graduate" = "B06009_003",
    "College degree" = "B06009_004",
    "Bachelor's degree" = "B06009_005",
    "Graduate degree" = "B06009_006"
  )) %>% 
  clean_names() %>% 
  group_by(name) %>% 
  mutate(estimate = estimate / sum(estimate)) %>% 
  rename(education_attainment = variable)

us_education_attainment_sf <- us_contiguous %>% 
  left_join(education_breakdown)

order_of_education <- c("Didn't graduate high school", "High school graduate", "College degree", "Bachelor's degree", "Graduate degree")

# ==== your data viz

us_education_attainment_sf |> 
  mutate(education_attainment = fct_relevel(education_attainment, order_of_education)) |> 
  ggplot() +
  geom_sf(aes(fill = estimate)) +
  scale_fill_viridis_c() +
  facet_wrap(~ education_attainment) +
  theme_void()
