## Your turn
library(tidyverse)

# plastic pollution dataset
plastics <- readr::read_csv("https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2021/2021-01-26/plastics.csv")

# Take a plot you made with the plastic pollution dataset (it doesn't need to be a scatter plot)
# And apply the principles you learned about for axes, grids, borders, etc.
# If you don't want to use your own plot, you can use this one...

# wrangle data
data <- plastics %>%
  group_by(parent_company) %>%
  summarize(total = sum(grand_total, na.rm = TRUE)) %>%
  arrange(desc(total)) %>%
  slice(4:14) %>%
  mutate(parent_company = ifelse(parent_company == "NULL", "Unknown",
    parent_company
  ))
# example starting plot
ggplot(data) +
  geom_col(aes(x = total, y = reorder(parent_company, total)), fill = "orchid4")


# now apply your styling of the grids, axes, borders, and backgrounds

## Solution
library(tidyverse)

# plastic pollution dataset
plastics <- readr::read_csv("https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2021/2021-01-26/plastics.csv")

# wrangle data
data <- plastics %>%
  group_by(parent_company) %>%
  summarize(total = sum(grand_total, na.rm = TRUE)) %>%
  arrange(desc(total)) %>%
  slice(4:14) %>%
  mutate(parent_company = ifelse(parent_company == "NULL", "Unknown",
    parent_company
  ))

# how I did it
ggplot(data) +
  geom_col(aes(x = total, y = reorder(parent_company, total)), fill = "orchid4") +
  labs(title = "Plastic items collected on beaches, by manufacturer") +
  scale_x_continuous(labels = scales::label_comma()) +
  theme(
    axis.title = element_blank(),
    panel.background = element_blank(),
    panel.grid.major.y = element_blank(),
    panel.grid.minor.y = element_blank(),
    axis.ticks.y = element_blank(),
    panel.grid.minor.x = element_blank(),
    panel.grid.major = element_line(color = "#e7e7e7", size = 0.4),
    axis.ticks = element_line(color = "#e7e7e7", size = 0.4)
  )

# add arrows to axis line
# axis.line = element_line(arrow = arrow(length = unit(2, "mm")))
