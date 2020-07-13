
### Load packages ---------------------------------------------------------------------------------
library(tidyverse)
library(rvest)
library(lubridate)


### Define function to scrape historical temperatures ---------------------------------------------
# Example page: https://www.data.jma.go.jp/obd/stats/etrn/view/monthly_s3_en.php?block_no=47401

scrape_temps <- function(url) {
  
  # Let user know what is currently being scrape
  message(paste0("Currently scraping... ", url))
  
  # Read website and convert table to tibble
  table <- read_html(base_url) %>%
    html_node(".data2_s") %>%
    html_table() %>%
    as_tibble()
  
  # Clean and format table
  temps <- table %>%
    select(-Annual) %>%
    rename(year = Year) %>%
    rowwise() %>%
    mutate(across(Jan:Dec, ~ ifelse(is.numeric(.), ., parse_number(., na = c("", "ã€€"))))) %>%
    pivot_longer(Jan:Dec, names_to = "month", values_to = "mean_temp_c") %>%
    mutate(month_date = ymd(paste(year, month, "01", sep = "-"))) %>%
    filter(between(year, 1952, 2019)) %>%
    select(year, month, month_date, mean_temp_c)
  
  # Return tidy tibble
  return(temps)
}


### Scrape and clean temperatures -----------------------------------------------------------------
# Note: some parsing failures expected for characters "ã€€"
temperatures_scraped <- read_csv("./sakura-flowering/sakura-modern.csv") %>%
  distinct(station_id, station_name) %>%
  mutate(temperature_url = paste0("https://www.data.jma.go.jp/obd/stats/etrn/view/monthly_s3_en.php?block_no=",
                                  station_id)) %>%
  mutate(temperature_df = map(temperature_url, possibly(scrape_temps, NULL)))

temperatures <- temperatures_scraped %>%
  select(-temperature_url) %>%
  unnest(temperature_df)


### Write to CSV ----------------------------------------------------------------------------------
write_csv(temperatures, "./sakura-flowering/temperatures-modern.csv")
