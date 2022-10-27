library(tidyverse)

world_bank_areas <- read_csv("data/world_bank_areas.csv")

forests <- world_bank_areas %>% 
  filter(year %in% c(1990, 2000, 2010, 2017)) %>% 
  filter(area != "World")

forests |> 
  mutate(year = as.factor(year)) |> 
  ggplot(aes(x = area,
             y = forest_land,
             fill = year)) +
  geom_col(position = position_dodge())
