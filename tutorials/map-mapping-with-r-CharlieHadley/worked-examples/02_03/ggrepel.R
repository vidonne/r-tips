library(fivethirtyeight)
library(tidyverse)
library(ggrepel)


bechdel %>% 
  filter(year == max(year)) %>% 
  ggplot(aes(x = budget_2013,
             y = domgross_2013)) +
  geom_point() +
  geom_label_repel(aes(label = title))
