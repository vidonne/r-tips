# Load packages
library(dplyr)
library(tidyr)
library(ggplot2)
library(rnaturalearth)
library(sf)
library(nycflights13)
library(lwgeom)

# Download river and coastlines from natural earth
rivers <- ne_download(scale = 10, type = "rivers_lake_centerlines", category = "physical", returnclass = "sf")
coastline <- ne_download(scale = 10, type = "coastline", category = "physical", returnclass = "sf")

# Map them on Robinson projection
ggplot() +
  geom_sf(data = coastline, color = "#dddddd") +
  geom_sf(data = rivers, color = "#146bcc") +
  coord_sf(crs = "ESRI:54009") +
  theme_minimal() +
  theme(panel.grid = element_blank())


# Connecting dots ---------------------------------------------------------

View(flights)

# Flight only from JFK
flights.jfk <- filter(flights, origin == "JFK")

# Number of flights by connection 
flights.jfk.counted <- group_by(flights.jfk, origin, dest) %>%
  summarise(total = n()) %>%
  mutate(id = paste(origin, "-", dest, sep=""))

# Turn into long format to allow join by airport
flights.jfk.long <- pivot_longer(flights.jfk.counted, cols = 1:2, names_to = "orgdest", values_to = "airport")


# Join with airports to get the coord
flights.jfk.long <- left_join(flights.jfk.long, airports, by = c("airport" = "faa"))


# Filter out NA and Hawaii
flights.jfk.long <- filter(flights.jfk.long, !(id %in% c("JFK-STT", "JFK-SJU", "JFK-PSE", "JFK-BQN", "JFK-HNL")))

# Turn into an sf object
destinations.jfk.sf <- st_as_sf(flights.jfk.long, coords = c("lon", "lat"))

# Print sf object show it's a point geometry type
print(destinations.jfk.sf)

# TRICK group by id so it creates a multipoint geometry type
destinations.jfk.sf.grouped <- group_by(destinations.jfk.sf, id) %>%
  summarise(total = mean(total)) # use the mean to get the actual value

# Print to check group_by worked
print(destinations.jfk.sf.grouped)

# Transform into lines with st_cast()
destinations.sf.lines <- st_cast(destinations.jfk.sf.grouped, "LINESTRING")
st_crs(destinations.sf.lines) <- 4326

# Map it with size as number of flights
ggplot(data = usa.conterm) +
  geom_sf(color = "#ffffff") +
  geom_sf(data = destinations.sf.lines, color = alpha("#D81E90",0.3), aes(size = total)) +
  coord_sf(crs = "ESRI:102003") +
  theme_minimal()

# Add curve to the lines with lwgeom
destinations.sf.arcs <- st_segmentize(destinations.sf.lines, dfMaxLength = 20000)

ggplot(data = usa.conterm) +
  geom_sf(color = "#ffffff") +
  geom_sf(data = destinations.sf.arcs, color = alpha("#D81E90",0.3), aes(size = total)) +
  coord_sf(crs = "ESRI:102003") +
  theme_minimal()

