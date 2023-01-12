library(tidyverse)
library(ggtext)

## Your turn

# Use ggtext to make the word 'plastic' bold in the title
# and wrap the subtitle so it is multi-line

plastics <- readr::read_csv("https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2021/2021-01-26/plastics.csv")

plastics %>%
  group_by(year) %>%
  summarize(total = sum(grand_total, na.rm = TRUE)) %>%
  ggplot() +
  geom_bar(aes(x = "", y = total, fill = as.character(year)), stat = "identity", width = 1) +
  coord_polar("y", start = 0) +
  theme_minimal() +
  labs(
    title = "Plastic pollution, by year", fill = "",
    subtitle = "This is a really really really long subtitle that has tons of detail about your methods and data and even more info beyond that"
  ) +
  theme(
    axis.title = element_blank(), panel.grid = element_blank(),
    axis.text = element_blank()
  )


## Solution

# Use ggtext to make the word 'plastic' bold in the title
# and wrap the subtitle so it is multi-line

plastics <- readr::read_csv("https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2021/2021-01-26/plastics.csv")

plastics %>%
  group_by(year) %>%
  summarize(total = sum(grand_total, na.rm = TRUE)) %>%
  ggplot() +
  geom_bar(aes(x = "", y = total, fill = as.character(year)), stat = "identity", width = 1) +
  coord_polar("y", start = 0) +
  theme_minimal() +
  labs(
    title = "<b>Plastic pollution</b>, by year", fill = "",
    subtitle = "This is a really really really long subtitle that has tons of detail about your methods and data and even more info beyond that"
  ) +
  theme(
    axis.title = element_blank(), panel.grid = element_blank(),
    axis.text = element_blank(),
    plot.title = element_textbox_simple(margin = margin(0, 0, 15, 0)),
    plot.subtitle = element_textbox_simple(lineheight = 1.2)
  )
