## Reproducible example demonstrating country name parsing

library(dplyr)
library(stringr)

gifts <- readr::read_csv("https://raw.githubusercontent.com/tacookson/data/master/us-government-gifts/gifts.csv") %>%
  select(id, donor, donor_country, gift_description)

### Examples of parsing from donor field
### Goal: parsed country name to populate donor_country field
donor_parsing <- gifts %>%
  filter(id %in% c(7, # Italy
                   66, # South Korea
                   144, # Saudi Arabia
                   616 # Portugal
                   )) %>%
  select(id, donor, donor_country)

### Examples of parsing from gift_description field
### Goal: create a list of stop words to use when doing text analysis
### (e.g., having "Chinese" in a description of a gift from "China" isn't useful)
gifts %>%
  filter(str_detect(gift_description, "Chinese")) %>%
  select(gift_description)
  