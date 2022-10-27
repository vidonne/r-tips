library(tigris)
library(sf)
library(rmapshaper)
library(tidyverse)
library(readxl)
library(janitor)

# ==== Streaming Data ====
# Data obtained from https://kiss951.com/2021/05/20/national-streaming-day-list-of-the-most-popular-streaming-services-in-each-state/

most_popular_streaming_service <- read_csv("data/most-popular-streaming-service.csv") %>% 
  clean_names()

# ==== States Data =====

us_contiguous <- states() %>% 
  clean_names() %>% 
  mutate(statefp = as.numeric(statefp)) %>% 
  filter(statefp < 60,
         !statefp %in% c(2, 15)) %>% 
  ms_simplify()

us_most_popular_streaming_sf <- us_contiguous %>% 
  left_join(most_popular_streaming_service,
            by = c("name" = "state"))

# ==== Initial Data Visualisation ====

us_most_popular_streaming_sf |> 
  ggplot() +
  geom_sf(aes(fill = streaming_service))




# ==== Ordering services in the legend ====

order_most_popular_service <- most_popular_streaming_service |> 
  count(streaming_service, sort = TRUE) |> 
  pull(streaming_service)

us_most_popular_streaming_sf |> 
  filter(!is.na(streaming_service)) |> 
  mutate(streaming_service = fct_relevel(streaming_service,
                                         order_most_popular_service)) |> 
  ggplot() +
  geom_sf(aes(fill = streaming_service))

# Nice function fct_explicit_na to name NA
us_most_popular_streaming_sf |> 
  filter(is.na(streaming_service))

# ==== Alternative color palettes ====

us_most_popular_streaming_sf |> 
  filter(!is.na(streaming_service)) |> 
  mutate(streaming_service = fct_relevel(streaming_service,
                                         order_most_popular_service)) |> 
  ggplot() +
  geom_sf(aes(fill = streaming_service)) +
  scale_fill_brewer(palette = "Dark2")






# ==== Custom/manual color palette


colors_services <- list(
  "Amazon Prime" = "#2A96D9",
  "ESPN" = "#BE0002",
  "Hulu" = "#35B12E",
  "Netflix" = "black"
)

# change order to follow fct levels
colors_services <- colors_services[order_most_popular_service]

us_most_popular_streaming_sf |> 
  filter(!is.na(streaming_service)) |> 
  mutate(streaming_service = fct_relevel(streaming_service,
                                         order_most_popular_service)) |> 
  ggplot() +
  geom_sf(aes(fill = streaming_service),
          color = "white") +
  scale_fill_manual(values =  colors_services,
                    name = "Streaming service\n(most to least popular)") +
  theme_void()
  
