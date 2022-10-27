##### UPDATE
##### ggbraid package https://nsgrantham.github.io/ggbraid/

# Thanks to https://www.nsgrantham.com/fill-between-two-lines-ggplot2

# load library
library(tidyverse)

# create fake data
df <- tibble(
  x = c(1:6, 1:6),
  y = c(1, 5, 6, 4, 1, 1, 1, 4, 5, 4, 2, 2),
  f = c(rep("a", 6), rep("b", 6))
)

df

# plot data as line
ggplot(df) +
  geom_line(aes(x, y, linetype = f)) +
  guides(linetype = "none")

# create the ribbon bounds
bounds <- df %>%
  pivot_wider(names_from = f, values_from = y) %>%
  mutate(
    ymax = pmax(a, b),
    ymin = pmin(a, b),
    fill = a >= b
  )

bounds

# plot with ribbon using bounds
ggplot(df) +
  geom_line(aes(x, y, linetype = f)) +
  geom_ribbon(data = bounds, aes(x, ymin = ymin, ymax = ymax, fill = fill), alpha = 0.4) +
  guides(linetype = "none", fill = "none") +
  labs(x = NULL, y = NULL)
# not the expected result as there is nothing for bound between 4 and 5

# add an extra row in bounds to have the area start accordingly
bounds2 <- bind_rows(
  bounds,
  tibble(x = 4, a = 4, b = 4, ymax = 4, ymin = 4, fill = FALSE)
) %>%
  arrange(x)

bounds2


# plot with bounds2
ggplot(df) +
  geom_line(aes(x, y, linetype = f)) +
  geom_ribbon(data = bounds2, aes(x, ymin = ymin, ymax = ymax, fill = fill), alpha = 0.4) +
  guides(linetype = "none", fill = "none") +
  labs(x = NULL, y = NULL)
