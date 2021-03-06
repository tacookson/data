### Load libraries --------------------------------------------------------------------------------
library(tidyverse)
library(rvest)
library(janitor)
library(countrycode)
library(fuzzyjoin)

### Create country name-adjectival correspondence table -------------------------------------------
# Scrape Wikipedia country name table
adjectives_table <- read_html("https://en.wikipedia.org/wiki/List_of_adjectival_and_demonymic_forms_for_countries_and_nations") %>%
  html_node(xpath = "//*[@id=\"mw-content-text\"]/div/table[1]") %>%
  html_table() %>%
  as_tibble() %>%
  clean_names() %>%
  select(country_lower = country_entity_name, adjective = adjectivals) %>%
  # Convert all to lowercase
  mutate_all(~ str_to_lower(.)) %>%
  # Separate multiple adjectivals on the same row
  separate_rows(adjective, sep = ",") %>%
  # Remove Wikipedia references, which are between square brackets [REFERENCE]
  mutate(adjective = str_remove_all(adjective, "\\[[0-9a-z]\\]"),
         adjective = str_squish(adjective))

# Find close string distance between country name in countrycode::codelist and country name in table
# Default method works fine, but I adjusted max_dist = 1.5
country_adjectives <- countrycode::codelist %>%
  as_tibble() %>%
  select(country = country.name.en,
         regex = country.name.en.regex) %>%
  stringdist_inner_join(adjectives_table, by = c("regex" = "country_lower"), max_dist = 1.5) %>%
  select(country, country_lower, adjective)

# Create character vector if using country names and adjectives as stop words
# Combines country names from Wikipedia adjectives table and countrycode's codelist
# It's sloppily implement (lots of duplication), but it's quick enough and gets the output I need!
country_stop_words <- c(adjectives_table$country_lower,
                        adjectives_table$adjective,
                        str_to_lower(countrycode::codelist$country.name.en)) %>%
  unique()

rm(adjectives_table)
