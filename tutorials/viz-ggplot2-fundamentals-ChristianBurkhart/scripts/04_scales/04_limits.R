library(tidyverse)

world_bank_countries <- read_csv("tutorials/ggplot2-fundamentals/data/world_bank_countries.csv")

world_bank_countries %>% 
  filter(country %in% c("United States", "Germany")) %>% 
  ggplot(aes(x = year, 
             y = internet_usage, 
             color = country)) +
  geom_line() +
  scale_x_continuous(limits = c(1990, 2020)) +
  scale_y_continuous(limits = c(0, 100))

# use of scale will cut the data out > coord_cartesian instead