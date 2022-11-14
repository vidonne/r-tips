library(httr)
library(jsonlite)
library(dplyr)

unhcr_api <- function(path) {
  url <- modify_url("https://api.unhcr.org/population/v1", path = path)
  GET(url)
}

resp <- unhcr_api("/population/")
resp

unhcr_api <- function(path) {
  url <- modify_url("https://api.unhcr.org/population/v1", path = path)
  
  resp <- GET(url)
  if (http_type(resp) != "application/json") {
    stop("API did not return json", call. = FALSE)
  }
  
  parsed <- jsonlite::fromJSON(content(resp, "text"), simplifyVector = FALSE)
  
  structure(
    list(
      content = parsed,
      path = path,
      response = resp
    ),
    class = "unhcr_api"
  )
}

print.unhcr_api <- function(x, ...) {
  cat("<UNHCR ", x$path, ">\n", sep = "")
  str(x$content)
  invisible(x)
}

unhcr_api("/population/")


link <- "https://api.unhcr.org/population/v1/population/?limit=50"
raw_result <- httr::GET(link)

str(raw_result)
str(raw_result$content)

result <- httr::content(raw_result, as = "text")
str(result)

result_from_json <- jsonlite::fromJSON(result)
dplyr::glimpse(result_from_json)

items_df <- result_from_json$items
dplyr::glimpse(items_df)


base_url <- "https://api.unhcr.org/population/v1/population/"

afg_raw <- GET(base_url, 
               query = list(limit = 8000,
                            yearFrom = 1951,
                            yearTo = 2020,
                            coa_all = TRUE)) 
afg_parsed <- content(afg_raw, as = 'text') %>%
  fromJSON()

afg_items <- afg_parsed$items
