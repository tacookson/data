
### Load packages ---------------------------------------------------------------------------------
library(tidyverse)
library(readODS)
library(janitor)
library(rvest)
library(stringi)


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
  # Convert mean from [0 to 100] scale to [-50 to +50] scale
  mutate(mean = mean - 50) %>%
  select(character_code, fictional_work, character_name,
         spectrum, spectrum_low, spectrum_high,
         mean, ratings, sd)


### Aggregate duplicated spectrums ----------------------------------------------------------------
# Spectrum BAP98 and BAP183 have the same adjective-pair (hard / soft)
# We'll de-duplicate by creating a separate tibble with aggregated values collapsed into BAP98
# (i.e., BAP183 will be eliminated)

# Aggregate BAP98 and BAP183 into BAP98
bap98 <- personalities %>%
  filter(spectrum %in% c("BAP98", "BAP183")) %>%
         # Collapse BAP98 and BAP183 (hard / soft) into BAP98
  mutate(spectrum = "BAP98",
         # We need total variance to aggregate standard deviation
         total_var = (sd ^ 2) * ratings) %>%
  group_by(character_code, spectrum) %>%
  summarise(mean = weighted.mean(mean, w = ratings),
            ratings = sum(ratings),
            # Aggregated standard deviation is the square root of the mean variance
            sd = sqrt(sum(total_var) / ratings)) %>%
  ungroup()


### Create de-duplicated tibble -------------------------------------------------------------------
personalities_deduped <- personalities %>%
  # Get rid of BAP183 because we've collapsed it already
  filter(spectrum != "BAP183") %>%
  # Join aggregated measures for BAP98
  left_join(bap98, by = c("character_code", "spectrum")) %>%
  # Use the existing value for everything but BAP98 (the only spectrum in the joined table)
  mutate(mean = coalesce(mean.y, mean.x),
         ratings = coalesce(ratings.y, ratings.x),
         sd = coalesce(sd.y, sd.x)) %>%
  # Get rid of extra columns created by the join
  select(-ends_with(".x"), -ends_with(".y")) %>%
  # Add indicator column for spectrums with emojis
  mutate(is_emoji = !stri_enc_isascii(spectrum_low) | !stri_enc_isascii(spectrum_high)) %>%
  # Order alphabetically by fictional work, then character name
  arrange(fictional_work, character_name)


### Add in manually-coded genders
# NOTE: THIS IS NOT IN THE ORIGINAL DATASET

# Read in CSV with character genders
genders <- read_csv("./fictional-character-personalities/ref/character-gender.csv")

personalities_with_gender <- personalities_deduped %>%
  left_join(genders, by = "character_code") %>%
  # Re-order fields to make more sense
  select(character_code:character_name,
         gender,
         spectrum:spectrum_high,
         is_emoji,
         mean:sd)

### Write to TXT ----------------------------------------------------------------------------------
write_tsv(personalities_with_gender, "./fictional-character-personalities/personalities.txt")
