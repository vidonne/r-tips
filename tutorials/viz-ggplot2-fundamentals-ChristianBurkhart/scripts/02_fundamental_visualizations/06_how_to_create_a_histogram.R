library(tidyverse)

world_bank_countries <- read_csv("data/world_bank_countries.csv")

world_bank_countries |> 
  ggplot(aes(x = women_in_national_parliaments)) +
  geom_histogram(fill = "steelblue",
                 color = "white",
                 binwidth = 5)
