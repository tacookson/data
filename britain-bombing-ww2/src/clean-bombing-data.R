
### Load packages ---------------------------------------------------------------------------------
library(tidyverse)
library(readxl)
library(janitor)


### Load data and geocodes ------------------------------------------------------------------------
bombings_raw <- read_xlsx("./britain-bombing-ww2/raw/Bombing-Britain-data.xlsx", guess_max = 1e5)

geocodes <- read_csv("./britain-bombing-ww2/ref/geocodes.csv") %>%
  select(location, lon, lat)


### Clean data ------------------------------------------------------------------------------------
interim <- bombings_raw %>%
  clean_names() %>%
  # Add geographic coordinates (latitude and longitude)
  left_join(geocodes, by = "location") %>%
  # Convert Excel dates to R date format
  mutate(across(start_date:end_date, ~ excel_numeric_to_date(parse_number(.)))) %>%
  # Parse numbers from casualty fields (they sometimes have values like "a few" or "unspecified")
  mutate(across(killed:total_casualties, parse_number)) %>%
  # Get rid of unnecessary fields
  select(-volume_reference, -intelligence_summary_number, -link_to_page) %>%
  # Re-order fields to be easier to work with
  select(civil_defence_region, country, location, lat, lon, start_date:time, killed:additional_notes)

interim %>%
  count(additional_notes, sort = TRUE) %>%
  filter(str_detect(additional_notes, "[Ll]ondon")) %>%
  View()

interim %>%
  filter(lon > -25) %>%
  ggplot(aes(lon, lat)) +
  borders(region = "uk") +
  geom_point(shape = ".") +
  coord_map() +
  facet_wrap(~ lubridate::year(start_date))