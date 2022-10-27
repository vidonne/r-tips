library(tidyverse)

world_bank_countries <- read_csv("data/world_bank_countries.csv")

world_bank_countries %>% 
  filter(year == 2016) %>% 
  ggplot(aes(x = gdp_per_capita,
             y = overweight,
             color = continent,
             size = population_total)) + 
  geom_point() + 
  scale_x_log10() +
  theme(
    legend.box.background = element_rect(fill = "grey90",
                                         color = "pink",
                                         size = 4),
    legend.box = "horizontal",
    legend.box.margin = margin(l = 30),
    legend.background = element_rect(fill = "grey30",
                                     color = "grey60",
                                     size = 2),
    legend.position = "top",
    legend.margin = margin(t = 10),
    legend.direction = "vertical",
    legend.key = element_rect(fill = "transparent",
                              color = "yellow"),
    legend.key.size = unit(1, "cm"), #also can use width and height only
    legend.text = element_text(color = "#0072bc",
                               size = 10),
    legend.title = element_text(color = "black",
                                size = 12,
                                hjust = .5),
  ) +
  # allow to style by aes and not all legends
  guides(
    color = guide_legend(ncol = 2),
    size = guide_legend(ncol = 2)
  )


# Legend components you can change
#   - the box > of multiple legends
#   - the background
#   - the position
#   - the margin
#   - the direction
#   - number of columns
#   - the key
#   - the key_glyph
#   - the text
#   - the title