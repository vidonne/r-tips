## Your turn
library(tidyverse)

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

pie_chart <-
  plastics %>%
  group_by(year) %>%
  summarize(total = sum(grand_total, na.rm = TRUE)) %>%
  ggplot() +
  geom_bar(aes(x = "", y = total, fill = as.character(year)), stat = "identity", width = 1) +
  coord_polar("y", start = 0) +
  theme_minimal() +
  labs(title = "Plastic pollution by year", fill = "") +
  theme(
    axis.title = element_blank(), panel.grid = element_blank(),
    axis.text = element_blank()
  )

bar_chart_2 <-
  plastics %>%
  select(hdpe:pvc) %>%
  pivot_longer(cols = 1:7) %>%
  group_by(name) %>%
  summarize(total = sum(value, na.rm = TRUE)) %>%
  ggplot() +
  geom_col(aes(x = total, y = reorder(name, total)), fill = "goldenrod") +
  theme_light() +
  labs(title = "By plastic type") +
  theme(
    axis.title = element_blank(), panel.border = element_blank(),
    panel.grid.minor.x = element_blank(),
    panel.grid.major.y = element_blank(),
    plot.title.position = "plot"
  )

## Solution

library(tidyverse)
library(patchwork)

# Solutions
# Using charts in plastic_charts.R

# Create a patchwork with one chart in a lefthand column
# spanning two vertical rows, and two charts in a second column
# stacked on top of each other
patchwork <- bar_chart | (bar_chart_2 / pie_chart)


# Take the patchwork you just created, and add a title, subtitle, and figure labels
patchwork + plot_annotation(
  title = "Plastic pollution",
  subtitle = "According to beach cleanups",
  tag_levels = "A"
)

# Make the figure labels read "Fig. 1, Fig. 2, Fig. 3"
patchwork + plot_annotation(
  title = "Plastic pollution",
  subtitle = "According to beach cleanups",
  tag_levels = c(1),
  tag_prefix = "Fig. "
)

# Use theme options to make the figure labels a little smaller
patchwork + plot_annotation(
  title = "Plastic pollution",
  subtitle = "According to beach cleanups",
  tag_levels = c(1),
  tag_prefix = "Fig. "
) &
  theme(plot.tag = element_text(size = 10))
