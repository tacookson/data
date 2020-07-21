
### Load packages ---------------------------------------------------------------------------------
library(tidyverse)
library(sf)
library(readxl)
library(fuzzyjoin)

### Load data and shapefile -----------------------------------------------------------------------
bombings <- read_xlsx("./britain-bombing-ww2/raw/Bombing-Britain-data.xlsx", guess_max = 32869)

# http://geoportal.statistics.gov.uk/datasets/ae90afc385c04d869bc8cf8890bd1bcd_1
gb <- read_sf("./britain-bombing-ww2/Great Britain Local Authority Districts (Dec 2017)/Local_Authority_Districts.shp")


### Fuzzy matching
gb %>%
  as_tibble() %>%
  select(lad17nm) %>%
  stringdist_right_join(bombings, by = c("lad17nm" = "Location")) %>%
  filter(is.na(lad17nm)) %>%
  count(Location, sort = TRUE)