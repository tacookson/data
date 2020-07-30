
### Load packages ---------------------------------------------------------------------------------
library(tidyverse)
library(readODS)
library(janitor)
library(rvest)


### Download and unzip raw data -------------------------------------------------------------------
# Define path and file destination
dest_path <- "./fictional-character-personalities/raw"
dest_file <- paste0(dest_path, "/characters-aggregated.zip")

# Download from http://openpsychometrics.org/
download.file("http://openpsychometrics.org/_rawdata/characters-aggregated.zip",
              dest_file)

# Unzip downloaded file
unzip(dest_file, exdir = dest_path)


### Load data -------------------------------------------------------------------------------------
# Set path of raw data file
data_path <- paste0(dest_path, "/characters-aggregated/characters-aggregated.ods")

# Define function to read in .ods raw data and get it into a usable format
read_personality_data <- function(sheet_num, measure) {
  read_ods(data_path, sheet = sheet_num) %>%
    # First column is empty, so we need to tell as_tibble() to give it a generic name
    as_tibble(.name_repair = "universal") %>%
    rename(character_code = ...1) %>%
    mutate(measure = measure) %>%
    pivot_longer(starts_with("BAP"), names_to = "spectrum", values_to = "value")
}

# Read the mean, number of ratings, and standard deviation from raw data
personalities_raw <- tibble(sheet_num = 1:3,
       measure = c("mean", "ratings", "sd")) %>%
  mutate(data = map2(sheet_num, measure, read_personality_data)) %>%
  select(data) %>%
  unnest(data) %>%
  pivot_wider(names_from = measure, values_from = value)


### Extract correspondence tables from codebook ---------------------------------------------------
# Extract tables from codebook.html
codebook_tables <- read_html(paste0(dest_path, "/characters-aggregated/codebook.html")) %>%
  html_nodes("table") %>%
  html_table()

# First table gives character details
character_codes <- as_tibble(codebook_tables[[1]]) %>%
  rename(character_code = ID,
         fictional_work = `Fictional work`,
         character_name = `Character display name`)

# Second table gives personality spectrum details (low --> high)
spectrum_codes <- as_tibble(codebook_tables[[2]]) %>%
  rename(spectrum = ID,
         spectrum_low = `low/left anchor`,
         spectrum_high = `high/right anchor`)


### Look up characters and spectrum details from correspondence tables ----------------------------
personalities <- personalities_raw %>%
  left_join(character_codes, by = "character_code") %>%
  left_join(spectrum_codes, by = "spectrum") %>%
  select(character_code, fictional_work, character_name,
         spectrum, spectrum_low, spectrum_high,
         mean, ratings, sd)

### Write to TXT ----------------------------------------------------------------------------------
write_tsv(personalities, "./fictional-character-personalities/personalities.txt")
