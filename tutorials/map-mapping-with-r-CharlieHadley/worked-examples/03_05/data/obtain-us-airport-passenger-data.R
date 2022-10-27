library(tidyverse)
library(rvest)
library(janitor)
library(tidygeocoder)
library(mapview)

page_busiest_us_airports <- read_html("https://en.wikipedia.org/wiki/List_of_the_busiest_airports_in_the_United_States")

page_busiest_us_airports %>% 
  html_table() %>% 
  .[[1]] %>% 
  clean_names() %>% 
  pivot_longer(starts_with("x2")) %>% 
  rename(airport = airports_large_hubs,
         year = name,
         total_passengers = value) %>% 
  select(airport, year, total_passengers) %>% 
  mutate(year = str_extract(year, "2[0-9]{3}"),
         year = as.integer(year),
         total_passengers = parse_number(total_passengers))


us_airport_passengers <- page_busiest_us_airports %>% 
  html_table() %>% 
  .[[1]] %>% 
  clean_names() %>% 
  pivot_longer(starts_with("x2")) %>% 
  rename(airport = airports_large_hubs,
         year = name,
         total_passengers = value) %>% 
  select(airport, year, total_passengers) %>% 
  mutate(year = str_extract(year, "2[0-9]{3}"),
         year = as.integer(year),
         total_passengers = parse_number(total_passengers))


us_airport_locations <- us_airport_passengers %>% 
  select(airport) %>% 
  distinct() %>% 
  geocode(address = airport)

us_airport_popularity <- us_airport_locations %>% 
  left_join(us_airport_passengers) %>% 
  arrange(year, total_passengers)

us_airport_popularity %>% 
  write_csv("data/us-airport-passenger-numbers_2019.csv")


us_airport_popularity_sf %>% 
  ggplot() +
  geom_sf(aes(size = total_passengers))



