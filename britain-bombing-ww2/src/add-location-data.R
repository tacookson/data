
### Load packages ---------------------------------------------------------------------------------
library(tidyverse)
library(readxl)
library(janitor)
library(ggmap)

### Load data and clean locations enough for Geocode API lookup -----------------------------------
locations <- read_xlsx("./britain-bombing-ww2/raw/Bombing-Britain-data.xlsx",
                       guess_max = 1e5) %>%
  rename(location = Location,
         country = Country) %>%
  distinct(location, country) %>%
  # Take only first item in composite location descriptions (multiple locations separated by +)
  mutate(location_clean = str_remove(location, " \\+.*")) %>%
  # Combine location and country to make lookup locations as clear as possible
  unite(lookup_location, location_clean, country, sep = ", ", remove = FALSE) %>%
  # Ditch unneeded fields
  select(location, country, lookup_location)


### Set up Google Geocode API and look up coordinates using {ggmap} -------------------------------
### NOTE: this step can cost money $$$ (check Google pricing)

# Register API key
register_google(key = read_file("./britain-bombing-ww2/ref/keys/google-geocoding-api-key.txt"))

# Look up geographic coordinates
geocodes <- locations %>%
  mutate(coord_data = map(lookup_location, geocode)) %>%
  select(-lookup_location) %>%
  unnest(coord_data)


### Write to CSV ----------------------------------------------------------------------------------
write_csv(geocodes, "./britain-bombing-ww2/ref/geocodes.csv")
