
### Load packages ---------------------------------------------------------------------------------
library(tidyverse)
library(readODS) # For reading the .ods data file
library(janitor)


### Download and unzip raw data -------------------------------------------------------------------
dest_path <- "./fictional-character-personalities/raw"
dest_file <- paste0(dest_path, "/characters-aggregated.zip")

download.file("http://openpsychometrics.org/_rawdata/characters-aggregated.zip",
              dest_file)

unzip(dest_file, exdir = dest_path)


### Load data -------------------------------------------------------------------------------------
# Set path of raw data file
data_path <- paste0(dest_path, "/characters-aggregated/characters-aggregated.ods")

# read_ods() works, but takes several minutes (on my machine, at least)
mean_data <- tibble(measure = "mean",
                    data = read_ods(data_path, sheet = 1))

ratings_data <- tibble(measure = "ratings",
                       data = read_ods(data_path, sheet = 2))

sd_data <- tibble(measure = "sd",
                  data = read_ods(data_path, sheet = 3))


### Combine and clean data ------------------------------------------------------------------------
personalities <- bind_rows(mean_data, ratings_data, sd_data)

names(personalities$data)[1] <- "character_code"

personalities %>%
  mutate(data = as_tibble(data)) %>%
  unnest(data)