# Load packages
library(tidyverse)
library(jsonlite)
library(httr)
library(lubridate)


# Call API and get content ------------------------------------------------

# Setup variables
url <- "https://v4.activityinfo.org/resources/form/ck9bb32t86c/query/rows?_truncate=FALSE"
username <- rstudioapi::askForPassword("ActivityInfo username")
password <- rstudioapi::askForPassword("ActivityInfo password")

# Get API response
get_ai <- GET(url, authenticate(username,password, type = "basic"))

# Transform response to text
get_ai_text <- content(get_ai, "text")

# Transform text response to tibble, select specific columns and change to Date type
ai_dima <- as_tibble(fromJSON(get_ai_text)) %>%
  select(where.iso, where.country, where.region, date_full, territory_border, volrep_ret, xeno_incident) %>%
  mutate(date_full = as.Date(date_full)) %>%
  arrange(desc(date_full))


# Only latest report ------------------------------------------------------

# Filter only latest report by country
ai_dima_latest <- ai_dima %>%
  distinct(where.iso, .keep_all = TRUE)


# Last week report --------------------------------------------------------

# Calculate previous week from system date
previous_week <- isoweek(Sys.Date())-1

# Filter only last week data
ai_dima_lastweek <- ai_dima %>%
  mutate(week = isoweek(date_full)) %>%
  filter(week == previous_week)


# Last EVEN week report ---------------------------------------------------

ai_dima_evenweek <- ai_dima %>%
  mutate(week_num = isoweek(date_full)) %>% # Add week number column
  mutate(week_type = week_num %% 2) %>% # Calculate modulo to differenciate even and odd week
  filter(week_type == 0) %>% # Filter only even week
  filter(week_num == max(week_num)) # Filter max of even week
