library(tidyverse)

world_bank_countries <- read_csv("data/world_bank_countries.csv")

countries_label <- world_bank_countries |> 
  filter(country %in% c("United States", 
                        "Japan", "China", 
                        "India"),
         year == min(year)) |> 
  select(country, year, co2_emissions_tons_per_capita)

world_bank_countries %>% 
  filter(country %in% c("United States", 
                        "Japan", "China", 
                        "India")) %>% 
  ggplot(aes(year, co2_emissions_tons_per_capita,
             color = country)) +
  geom_line() +
  geom_text(data = countries_label,
            aes(label = country),
            hjust = 1,
            nudge_x = -1) +
  # xlim(c(1955, 2020)) +
  scale_x_continuous(limits = c(1955, 2020)) +
  guides(
    color = "none"
  )
