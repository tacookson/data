
# Load libraries
library(tidyverse)

gift_notices <- tibble(filename = list.files("./us-government-gifts/raw/", full.names = TRUE),
       full_text = map(filename, read_lines)) %>%
  mutate(filename = str_remove(filename, "./us-government-gifts/raw/"),
         filename = str_remove(filename, ".txt"),
         filename = str_remove(filename, "doc")) %>%
  separate(filename, into = c("publication_date", "document_number"), sep = "_")

test_notice <- gift_notices$full_text[[1]] %>%
  as_tibble_col(column_name = "text") %>%
  mutate(agency_header = str_detect(text, "AGENCY:"),
         agency_name = ifelse(agency_header, str_squish(str_remove(text, "AGENCY: ")), NA_character_)) %>%
  tidyr::fill(agency_name, .direction = "down")

test_notice %>%
  filter(!is.na(agency_name)) %>%
  group_by(agency_name) %>%
  mutate(row = row_number()) %>%
  ungroup() %>%
  # Lines that are only dashes ------
  mutate(header_separator = str_detect(text, "^[-]+$"),
         header_separator_number = cumsum(header_separator)) %>%
  filter(header_separator_number >= 2,
         !header_separator) %>%
  mutate(entry_first_line = str_detect(text, "^[A-Z]"),
         entry_number = cumsum(entry_first_line)) %>%
  select(agency_name, entry_number, text) %>%
  View()


  filter(str_detect(text, "[\\.]{3}")) %>%
  View()