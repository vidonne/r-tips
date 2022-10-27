library(tidyverse)

world_bank_countries <- read_csv("data/world_bank_countries.csv")


# Exercise: Recreate dataframe
world_bank_countries |> filter(country %in% c("Afghanistan", "United States"))

# Exercise: Find mapped aesthetics
aes(
  x = country, #discrete
  y = life_expectancy_at_birth, #continuous
  fill = country #discrete
  )

# Exercise: Find set aesthetics
alpha