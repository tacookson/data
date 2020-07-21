
### Load packages ---------------------------------------------------------------------------------
library(tidyverse)
library(readxl)
library(janitor)


### Load data and geocodes ------------------------------------------------------------------------
bombings_raw <- read_xlsx("./britain-bombing-ww2/raw/Bombing-Britain-data.xlsx", guess_max = 1e5)

geocodes <- read_csv("./britain-bombing-ww2/geocodes.csv")


### Clean data ------------------------------------------------------------------------------------
bombings_raw %>%
  clean_names() %>%
  # Convert Excel dates to R date format
  mutate(across(start_date:end_date, ~ excel_numeric_to_date(parse_number(.)))) %>%
  mutate(across(killed:total_casualties, parse_number)) %>%
  add_count(killed)
