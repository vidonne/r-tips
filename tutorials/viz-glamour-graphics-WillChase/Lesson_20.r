# Solution
# using custom fonts is enabled by the ragg package
# install.packages("ragg")

library(tidyverse)
library(ragg)

## Your turn

# Take one of the charts we've made and add your own fonts to it

# I'm using this bar chart
plastics <- readr::read_csv("https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2021/2021-01-26/plastics.csv")

bar_chart <-
  plastics %>%
  group_by(parent_company) %>%
  summarize(total = sum(grand_total, na.rm = TRUE)) %>%
  arrange(desc(total)) %>%
  slice(4:14) %>%
  mutate(parent_company = ifelse(parent_company == "NULL", "Unknown", parent_company)) %>%
  ggplot() +
  geom_col(aes(x = total, y = reorder(parent_company, total)), fill = "orchid4") +
  theme_light() +
  labs(title = "Top brands") +
  theme(
    axis.title = element_blank(), panel.border = element_blank(),
    panel.grid.minor.x = element_blank(),
    panel.grid.major.y = element_blank(),
    plot.title.position = "plot"
  )

# to add the custom font, just specify the name in the family argument
bar_chart +
  theme(
    axis.text = element_text(family = "Loretta"),
    plot.title = element_text(family = "Montserrat")
  )

# Adjust the size or style of your text using theme elements
bar_chart +
  theme(
    axis.text = element_text(family = "Loretta", color = "black", size = 12),
    plot.title = element_text(family = "Montserrat", size = 16, face = "bold")
  )

# Save your chart with the custom fonts
ggsave("my_plot.png", device = agg_png)

# opentype features

library(systemfonts)
register_variant(
  name = "Montserrat Extreme",
  family = "Montserrat",
  weight = "semibold",
  features = font_feature(
    ligatures = "discretionary",
    letters = "stylistic"
  )
)

bar_chart +
  theme(
    axis.text = element_text(family = "Montserrat"),
    plot.title = element_text(family = "Montserrat Extreme", size = 28)
  )
