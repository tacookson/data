
### Load packages ---------------------------------------------------------------------------------
library(tidyverse)
library(readxl)
library(lubridate)

### Load raw data ---------------------------------------------------------------------------------
# Data from https://www1.ncdc.noaa.gov/pub/data/paleo/historical/phenology/japan/LatestVersion/
base_dir <- "./sakura-flowering/raw/"

temp_759 <- read_xls(paste0(base_dir, "759Temp7.xls"),
                     skip = 14,
                     na = "-999.9",
                     col_names = c("year", "temp_c_recon", "temp_c_obs"),
                     guess_max = 2000)

kyoto_flower <- read_xls(paste0(base_dir, "KyotoFullFlower7.xls"),
                         skip = 26,
                         na = "-",
                         col_names = c("year",
                                       "flower_doy",
                                       "flower_date",
                                       "source",
                                       "flower_source",
                                       "flower_source_name"))

### Clean data ------------------------------------------------------------------------------------
sakura <- kyoto_flower %>%
         # Convert to descriptions based on data dictionary in original data
  mutate(source = case_when(source == 1 ~ "Taguchi (1939)",
                            source == 2 ~ "Sekiguchi (1969)",
                            source == 3 ~ "Aono and Omoto (1994)",
                            source == 4 ~ "Aono and Kazui (2008)",
                            source == 5 ~ "Aono and Saito (2010)",
                            source == 6 ~ "Aono (2011)",
                            source == 7 ~ "Aono (2012)",
                            source == 8 ~ "Found after publication of latest articles"),
         # Convert to descriptions based on data dictionary in original data
         flower_source = case_when(flower_source == 0 ~ "From modern times",
                                   flower_source == 1 ~ "From diary description about full bloom",
                                   flower_source == 2 ~ "From diary description about cherry blossom viewing party",
                                   flower_source == 3 ~ "From diary description about presents of cherry twigs from party participants",
                                   flower_source == 4 ~ "Title in Japanese poetry",
                                   flower_source == 8 ~ "Deduced from wisteria phenology -- Aono and Saito (2010)",
                                   flower_source == 9 ~ "Deduced from Japanese kerria phenology -- Aono (2011)")) %>%
  # Parse date (tricky due to some 3-digit years)
  mutate(year_parse = str_pad(year, 4, pad = 0),
         month_parse = str_sub(flower_date, 1, 1),
         day_parse = str_sub(flower_date, 2, 3),
         flower_date = ymd(paste(year_parse,
                                        month_parse,
                                        day_parse,
                                        sep = "-"))) %>%
  left_join(temp_759, by = "year") %>%
  filter(year >= 812) %>%
  rename(study_source = source) %>%
  select(year, temp_c_recon, temp_c_obs, flower_doy, flower_date, flower_source, flower_source_name, study_source)

### Write to CSV
write_csv(sakura, "./sakura-flowering/sakura-historical.csv")