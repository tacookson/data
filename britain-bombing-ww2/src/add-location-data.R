
### Load packages ---------------------------------------------------------------------------------
library(tidyverse)
library(readxl)
library(janitor)
library(ggmap)

### Load data and clean locations enough for Geocode API lookup -----------------------------------
bombings_raw <- read_xlsx("./britain-bombing-ww2/raw/Bombing-Britain-data.xlsx", guess_max = 1e5)

locations <- bombings_raw %>%
  rename(location = Location,
         country = Country) %>%
  distinct(location, country) %>%
  # Take only first item in composite location descriptions (multiple locations separated by +)
  mutate(location_clean = str_remove(location, " \\+.*")) %>%
  # Combine location and country to make lookup locations as clear as possible
  mutate(lookup_location = paste0(location_clean, ", ", country)) %>%
  # Ditch unneeded fields
  select(-country, -location_clean)


### Set up Google Geocode API and look up coordinates using {ggmap} -------------------------------
### NOTE: this step costs money $$$

# Register API key
register_google(key = read_file("./britain-bombing-ww2/ref/keys/google-geocoding-api-key.txt"))

# Look up geographic coordinates
geocodes_raw <- locations %>%
  mutate(coord_data = map(lookup_location, geocode))

# Clean coordinate dataset
geocodes <- geocodes_raw %>%
  unnest(coord_data)


### Write to CSV ----------------------------------------------------------------------------------
write_csv(geocodes, "./britain-bombing-ww2/geocodes.csv")
