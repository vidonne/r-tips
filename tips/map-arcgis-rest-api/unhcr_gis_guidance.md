### How to build a query on ArcGIS REST API

1. Go to "https://gis.unhcr.org/arcgis/rest/services/core_v2/" click on the FeatureServer of the layer
2. Add "/0/query" at the end of the URL
    Example : "https://gis.unhcr.org/arcgis/rest/services/core_v2/wrl_polbnd_adm1_a_unhcr/FeatureServer/0/query" 

Here, you will have to set, at minimum the following parameters. The examples are for the Admin1 layer but the logic is similar for all:

3. Where (**mandatory**): You need to write a SQL query in it.
    If you’re interested only about the admin1 of a country you can write like below. If you want all the layer you can **write 1=1** (which is a query that returns TRUE for all cases, but please note that if you try to export the whole world for some layers it will not work, too heavy).
    
4. OutField (**mandatory**): Put a star (*) like below to return all the fields of each admin1 (gis_name, pcode, iso3 etc.). If you want only specific fields, list them separated by comas (e.g. pcode,gis_name). You can see the list of fields here, by scrolling down a bit: "https://gis.unhcr.org/arcgis/rest/services/core_v2/wrl_polbnd_adm1_a_unhcr/FeatureServer/0"

5. ReturnGeometry (**optional**): You can tick FALSE if you are only interested about the list of admin1, and not their geometryFormat (this is mandatory). For use with sf **select GeoJSON**.

6. Then click on GET and it will create a (long) URL for the query, example below to export the admin1 of Rwanda, with geometry and with the fields pcode and gis_name: "https://gis.unhcr.org/arcgis/rest/services/core_v2/wrl_polbnd_adm1_a_unhcr/FeatureServer/0/query?where=iso3+%3D+%27RWA%27&objectIds=&time=&geometry=&geometryType=esriGeometryEnvelope&inSR=&spatialRel=esriSpatialRelIntersects&distance=&units=esriSRUnit_Foot&relationParam=&outFields=pcode%2Cgis_name&returnGeometry=true&maxAllowableOffset=&geometryPrecision=&outSR=&havingClause=&gdbVersion=&historicMoment=&returnDistinctValues=false&returnIdsOnly=false&returnCountOnly=false&returnExtentOnly=false&orderByFields=&groupByFieldsForStatistics=&outStatistics=&returnZ=false&returnM=false&multipatchOption=xyFootprint&resultOffset=&resultRecordCount=&returnTrueCurves=false&returnExceededLimitFeatures=false&quantizationParameters=&returnCentroid=false&sqlFormat=none&resultType=&featureEncoding=esriDefault&datumTransformation=&f=geojson".

7. Then you can use **that URL in R**:

```{r}
library(sf)
library(geojsonsf)
library(mapsf)

url_admin1 <- “https://gis.unhcr.org/arcgis/rest/services/core_v2/wrl_polbnd_adm1_a_unhcr/FeatureServer/0/query?where=iso3+%3D+%27RWA%27&objectIds=&time=&geometry=&geometryType=esriGeometryEnvelope&inSR=&spatialRel=esriSpatialRelIntersects&distance=&units=esriSRUnit_Foot&relationParam=&outFields=pcode%2Cgis_name&returnGeometry=true&maxAllowableOffset=&geometryPrecision=&outSR=&havingClause=&gdbVersion=&historicMoment=&returnDistinctValues=false&returnIdsOnly=false&returnCountOnly=false&returnExtentOnly=false&orderByFields=&groupByFieldsForStatistics=&outStatistics=&returnZ=false&returnM=false&multipatchOption=xyFootprint&resultOffset=&resultRecordCount=&returnTrueCurves=false&returnExceededLimitFeatures=false&quantizationParameters=&returnCentroid=false&sqlFormat=none&resultType=&featureEncoding=esriDefault&datumTransformation=&f=geojson”

sf_admin1 <- geojson_sf(url_admin1)
```

Additional parameters in the query builder allow you to do more complex queries like grouping, sorting, simplifying geometry, changing coordinate systems etc. Syntax here: "https://developers.arcgis.com/rest/services-reference/enterprise/query-feature-service-layer-.htm"

And finally, if you need to work on large files (admin1 and admin2 can sometimes be quite heavy as it's a lot of polygons), it might be better to download the geojson file locally to avoid loading times and overloading the API. For this, you can use the Export Tool: "https://im.unhcr.org/geoservices/export/index.html"