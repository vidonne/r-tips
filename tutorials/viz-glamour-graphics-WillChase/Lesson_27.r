library(tidyverse)

# if not installed, install the colorspace package
# install.packages("colorspace")
library(colorspace)

# Your turn

# This is some data for a line chart
air <-
  airquality %>%
  filter(Month == 5) %>%
  select(Temp, Ozone, Wind, Day) %>%
  pivot_longer(cols = 1:3)

# take this chart, and change the color of the lines
# using a qualitative HCL color palette
ggplot(air) +
  geom_line(aes(x = Day, y = value, color = name)) +
  theme_minimal()


# take this plot and adjust the colors so that
# the bubbles are on a sequential scale using an HCL palette
ggplot(mtcars) +
  geom_point(aes(x = wt, y = hp, color = mpg), size = 4, alpha = 0.8) +
  theme_minimal()


# generate some dummy data
x <- LETTERS[1:20]
y <- paste0("var", seq(1, 20))
data <- expand.grid(X = x, Y = y)
data$Z <- runif(400, -5, 5)

# adjust this heatmap so that the colors
# are a diverging scale using an HCL palette
ggplot(data, aes(X, Y, fill = Z)) +
  geom_tile()

# if not installed, install the colorspace package
# install.packages("colorspace")
library(colorspace)

# Your turn

# This is some data for a line chart
air <-
  airquality %>%
  filter(Month == 5) %>%
  select(Temp, Ozone, Wind, Day) %>%
  pivot_longer(cols = 1:3)

# take this chart, and change the color of the lines
# using a qualitative HCL color palette
ggplot(air) +
  geom_line(aes(x = Day, y = value, color = name)) +
  scale_fill_discrete_qualitative(palette = "Set 2") +
  theme_minimal()


# take this plot and adjust the colors so that
# the bubbles are on a sequential scale using an HCL palette
ggplot(mtcars) +
  geom_point(aes(x = wt, y = hp, color = mpg), size = 4, alpha = 0.8) +
  scale_fill_continuous_sequential(palette = "Viridis") +
  theme_minimal()


# generate some dummy data
x <- LETTERS[1:20]
y <- paste0("var", seq(1, 20))
data <- expand.grid(X = x, Y = y)
data$Z <- runif(400, -5, 5)

# adjust this heatmap so that the colors
# are a diverging scale using an HCL palette
ggplot(data, aes(X, Y, fill = Z)) +
  geom_tile() +
  scale_fill_continuous_diverging(palette = "Tropic")
