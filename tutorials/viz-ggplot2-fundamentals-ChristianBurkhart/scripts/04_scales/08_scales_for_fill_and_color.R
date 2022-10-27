library(tidyverse)

world_bank_countries <- read_csv("tutorials/ggplot2-fundamentals/data/world_bank_countries.csv")


# color -> discrete variable ----------------------------------------------
world_bank_countries %>% 
  filter(year == 2000) %>%
  ggplot(aes(gdp_per_capita, y = life_expectancy_at_birth,
             color = continent)) +
  geom_point() +
  #scale_color_brewer(type = "div", palette = "RdYlGn")
  #scale_color_viridis_d(option = "magma", begin = .3)
  # scale_color_hue(h = c(20, 200), c = 30)
  scale_color_grey(start = .2)


# fill -> discrete variable ----------------------------------------------
world_bank_countries %>% 
  filter(year %in% c(2000, 2016)) %>% 
  mutate(
    year = year %>% as_factor,
    continent = continent %>% as_factor %>% 
      fct_relevel("Oceania", "Europe", "Asia", "Americas", "Africa")) %>%
  ggplot(aes(x = continent,
             y = overweight,
             fill = year)) + 
  geom_boxplot(width = 0.75, 
               alpha = .8,
               position = position_dodge2(padding = 0.1)) +
  # scale_fill_brewer(type = 'qual', palette = 7)
  # scale_fill_viridis_d(begin = .3)
  # scale_fill_hue(h = c(60, 120), l = 80)
  scale_fill_grey()


# color -> continuous variable --------------------------------------------
world_bank_countries %>% 
  filter(year == 2000) %>%
  ggplot(aes(gdp_per_capita, y = life_expectancy_at_birth,
             color = birth_rate)) +
  geom_point() +
  # scale_color_viridis_c(direction = -1)
  # scale_color_distiller(type = 'div')
  # scale_color_fermenter(type = 'div', n.breaks = 10) # binned
  # scale_color_gradient(low = "steelblue", high = "yellow")
  # scale_color_gradient2(low = "red", mid = "blue", high = "yellow", midpoint = 40)
  # scale_color_gradientn(colors = heat.colors(10))
  scale_color_steps(low = "steelblue", high = "yellow")

# fill -> continuous variable --------------------------------------------
ggplot(faithfuld, aes(waiting, eruptions, 
                      fill = density)) +
  geom_tile() +
  # scale_fill_viridis_c()
  # scale_fill_distiller(type = 'div')
  # scale_fill_fermenter(type = 'div', n.breaks = 10)
  # scale_fill_gradient(low = 'green', high = 'red')
  scale_fill_steps(low = 'green', high = 'red')
