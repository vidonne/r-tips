# Load packages
library(sf)
library(geojsonsf)
library(mapsf)

url_bg <- "https://gis.unhcr.org/arcgis/rest/services/core_v2/wrl_polbnd_int_15m_a_unhcr/FeatureServer/0/query?where=iso3+%3C%3E+%27ATA%27&objectIds=&time=&geometry=&geometryType=esriGeometryEnvelope&inSR=&spatialRel=esriSpatialRelIntersects&distance=&units=esriSRUnit_Foot&relationParam=&outFields=*&returnGeometry=true&maxAllowableOffset=&geometryPrecision=2&outSR=4326&havingClause=&gdbVersion=&historicMoment=&returnDistinctValues=false&returnIdsOnly=false&returnCountOnly=false&returnExtentOnly=false&orderByFields=&groupByFieldsForStatistics=&outStatistics=&returnZ=false&returnM=false&multipatchOption=xyFootprint&resultOffset=&resultRecordCount=&returnTrueCurves=false&returnExceededLimitFeatures=false&quantizationParameters=&returnCentroid=false&sqlFormat=none&resultType=&featureEncoding=esriDefault&datumTransformation=&f=geojson"
url_borders <- "https://gis.unhcr.org/arcgis/rest/services/core_v2/wrl_polbnd_int_15m_l_unhcr/FeatureServer/0/query?where=1%3D1&objectIds=&time=&geometry=&geometryType=esriGeometryEnvelope&inSR=&spatialRel=esriSpatialRelIntersects&distance=&units=esriSRUnit_Foot&relationParam=&outFields=type_unhcr&returnGeometry=true&maxAllowableOffset=&geometryPrecision=2&outSR=4326&havingClause=&gdbVersion=&historicMoment=&returnDistinctValues=false&returnIdsOnly=false&returnCountOnly=false&returnExtentOnly=false&orderByFields=&groupByFieldsForStatistics=&outStatistics=&returnZ=false&returnM=false&multipatchOption=xyFootprint&resultOffset=&resultRecordCount=&returnTrueCurves=false&returnExceededLimitFeatures=false&quantizationParameters=&returnCentroid=false&sqlFormat=none&resultType=&featureEncoding=esriDefault&datumTransformation=&f=geojson"

#set projection here

proj = '+proj=bertin1953'   
# or try :
#proj = '+proj=robin +lon_0=0 +x_0=0 +y_0=0 +datum=WGS84 +units=m +no_defs'

sf_bg <- geojson_sf(url_bg) %>% sf::st_transform(., proj) 
sf_borders <- geojson_sf(url_borders) %>% sf::st_transform(., proj) 
head(sf_bg)
head(sf_borders)

target <- sf_bg

mf_init(target)

mf_map(sf_bg,
       bg = "#000000", #background of map (sea blue)
       col = "#ffffff", #color of polygons (white)
       border = "#ffffff", 
       lwd = 0.01, 
       add = TRUE
)

mf_base(sf_borders,
        col = "#aaaaaa", #color of borders
        add = TRUE)

mf_title( txt = "WORLD", #title text
          bg = "#0072BC",   #background of header (UNHCR blue)
          fg = "#ffffff",   #color of title text (white)
          pos = "left",
)

mf_arrow(col = "#000000")

mf_credits(txt = "The boundaries and names shown on this map do not imply official
endorsement or acceptance by the United Nations.", bg = "#ffffff", col = "#000000") 