 
# Load libraries
library(tidyverse)
library(janitor)

# Import data
individuals_raw <- read_csv("./caribou-location-tracking/raw/Mountain caribou in British Columbia-reference-data.csv")
locations_raw <- read_csv("./caribou-location-tracking/raw/Mountain caribou in British Columbia-gps.csv")

# Clean individuals
individuals <- individuals_raw %>%
  clean_names() %>%
  transmute(animal_id,
            sex = animal_sex,
            # Getting rid of whitespace to address inconsistent spacing
            # NOTE: life stage is as of the beginning of deployment
            life_stage = str_remove_all(animal_life_stage, " "),
            reproductive_condition = animal_reproductive_condition,
            # Cause of death "cod" is embedded in a comment field
            death_cause = str_remove(animal_death_comments, ".*cod "),
            study_site,
            deploy_on_longitude,
            deploy_on_latitude,
            # Renaming to maintain consistency "deploy_on_FIELD" and "deploy_off_FIELD"
            deploy_on_comments = deployment_comments,
            deploy_off_longitude,
            deploy_off_latitude,
            deploy_off_type = deployment_end_type,
            deploy_off_comments = deployment_end_comments) %>%
  # reproductive_condition actually has two dimensions
  separate(reproductive_condition, into = c("pregnant", "with_calf"), sep = ";", fill = "left") %>%
  mutate(pregnant = str_remove(pregnant, "pregnant: ?"),
         with_calf = str_remove(with_calf, "with calf: ?")) %>%
  # TRUE and FALSE are indicated by Yes/No or Y/N
  mutate_at(vars(pregnant:with_calf), ~ case_when(str_detect(., "Y") ~ TRUE,
                                                   str_detect(., "N") ~ FALSE,
                                                   TRUE ~ NA))

# Clean locations
locations <- locations_raw %>%
  clean_names() %>%
  transmute(event_id,
            animal_id = individual_local_identifier,
            study_site = comments,
            season = study_specific_measurement,
            timestamp,
            longitude = location_long,
            latitude = location_lat)

# Write to CSV
write_csv(individuals, "./caribou-location-tracking/individuals.csv")
write_csv(locations, "./caribou-location-tracking/locations.csv")