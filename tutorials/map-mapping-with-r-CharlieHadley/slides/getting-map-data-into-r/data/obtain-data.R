library("tidyverse")
library("sf")
library("tidycensus")
library("mapview")
library("rmapshaper")

## === UK Regions ====
download.file("https://opendata.arcgis.com/datasets/1d78d47c87df4212b79fe2323aae8e08_0.zip?outSR=%7B%22latestWkid%22%3A27700%2C%22wkid%22%3A27700%7D",
              "slides/getting-map-data-into-r/data/uk_local-authority.zip")

download.file("https://opendata.arcgis.com/datasets/5ce27b980ffb43c39b012c2ebeab92c0_2.zip?outSR=%7B%22wkid%22%3A27700%2C%22latestWkid%22%3A27700%7D",
              "slides/getting-map-data-into-r/data/uk_constituencies.zip")

unzip("slides/getting-map-data-into-r/data/uk_local-authority.zip",
      exdir = "slides/getting-map-data-into-r/data/uk_local-authority")

unzip("slides/getting-map-data-into-r/data/uk_constituencies.zip",
      exdir = "slides/getting-map-data-into-r/data/uk_consituencies")

vec_london_boroughs <- c("City of London", "Camden", "Greenwich", "Hackney", "Hammersmith", "Hammersmith and Fulham" , "Islington", "Kensington and Chelsea", "Lambeth", "Lewisham", "Southwark", "Tower Hamlets", "Wandsworth", "Westminster", "Barking and Dagenham", "Barnet", "Bexley", "Brent", "Bromley", "Croydon", "Ealing", "Enfield", "Haringey", "Harrow", "Havering", "Hillingdon", "Hounslow", "Kingston upon Thames", "Merton", "Newham", "Redbridge", "Richmond upon Thames", "Sutton", "Waltham Forest")

vec_london_constituencies <- c("Battersea", "Barking", "Beckenham", "Bermondsey and Old Southwark", "Bethnal Green and Bow", 
                               "Bexleyheath and Crayford", "Brent Central", "Brent North", "Brentford and Isleworth", 
                               "Bromley and Chislehurst", "Camberwell and Peckham", "Carshalton and Wallington", 
                               "Chelsea and Fulham", "Chingford and Woodford Green", "Chipping Barnet", 
                               "Cities of London and Westminster", "Croydon Central", "Croydon North", 
                               "Croydon South", "Dagenham and Rainham", "Dulwich and West Norwood", 
                               "Ealing Central and Acton", "Ealing North", "Ealing, Southall", 
                               "East Ham", "Edmonton", "Eltham", "Enfield North", "Enfield, Southgate", 
                               "Erith and Thamesmead", "Feltham and Heston", "Finchley and Golders Green", 
                               "Greenwich and Woolwich", "Hackney North and Stoke Newington", 
                               "Hackney South and Shoreditch", "Hammersmith", "Hampstead and Kilburn", 
                               "Harrow East", "Harrow West", "Hayes and Harlington", "Hendon", 
                               "Holborn and St. Pancras", "Hornchurch and Upminster", "Hornsey and Wood Green", 
                               "Ilford North", "Ilford South", "Islington North", "Islington South and Finsbury", 
                               "Kensington", "Kingston and Surbiton", "Lewisham Deptford", "Lewisham East", 
                               "Lewisham West and Penge", "Lewisham, Deptford", "Leyton and Wanstead", "Mitcham and Morden", 
                               "Old Bexley and Sidcup", "Orpington", "Poplar and Limehouse", 
                               "Putney", "Richmond Park", "Romford", "Ruislip, Northwood and Pinner", 
                               "Streatham", "Sutton and Cheam", "Tooting", "Tottenham", "Twickenham", 
                               "Uxbridge and South Ruislip", "Vauxhall", "Walthamstow", "West Ham", 
                               "Westminster North", "Wimbledon")

london_boroughs_sf <- read_sf("slides/getting-map-data-into-r/data/uk_local-authority") %>%
  filter(lad19nm %in% vec_london_boroughs) %>% 
  ms_simplify()

london_constituencies_sf <- read_sf("slides/getting-map-data-into-r/data/uk_consituencies") %>% 
  filter(pcon17nm %in% vec_london_constituencies)

london_boroughs_sf %>% 
  write_sf("slides/getting-map-data-into-r/data/london_boroughs.geojson")

london_constituencies_sf %>% 
  write_sf("slides/getting-map-data-into-r/data/london_constituencies.geojson")

wales_local_authority <- read_sf("slides/getting-map-data-into-r/data/uk_local-authority") %>% 
  filter(str_starts(lad19cd, "W")) %>% 
  ms_simplify()

wales_constituencies <- read_sf("slides/getting-map-data-into-r/data/uk_consituencies") %>% 
  filter(str_starts(pcon17cd, "W")) %>% 
  ms_simplify()

wales_constituencies %>% 
  write_sf("slides/getting-map-data-into-r/data/wales_constituencies.geojson")

wales_local_authority %>% 
  write_sf("slides/getting-map-data-into-r/data/wales_local_authority.geojson")

unlink("slides/getting-map-data-into-r/data/uk_constituencies.zip")
unlink("slides/getting-map-data-into-r/data/uk_local-authority.zip")
unlink("slides/getting-map-data-into-r/data/uk_local-authority", recursive = TRUE)
unlink("slides/getting-map-data-into-r/data/uk_consituencies", recursive = TRUE)








## === US Congressional Districts ====
us_cd_20m <- congressional_districts(resolution = "20m", cb = TRUE)

vars_census_2010 <- load_variables(2010, dataset = "sf1")

tenure_vars <- vars_census_2010 %>% 
  filter(concept == "TENURE",
         label != "Total")

us_cd_20m %>%
  ms_simplify() %>%
  write_sf("slides/getting-map-data-into-r/data/us-congressional-districts/us-congressional-districts.shp")

tenure_cd_census_2010 <- get_decennial(geography = "congressional district", variables = c("H004002", "H004003", "H004004"), 
                                       year = 2010,
                                       summary_var = "P001001", 
                                       cache = FALSE)

tenure_cd_census_2010 <- tenure_cd_census_2010 %>%
  pivot_wider(names_from = variable,
              values_from = value) %>%
  rename(mortgage_or_loan = H004002,
         owned_outright = H004003,
         rented = H004004) %>%
  mutate(rented_fraction = rented / {mortgage_or_loan + owned_outright + rented})

tenure_cd_census_2010 %>%
  write_csv("slides/getting-map-data-into-r/data/tenure_cd_census_2010.csv")

age_cd_census_2010 <- get_decennial(geography = "congressional district", variables = c("H017013", "H017014", "H017015", "H017016", "H017017", "H017018", 
                                                                                        "H017019", "H017020", "H017021"), 
                                    year = 2010)

age_cd_census_2010 <- age_cd_census_2010 %>%
  pivot_wider(names_from = variable) %>%
  rename(age_15_to_24 = H017013,
         age_25_to_34 = H017014,
         age_35_to_44 = H017015,
         age_45_to_54 = H017016,
         age_55_to_59 = H017017,
         age_60_to_64 = H017018,
         age_65_to_74 = H017019,
         age_75_to_85 = H017020,
         age_85_plus = H017021)

age_cd_census_2010 %>%
  write_csv("slides/getting-map-data-into-r/data/age_cd_census_2010.csv")
