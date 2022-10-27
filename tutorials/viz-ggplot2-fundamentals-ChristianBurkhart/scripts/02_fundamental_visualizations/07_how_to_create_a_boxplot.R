library(tidyverse)

world_bank_countries <- read_csv("data/world_bank_countries.csv")

world_bank_countries |> 
  filter(year == 2017) |> 
  ggplot(aes(x = continent,
             y = overweight,
             fill = continent,
             color = continent)) +
  geom_boxplot(alpha = .5,
               width = .6)
