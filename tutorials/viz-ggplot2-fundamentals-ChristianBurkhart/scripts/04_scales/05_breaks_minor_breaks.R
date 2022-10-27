library(tidyverse)

world_bank_countries <- read_csv("data/world_bank_countries.csv")

world_bank_countries %>% 
  filter(year == 2000) %>%
  ggplot(aes(gdp_per_capita, y = life_expectancy_at_birth)) +
  geom_point() +
  scale_y_continuous(breaks = seq(40, 80, 20),
                     minor_breaks = seq(50, 60, 1)) +
  scale_x_continuous(minor_breaks = NULL) +
  theme(
    panel.grid.major = element_line(color = "#EC4899"),
    panel.grid.minor = element_line(color = "green"),
  )

# No text for the minor breaks