library(sf)
library(mapview)
library(tidyverse)

london_sf <- read_sf("data/london_boroughs")

education_data <- read_csv("data/age-when-completed-education.csv")

london_school_leavers_sf <- london_sf %>% 
  left_join(education_data,
            by = c("lad11nm" = "area")) %>% 
  filter(age_group == "16 or under")

london_school_leavers_sf %>% 
  ggplot() +
  geom_sf(aes(fill = value,
              shape = "City of London")) +
  scale_fill_viridis_c(na.value = "pink",
                       name = "Resident who left\nschool at 16 or under",
                       labels = scales::number_format(big.mark = ",")) +
  guides(shape = guide_legend(override.aes = list(fill = "pink",
                                                  color = "transparent"),
                              order = 2, title = NULL),
         fill = guide_colorbar(order = 1))









