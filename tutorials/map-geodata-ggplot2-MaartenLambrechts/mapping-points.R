# Load packages
library(dplyr)
library(tidyr)
library(ggplot2)
library(rnaturalearth)
library(sf)
library(nycflights13)

# Turn point to sf object
airports.sf <- st_as_sf(airports, coords = c("lon", "lat")
                        #,crs = 4326 could add crs here it's better
                        )

# Download wrl adm1 from Natural Earth
world.admin1 <- ne_download(scale = 10, type = "states", category = "cultural", returnclass = "sf")

# Filter the US
united.states <- filter(world.admin1, admin == "United States of America")
usa.conterm <- filter(united.states, name != "Alaska", name != "Hawaii")

map <- ggplot(data = usa.conterm) +
  geom_sf() +
  coord_sf(crs = "ESRI:102003")

map + geom_sf(data = airports.sf)
# airports.sf doesn't have crs

st_crs(airports.sf) <- 4326

map + geom_sf(data = airports.sf)

# Filter the point within the polygons
airports.conterm <- st_join(airports.sf, usa.conterm, join = st_within, left = FALSE)

map + geom_sf(data = airports.conterm)


# Symbols -----------------------------------------------------------------

# Change style of the point by adding size to geom_sf
ggplot(data = usa.conterm) +
  geom_sf(color = "#ffffff") +
  geom_sf(data = airports.conterm,
          aes(size = alt), alpha = 0.3) +
  scale_size_area(max_size = 20) +
  coord_sf(crs = "ESRI:102003") +
  theme_minimal()

# As in ggplot we can add aes as we please
ggplot(data = usa.conterm) +
  geom_sf() +
  geom_sf(data = airports.conterm,
          aes(size = alt,
              color = tzone),
          alpha = 0.3,
          shape = 17) +
  scale_size_area(max_size = 10) +
  coord_sf(crs = "ESRI:102003") +
  theme_minimal()
