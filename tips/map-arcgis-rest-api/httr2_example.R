# Load package
library(httr2)
library(tidyverse)
library(sf)

# URLs and query parameters
base_url <- "https://gis.unhcr.org/arcgis/rest/services/core_v2"
layer_url <- "wrl_regional_bureaux_a_unhcr" # Actual layer
server_type <- "FeatureServer" # FeatureServer or MapServer

# Parse URL and build query
url <- httr2::url_parse(base_url)
url$path <- paste(url$path, layer_url, server_type, "0/query", sep = "/")
url$query <- list(
    where = "1=1",
    outFields = "*",
    returnGeometry = "true",
    f = "geojson"
)
url

# Build URL and request
request <- httr2::url_build(url)

# Read request and create sf
wrl_bureau <- sf::st_read(request)
glimpse(wrl_bureau)

# Map to test result
ggplot(wrl_bureau) +
    geom_sf()




