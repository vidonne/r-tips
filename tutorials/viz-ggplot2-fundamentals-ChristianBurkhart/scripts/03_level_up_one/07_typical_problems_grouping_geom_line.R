library(tidyverse)

world_bank_countries <- read_csv("data/world_bank_countries.csv")


# Without grouping --------------------------------------------------------
world_bank_countries %>% 
  filter(country %in% c("Germany", "United States", 
                        "China", "Spain")) %>% 
  ggplot(aes(x = year,
             y = co2_emissions_tons_per_capita)) + 
  geom_line()


# Without a grouping you will always get only one line.
# With a grouping you will get multiple lines.
# Grouping can be achieved with the aesthetic group, color or linetype


# Trick -------------------------------------------------------------------
fake_data <- tibble(
  year = c(2019, 2019, 2019,
           2020, 2020, 2020,
           2021, 2021, 2021),
  co2_emission = c(15, 8, 7, 18, 12, 5, 20, 8, 2),
  country = c(rep(c("Germany", "United States", "China"), 3))
) 

fake_data %>% 
  ggplot(aes(x = year,
             y = co2_emission)) + 
  geom_line()

# Select the data for the mapped variables
# arrange the values on the x variable
fake_data |> 
  select(year, co2_emission) |> 
  arrange(year)

# If you want to see multiple lines, select the values
# of one grouping variable and see if the values 
# for this line make sense
fake_data |> 
  filter(country == "United States") |> 
  select(year, co2_emission) |> 
  arrange(year)

# If yes, group by this variable with group, color or linetype
fake_data %>% 
  ggplot(aes(x = year,
             y = co2_emission,
             color = country)) + 
  geom_line()

# Solution to the problem -------------------------------------------------
world_bank_countries %>% 
  filter(country %in% c("Germany", "United States", 
                        "China", "Spain")) %>% 
  ggplot(aes(x = year,
             y = co2_emissions_tons_per_capita,
             group = country)) + 
  geom_line()


# One grouping might not be enough ----------------------------------------
world_bank_countries %>% 
  filter(country %in% c("Germany", "United States", 
                        "China", "Spain")) %>% 
  ggplot(aes(x = year,
             y = co2_emissions_tons_per_capita,
             group = country,
             color = continent)) + 
  geom_line()
