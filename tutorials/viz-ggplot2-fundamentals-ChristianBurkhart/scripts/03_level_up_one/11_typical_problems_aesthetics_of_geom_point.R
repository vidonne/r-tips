library(tidyverse)

world_bank_countries <- read_csv("data/world_bank_countries.csv")

world_bank_countries %>% 
  filter(year == 2000) %>%
  ggplot(aes(gdp_per_capita, y = life_expectancy_at_birth)) +
  geom_point(fill = "steelblue", shape = 21)


# Shape 0 - 14 ------------------------------------------------------------
# Can change color and stroke
world_bank_countries %>% 
  filter(year == 2000) %>%
  ggplot(aes(gdp_per_capita, y = life_expectancy_at_birth)) +
  geom_point(color = "steelblue", shape = 0,
             stroke = 2)

# Shape 15 - 20 -----------------------------------------------------------
# Can change only color
world_bank_countries %>% 
  filter(year == 2000) %>%
  ggplot(aes(gdp_per_capita, y = life_expectancy_at_birth)) +
  geom_point(color = "steelblue", shape = 17)

# Shape 21 - 25 -----------------------------------------------------------
# Can change fill, color and stroke
world_bank_countries %>% 
  filter(year == 2000) %>%
  ggplot(aes(gdp_per_capita, y = life_expectancy_at_birth)) +
  geom_point(fill = "steelblue", shape = 23, color = "red", stroke = 2)
