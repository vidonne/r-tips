library(readxl)
library(janitor)
library(tidygeocoder)
library(sf)
library(mapview)
library(rnaturalearthdata)
library(tidyverse)
library(ggrepel)

uk_addresses <- read_excel("data/street-addresses.xlsx",
                                      sheet = "UK Addresses") %>% 
  clean_names()

uk_addresses_geocoded <- uk_addresses %>% 
  geocode(street = street_address,
          city = city,
          postalcode = post_code,
          country = country,
          method = "iq")

uk_addresses_sf <- uk_addresses_geocoded %>% 
  st_as_sf(coords = c("long", "lat"), crs = 4326)

uk_sf <- countries50 %>% 
  st_as_sf() %>% 
  filter(name == "United Kingdom")

# Trick to allow the use of ggrepel
uk_addresses_tib <- uk_addresses_sf |> 
  st_coordinates() |> 
  as_tibble() |> 
  bind_cols(st_drop_geometry(uk_addresses_sf))

# Sort by Y so easier to play with nudge of ggrepel
uk_addresses_tib <- uk_addresses_tib |> 
  arrange(Y)

ggplot() +
  geom_sf(data = uk_sf) +
  geom_sf(data = uk_addresses_sf) +
  geom_label_repel(data = uk_addresses_tib,
                   aes(x = X, y = Y,
                       label = location_name),
                   nudge_x = c(-2, 2, 2, -2, 2, -2),
                   nudge_y = c(-1, 0, 0, 0, 0, 0))

