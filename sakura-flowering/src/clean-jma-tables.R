
### Load packages ---------------------------------------------------------------------------------
library(tidyverse)
library(pdftools)
library(janitor)
library(lubridate)


### Define function to clean Japan Meteorological Agency (JMA) tables -----------------------------
clean_jma_table <- function(pdf) {
  ### Load raw data -------------------------------------------------------------------------------
  pdf_length <- pdf_length(pdf)
  
  pdf_raw <- pdf_text(pdf)
  
  
  ### Format and clean tables ---------------------------------------------------------------------
  #### Separate raw text into proper rows
  sep_rows <- tibble(page = 1:pdf_length,
                            raw_text = pdf_raw) %>%
    # Separate text into one row per element (from one page per element)
    mutate(split_text = map(raw_text, ~ str_split(., "\n"))) %>%
    # Don't need raw_text now that we have a split version
    select(-raw_text) %>%
    # Convert list format to a character vector
    mutate(split_text = map(split_text, flatten_chr)) %>%
    # Find start and end of tables based on standard terms
    mutate(table_start = map_int(split_text, ~ str_which(., "番号")),
           table_end = map_int(split_text, ~ str_which(., "起日の値は月") - 1L)) %>%
    unnest(split_text)
  
  #### Convert into proper columns
  sep_cols <- sep_rows %>%
    # Filter out header/footer rows based on standard terms
    group_by(page) %>%
    mutate(row = row_number()) %>%
    ungroup() %>%
    filter(row >= table_start,
           row < table_end) %>%
    # Add a space after missing observations "-" to make sure columns line up properly
    mutate(split_text = str_replace_all(split_text, "-", "- ")) %>%
    # Replace spaces with a useful delimiter character "|"
    mutate(to_separate = str_replace_all(str_trim(split_text), "\\s+", "|")) %>%
    # Get rid of fields that aren't useful anymore
    select(page, to_separate) %>%
    # Separate into proper columns and remove empty columns
    # (Created 60 field in the into argument to have a buffer)
    separate(to_separate, into = paste0("field_", 1:60), sep = "\\|", fill = "right") %>%
    remove_empty(which = "cols")
  
  #### Convert header rows to proper field names
  #### Note: warnings about "Row does not provide unique names" are expected
  field_names <- sep_cols %>%
    # Nest data because we want to get the headers for each page of the PDF
    nest(data = starts_with("field")) %>%
    # Use janitor::row_to_names() to get 1st row to be field names
    # janitor::clean_names() deals with duplicate names (e.g., "rm") and names that are numbers only
    mutate(data = map(data, ~ clean_names(row_to_names(., 1)))) %>%
    unnest(data) %>%
    # Select only station number (fan_hao) and year fields
    # janitor::clean_names() added an "x" to the beginning of all years
    select(fan_hao, starts_with("x")) %>%
    pivot_longer(starts_with("x"), names_to = "year", values_to = "flower_month_day") %>%
    mutate(year = str_remove(year, "x"))
  
  #### De-duplicate data and add useful fields
  #### Note: parsing failures are expected when trying to find flowering dates
  clean <- field_names %>%
    # Formatting process led to stations have multiple rows for a single year
    # Only one of these combinations has the real data, the rest are NA, so we remove NA values
    filter(!is.na(flower_month_day)) %>%
    # Convert 3-digit date (e.g., "530" = "May 30") to proper date-formatted field
    mutate(flower_date = ymd(paste0(year, "0", flower_month_day)),
           flower_doy = yday(flower_date)) %>%
    # Add 47 to fan_hao (station number)
    # All Japanese stations start with 47 -- this data only reports last 3 digits
    transmute(station_id = as.double(paste0("47", fan_hao)),
              year = as.double(year),
              flower_date,
              flower_doy)
  
  
  ### Add station location data -------------------------------------------------------------------
  # Source: https://www.jma.go.jp/jma/kishou/books/station/station.html
  stations <- read_tsv("./sakura-flowering/raw/stations.txt", guess_max = 1e4) %>%
    # Select only useful fields
    transmute(station_id = as.double(IndexNbr),
              station_name = str_to_title(StationName),
              latitude_raw = Latitude,
              longitude_raw = Longitude) %>%
    # Some stations have multiple types, so take only distinct values
    distinct(station_id, .keep_all = TRUE) %>%
    # Separate geospatial coordinates into hours/minutes/seconds field and extract direction
    # Need to do this to convert it to a decimal format
    separate(latitude_raw, into = c("lat_hr", "lat_min", "lat_sec"), sep = " ") %>%
    mutate(lat_dir = str_extract(lat_sec, "[NS]$"),
           lat_sec = str_remove(lat_sec, lat_dir)) %>%
    separate(longitude_raw, into = c("long_hr", "long_min", "long_sec"), sep = " ") %>%
    mutate(long_dir = str_extract(long_sec, "[EW]$"),
           long_sec = str_remove(long_sec, long_dir)) %>%
    mutate_at(vars(lat_hr:long_sec), as.numeric) %>%
    transmute(station_id,
              station_name,
              # Convert geospatial coordinates to decimal format
              latitude = (lat_hr + lat_min / 60 + lat_sec / 3600) * as.numeric(ifelse(lat_dir == "N", 1, -1)),
              longitude = (long_hr + long_min / 60 + long_sec / 3600) * as.numeric(ifelse(long_dir == "E", 1, -1))) %>%
    # Include only Japanese stations (which start with 47)
    filter(str_detect(station_id, "^47"))
  
  modern <- clean %>%
    left_join(stations, by = "station_id") %>%
    select(station_id, station_name, latitude, longitude, everything())
  
  return(modern)
}


### Import and clean tables -----------------------------------------------------------------------
sakura_flower_modern <- clean_jma_table("./sakura-flowering/raw/sakura-flower-modern.pdf")
sakura_full_bloom_modern <- clean_jma_table("./sakura-flowering/raw/sakura-full-bloom-modern.pdf")


### Combine tables --------------------------------------------------------------------------------
sakura_combined <- sakura_flower_modern %>%
  left_join(sakura_full_bloom_modern, by = c("station_id", "year")) %>%
  transmute(station_id,
            station_name = station_name.x,
            latitude = latitude.x,
            longitude = longitude.x,
            year,
            flower_date = flower_date.x,
            flower_doy = flower_doy.x,
            full_bloom_date = flower_date.y,
            full_bloom_doy = flower_doy.y)


### Write to CSV
write_csv(sakura_combined, "./sakura-flowering/sakura-modern.csv")
