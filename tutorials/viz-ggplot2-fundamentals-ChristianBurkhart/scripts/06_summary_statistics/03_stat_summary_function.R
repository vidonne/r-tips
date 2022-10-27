library(tidyverse)

world_bank_countries <- read_csv("data/world_bank_countries.csv")


# Measures of center -------------------------------------------------------
world_bank_countries %>% 
  ggplot(aes(x = year, y = gdp_per_capita)) +
  stat_summary(
    geom = "line", # Always need a geom
    fun = "mean",
    color = "blue", # Can any aes from the geom to it
    alpha = .4
  )


# Measures of center and/or spread explicitly -----------------------------
world_bank_countries %>% 
  ggplot(aes(x = year, y = gdp_per_capita)) +
  stat_summary( # can layer multiple stat_summary
    geom = "errorbar", # could be ribbon or other
    fun = "mean",
    fun.min = "min", # lower bound of geom
    fun.max = "max", # upper bound of geom
    alpha = .4
  ) +
  stat_summary( 
    geom = "line",
    fun = "mean"
  ) +
  facet_wrap(~ continent) # You can add facet to stat_summary


# Measures of center and/or spread with a function ------------------------
world_bank_countries %>% 
  ggplot(aes(x = year, y = gdp_per_capita)) +
  stat_summary(
    geom = "pointrange",
    fun.data = "mean_sdl", # use fun.data instead of min and max see cheat sheet for different options from hmisc package
    fun.args = list(mult = 1) # set arg to the stat function
  )

