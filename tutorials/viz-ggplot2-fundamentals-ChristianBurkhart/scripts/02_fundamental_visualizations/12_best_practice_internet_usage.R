library(tidyverse)

world_bank_areas <- read_csv("data/world_bank_areas.csv")

world_bank_areas |> 
  filter(area != "World") |> 
  ggplot(aes(x = year,
             y = internet_usage,
             fill = area)) +
  geom_area(alpha = .9)
