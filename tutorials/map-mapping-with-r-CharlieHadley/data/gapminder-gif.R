library(gapminder)
library(ggplot2)
library(gganimate)

gg_gapminder <- ggplot(gapminder, aes(gdpPercap, lifeExp, size = pop, colour = country)) +
  geom_point(alpha = 0.7) +
  scale_colour_manual(values = country_colors) +
  scale_size(range = c(2, 12)) +
  scale_x_log10() +
  facet_wrap(~continent) +
  theme(legend.position = 'none') +
  labs(title = 'Year: {frame_time}', x = 'GDP per capita', y = 'life expectancy') +
  transition_time(year) +
  ease_aes('linear')

animate_gapminder <- animate(gg_gapminder, height = 5, width = 5, units = "in", res = 150)

anim_save("gapminder.gif", animate_gapminder, "slides/getting-map-data-into-r/images/")
