
### Load packages ---------------------------------------------------------------------------------
library(tidyverse)
library(readxl)
library(janitor)


### Load data and geocodes ------------------------------------------------------------------------
bombings_raw <- read_xlsx("./britain-bombing-ww2/raw/Bombing-Britain-data.xlsx",
                          guess_max = 1e5,
                          na = c("", "N/A"))

geocodes <- read_csv("./britain-bombing-ww2/ref/geocodes.csv")


### Clean data ------------------------------------------------------------------------------------
bombings_clean <- bombings_raw %>%
  clean_names() %>%
  # Add geographic coordinates (latitude and longitude)
  left_join(geocodes, by = c("location", "country")) %>%
  # Convert Excel dates to R date format
  mutate(across(start_date:end_date, ~ excel_numeric_to_date(parse_number(.)))) %>%
  # Parse numbers from casualty fields (they sometimes have values like "a few" or "unspecified")
  mutate(across(killed:total_casualties, parse_number)) %>%
  # Convert coordinates in the United States (clearly wrong) into missing values
  mutate(lon = ifelse(lon < -25, NA, lon),
         lat = ifelse(lon < -25, NA, lat)) %>%
  # Add id field
  mutate(bombing_id = row_number()) %>%
  # Get rid of unnecessary fields
  select(-volume_reference, -intelligence_summary_number, -link_to_page) %>%
  # Re-order fields to be easier to work with
  select(bombing_id, civil_defence_region, country, location,
         lon, lat, start_date:time, killed:additional_notes)


### Identify duplicate casualty records -----------------------------------------------------------
# Identify duplicated casualty figures that are part of aggregations
# We will create "casualty groups" that tick up by one when we conclude that the casualty data is not duplicated
# This way, duplicated casualty figures will have the same "casualty group" ID, which we can use to prevent double-counting
bombings_geocoded <- bombings_clean %>%
  # The first row where one of these fields is different means a new casualty group
  group_by(civil_defence_region, start_date, end_date, time, killed, injured, total_casualties) %>%
  mutate(first_row = row_number() == 1) %>%
  ungroup() %>%
  # New casualty group when additional_notes fields doesn't include "Total" or "Entire", which are markers of aggregation
  mutate(no_aggregation_noted = str_detect(additional_notes, "[Tt]otal", negate = TRUE) &
           str_detect(additional_notes, "[Ee]ntire", negate = TRUE)) %>%
  # Create ID for casualty group when the above is true or additional_notes is blank
  mutate(casualty_group = cumsum(first_row | no_aggregation_noted | is.na(additional_notes))) %>%
  # Get rid of helper fields
  select(-first_row, -no_aggregation_noted)


### Separate into bombings dataset and casualties dataset -----------------------------------------
bombings <- bombings_geocoded %>%
  select(-killed:-total_casualties)

casualties <- bombings_geocoded %>%
  distinct(casualty_group, killed, injured, total_casualties) %>%
  select(casualty_group, everything())


### Write to CSV ----------------------------------------------------------------------------------
write_csv(bombings, "./britain-bombing-ww2/bombings.csv")

write_csv(casualties, "./britain-bombing-ww2/casualties.csv")
