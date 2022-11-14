# Github page
https://github.com/R-ArcGIS


# Basic R-Bridge installation ---------------------------------------------

# Install package
install.packages("arcgisbinding", repos = "http://r-arcgis.github.io/r-bridge", type = "win.binary", quiet = TRUE)

# Load package and check ArcGIS license
library(arcgisbinding)
arc.check_product()

# How to update the package
update.packages(repos = "http://r-arcgis.github.io/r-bridge", type = "win.binary")


# Demo UC 2020 ------------------------------------------------------------

### Check/load required packages
if(!requireNamespace("argisbinding", quietly = TRUE))
  install.packages("arcgisbinding", repos = "http://r-arcgis.github.io/r-bridge", type = "win.binary", quiet = TRUE)
if(!requireNamespace("R0", quietly = TRUE))
  install.packages("R0", quiet = TRUE)
if(!requireNamespace("data.table", quietly = TRUE))
  install.packages("data.table", quiet = TRUE)

require(arcgisbinding)
arc.check_product()
require(R0, quietly = TRUE)
require(data.table, quietly = TRUE)

setwd("Path to Geodatabase")

### Read data
# Create string to select NY easily
state <- "New York"
selection <- paste0("ST_NAME = '", state, "'")
selection

# Call feature service data
covid_us <- arc.open("https://services1.arcgis.com/0MSEUqKaxRlEPj5g/arcgis/rest/services/ncov_cases_US/FeatureServer")
# Select only New York
covid_ny <- arc.select(covid_us, where_clause = selection)

### Write data
arc.write()
