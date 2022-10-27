# Load packages 
library(dplyr)
library(tidyr)
library(ggplot2)
library(rnaturalearth)
library(sf)



# Preparing the data ------------------------------------------------------

# Load data with read_sf
states <- read_sf("data/census_bureau/cb_2013_us_state_20m/cb_2013_us_state_20m.shp")
counties <- read_sf("data/census_bureau/cb_2013_us_county_20m/cb_2013_us_county_20m.shp")

# Check CRS
st_crs(states)

# Load state level data
fb_state <- read.csv("data/census_bureau/ACS_13_5YR_B05012_state/ACS_13_5YR_B05012.csv", stringsAsFactors=FALSE, colClasses=c("GEO.id2"="character"))

# Calculate rate of foreign born
fb_state$rate <- fb_state$HD01_VD03 / fb_state$HD01_VD01

# Same with county data
fb_county <- read.csv("data/census_bureau/ACS_13_5YR_B05012_county/ACS_13_5YR_B05012.csv", stringsAsFactors=FALSE, colClasses=c("GEO.id2"="character"))
fb_county$rate <- fb_county$HD01_VD03 / fb_county$HD01_VD01

# Join fb with geo data, filter non continental states
states <- left_join(states, fb_state, by = c("GEOID" = "GEO.id2")) %>%
  filter(!(GEOID %in% c("02", "15", "72")))
counties <- left_join(counties, fb_county, by = c("GEOID" = "GEO.id2")) %>%
  filter(!(STATEFP %in% c("02", "15", "72")))


# Drawing the map ---------------------------------------------------------

# State level
choro.usa <- ggplot(states, aes(fill = rate)) +
  geom_sf(color = "white", size = 0.1) +
  coord_sf(crs = "ESRI:102003") +
  theme_minimal()
choro.usa

# County level
choro.usa %+% counties

# Calculate bin with cut()
counties <- mutate(counties, rate_cat = cut(rate, breaks = c(-0.1, 0.1, 0.2, 0.3, 0.4, 0.5, 1)))

# Map with the new categories and color brewer
ggplot(counties, aes(fill = rate_cat)) +
  geom_sf(color = "white", size = 0.1) +
  coord_sf(crs = "ESRI:102003") +
  theme_minimal() +
  scale_fill_brewer(palette = "Blues")

# Improve map legend
ggplot(counties, aes(fill = rate_cat)) +
  geom_sf(color = "white", size = 0.1) +
  coord_sf(crs = "ESRI:102003") +
  theme_minimal() +
  scale_fill_brewer(palette = "Blues",
                    name = "Foreign born rate",
                    labels = c("< 10%", "10-20", "20-30", "30-40", "40-50", "> 50%"))


# Applying workflow to the world ------------------------------------------

# Load world shp
world <- st_read("data/natural_earth/ne_110m_admin_0_countries/ne_110m_admin_0_countries.shp")

# Load WB data of fertility rate
fertility <- read.csv("data/API_SP.DYN.TFRT.IN_DS2_en_csv_v2/API_SP.DYN.TFRT.IN_DS2_en_csv_v2.csv", stringsAsFactors=FALSE)

# Join 2 datasets
world.fertility <- left_join(world, fertility, by = c("iso_a3" = "Country.Code")) %>%
  mutate(fert.class = cut(X2018, breaks = c(0:7)))

# Map it with viridis continuous
ggplot(data = world.fertility, aes(fill = X2018)) +
  geom_sf(color = "#ffffff", size = 0.1) +
  scale_fill_viridis_c(direction = -1, option = "inferno") +
  coord_sf(crs = "ESRI:54009") +
  theme_minimal()

# Change to viridis discrete
world.choro <- ggplot(data = world.fertility, aes(fill = fert.class)) +
  geom_sf(color = "#ffffff", size = 0.1) +
  scale_fill_viridis_d(direction = -1, option = "inferno") +
  coord_sf(crs = "ESRI:54009") +
  theme_minimal()
world.choro

# Fix missing countries and legend
world.choro + scale_fill_viridis_d(direction = -1, option = "inferno",
                                   name = "Fertility rate",
                                   labels = c("<2", "2-3", "3-4", "4-5", "5-6", ">6", "Missing data"),
                                   na.value = "#dddddd")
