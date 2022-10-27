library(tidyverse)
library(scales)

world_bank_countries <- read_csv("data/world_bank_countries.csv")

world_bank_countries %>% 
  filter(year == 2000) %>%
  ggplot(aes(gdp_per_capita, y = life_expectancy_at_birth)) +
  geom_point(aes(fill = continent), color = "black", shape = 21,
             size = 3, alpha = .7) +
  scale_fill_viridis_d(option = "magma", name = "The five continents", direction = -1) +
  scale_x_continuous(labels = label_number(),
                     breaks = seq(0, 140000, 20000))
