library(httr)
library(sf)
library(ggplot2)

url <- parse_url("https://services.arcgis.com/P3ePLMYs2RVChkJx/arcgis/rest/services")
url$path <- paste(url$path, "USA_Railroads_1/FeatureServer/0/query", sep = "/")
url$query <- list(
    where = "STATE = 'FL'",
    outFields = "*",
    returnGeometry = "true",
    f = "geojson"
)
request <- build_url(url)

Florida_Railroads <- st_read(request)

ggplot(Florida_Railroads) +
    geom_sf()
