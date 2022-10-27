#
# Choropleth maps
#

library(dplyr)
library(ggplot2)
library(sf)

# Load the states and county boundaries
states <- read_sf("data/census_bureau/cb_2013_us_state_20m/cb_2013_us_state_20m.shp")
counties <- read_sf("data/census_bureau/cb_2013_us_county_20m/cb_2013_us_county_20m.shp")

# Load the census data about the foreign born population, and calculate the rate of foreign born population
fb_state <- read.csv("data/census_bureau/ACS_13_5YR_B05012_state/ACS_13_5YR_B05012.csv", stringsAsFactors=FALSE, colClasses=c("GEO.id2"="character"))
fb_state$rate <- fb_state$HD01_VD03 / fb_state$HD01_VD01
fb_county <- read.csv("data/census_bureau/ACS_13_5YR_B05012_county/ACS_13_5YR_B05012.csv", stringsAsFactors=FALSE, colClasses=c("GEO.id2"="character"))
fb_county$rate <- fb_county$HD01_VD03 / fb_county$HD01_VD01

# Join the census data to the geographical data
states <- left_join(states, fb_state, by = c("GEOID" = "GEO.id2")) %>%
  filter(!(GEOID %in% c("02", "15", "72")))
counties <- left_join(counties, fb_county, by = c("GEOID" = "GEO.id2")) %>%
  filter(!(STATEFP %in% c("02", "15", "72")))

# Make the state level choropleth
choro.usa <- ggplot(states, aes(fill = rate)) +
  geom_sf(color = "white", size = 0.1) +
  coord_sf(crs = 102003) +
  theme_minimal()
choro.usa

# Update with county data
choro.usa %+% counties

# Classify the rate values into buckets
counties <- mutate(counties, rate_cat = cut(rate, breaks = c(-0.1, 0.1, 0.2, 0.3, 0.4, 0.5, 1)))
# Use the classified values, and change the colors to a Color Brewer palette
ggplot(counties, aes(fill = rate_cat)) +
  geom_sf(color = "white", size = 0.1) +
  coord_sf(crs = 102003) +
  theme_minimal() +
  scale_fill_brewer(palette = "Blues")

# Clean up the legend
ggplot(counties, aes(fill = rate_cat)) +
  geom_sf(color = "white", size = 0.1) +
  coord_sf(crs = 102003) +
  theme_minimal() +
  scale_fill_brewer(palette = "Blues",
                    name = "Foreign born rate",
                    labels = c("< 10%", "10-20", "20-30", "30-40", "40-50", "> 50%"))

## World choropleth
# Load the world country boundary data
world <- st_read("data/natural_earth/ne_110m_admin_0_countries/ne_110m_admin_0_countries.shp")

# Load the fertility data
fertility <- read.csv("data/API_SP.DYN.TFRT.IN_DS2_en_csv_v2/API_SP.DYN.TFRT.IN_DS2_en_csv_v2.csv", stringsAsFactors=FALSE)

# Join the boundary data and the fertility data, and calculate the bucketed value in one go
world.fertility <- left_join(world, fertility, by = c("iso_a3" = "Country.Code")) %>%
  mutate(fert.class = cut(X2018, breaks = c(0:7)))

# Plot the world choropleth map with the viridis inferno color palette
ggplot(data = world.fertility, aes(fill = X2018)) +
  geom_sf(color = "#ffffff", size = 0.1) +
  scale_fill_viridis_c(direction = -1, option = "inferno") +
  coord_sf(crs = 54009) +
  theme_minimal()

# Plot the chroropleth map with the classed values: change the fill aesthetic and change the color scale to  change scale_fill_viridis_d
world.choro <- ggplot(data = world.fertility, aes(fill = fert.class)) +
  geom_sf(color = "#ffffff", size = 0.1) +
  scale_fill_viridis_d(direction = -1, option = "inferno") +
  coord_sf(crs = 54009) +
  theme_minimal()
world.choro

# Clean up the legend a little bit
world.choro + scale_fill_viridis_d(direction = -1, option = "inferno",
                                   name = "Fertility rate",
                                   labels = c("<1", "1-2", "2-3", "3-4", "4-5", "5-6", ">6", "Missing data"),
                                   na.value = "#dddddd")
