
# Load libraries
library(tidyverse)
library(lubridate)
library(countrycode)
library(fuzzyjoin)
library(tidytext)


### Define functions ------------------------------------------------------------------------------
# Helper function to find where to split column in the text
# We know the approximate location from looking at the data
# But it changes slightly from document to document
# Logic: character position with most spaces is the delimiter position
find_spaces_between <- function(x, low, high) {
  str_locate_all(x, " ") %>%
    unlist() %>%
    as_tibble() %>%
    count(value) %>%
    filter(between(value, low, high)) %>%
    filter(n == max(n)) %>%
    pull(value)
}

# Function to clean individual notices (main powerhouse function)
clean_notices <- function(x) {
  notice <- x %>%
  # Convert to tibble
  as_tibble_col(column_name = "text") %>%
    # Find rows with agency headers
    mutate(agency_header = str_detect(text, "A(GENCY|gency):"),
           # Extract name of agency
           agency_name = ifelse(agency_header, str_squish(str_remove(text, "AGENCY: |Agency: ")), NA_character_)) %>%
    # Fill name of agency down until hitting another agency header
    tidyr::fill(agency_name, .direction = "down") %>%
    # Find the year the data is for (it's in the preamble and is usually 2 years before publication year)
    extract(text, "year_received", "[Cc]alendar [Yy]ear ([12][09][019][0-9])", remove = FALSE, convert = TRUE) %>%
    # Fill the extracted year to all rows
    fill(year_received, .direction = "downup") %>%
    # Find header titles, which are between lines that are only dashes "-----"
    mutate(header_separator = str_detect(text, "^[-]+$"),
           header_separator_number = cumsum(header_separator)) %>%
    # Filter out headers (leaving only actual entries)
    # Header separators are at the top and bottom of headers (which is why we need 2)
    filter(header_separator_number >= 2,
           !header_separator) %>%
    # Find first line of entry, which will be a capitalized alphabetical character
    mutate(entry_first_line = str_detect(text, "^[A-Z]"),
           # Create entry number based on where first lines occur
           entry_number = cumsum(entry_first_line)) %>%
    # Get rid of helper columns
    select(agency_name, year_received, entry_number, text)
  
  # We know approximate locations from earlier failed attempts to clean this data
  split_locations <- c(find_spaces_between(notice$text, 32, 42),
                       find_spaces_between(notice$text, 60, 70),
                       find_spaces_between(notice$text, 85, 95))
  
  notice %>%
    # Apply split locations to the text
    mutate(recipient = str_sub(text, start = 1L, end = split_locations[[1]]),
           gift_description = str_sub(text, start = split_locations[[1]], end = split_locations[[2]] - 1),
           donor = str_sub(text, start = split_locations[[2]], end = split_locations[[3]] - 1),
           justification = str_sub(text, start = split_locations[[3]])) %>%
    select(-text) %>%
    # pivot_longer() and pivot_wider() shenanigans to get entries from multiple lines to a single line
    # There is almost certainly a more elegant way to do this
    pivot_longer(cols = recipient:justification, names_to = "category", values_to = "text") %>%
    # Page numbers are in double-square brackets, like [[Page 123]]
    mutate(text = str_remove_all(text, "\\[\\[(.+?)\\]\\]"),
           text = str_squish(text)) %>%
    filter(text != "") %>%
    # Some fields have filler periods until the next column
    mutate(text = str_replace(text, "[..]{2,}", "")) %>%
    group_by(agency_name, year_received, entry_number, category) %>%
    summarise(text = str_c(text, collapse = " ")) %>%
    ungroup() %>%
    pivot_wider(id_cols = agency_name:entry_number, names_from = category, values_from = text) %>%
    # All "real" gift descriptions have an estimated value
    # Filtering to look for "Est. Value" or a dollar figure gets rid of header text that snuck in
    filter(str_detect(gift_description, "Est. [Vv]alue") | str_detect(gift_description, "\\$[0-9]+"))
}

# Function to pull the last value from a list
# Used when there are multiple dollar values in a gift description
# (The last one is usual the total of all items)
find_max_value <- function(x) {
  ifelse(length(x) == 0,
         NA_character_,
         map(x, parse_number) %>%
           unlist() %>%
           max())
}


### Load and clean documents ----------------------------------------------------------------------

# Load documents and parse publication date and document number from filename
gift_notices_raw <- tibble(filename = list.files("./us-government-gifts/raw/", full.names = TRUE),
       full_text = map(filename, read_lines)) %>%
  mutate(filename = str_remove(filename, "./us-government-gifts/raw/"),
         filename = str_remove(filename, ".txt"),
         filename = str_remove(filename, "doc")) %>%
  separate(filename, into = c("publication_date", "document_number"), sep = "_") %>%
  mutate(publication_date = ymd(publication_date)) %>%
  # Ditch everything before 2000 because we don't have continuous data
  # Also because the notice format is different and not worth the work for two extra non-contiguous years
  filter(year(publication_date) >= 2000) %>%
  mutate(clean_text = map(full_text, clean_notices)) %>%
  unnest(clean_text) %>%
  select(agency_name, year_received, recipient, gift_description, donor, justification)

# Pull English-language country names and regex from {countrycode} package
country_list <- as_tibble(countrycode::codelist) %>%
  transmute(donor_country = country.name.en,
            country_regex = country.name.en.regex)

# Additional cleaning steps
gift_notices_clean <- gift_notices_raw %>%
  # Add row number as id field
  mutate(id = row_number()) %>%
  # Get rid of any extra whitespace that snuck in
  mutate_at(vars(recipient:justification), str_squish) %>%
  # Find the dollar value, indicated by the word "value" and a dollar figure
  # Messy regex is for different formatting (e.g., comma or period separating thousands, optional cent values)
  mutate(value_list = str_extract_all(gift_description, "\\$([0-9]{1,3}[,\\.]([0-9]{3}[,\\.])*[0-9]{3}|[0-9]+)(.[0-9][0-9])?"),
         value_text = map_chr(value_list, find_max_value),
         # Parse character dollar value -- running map_dbl throws an error because one element isn't coercible
         value_usd = parse_number(value_text)) %>%
  # Find m/d/y dates that might be one- or two-digit and might have spaces between digits and slashes
  mutate(date_text = str_extract(gift_description, "(1[0-2]|0?[1-9]) */ *(3[01]|[12][0-9]|0?[1-9]) */ *[0-9]{2,4}"),
         date_received = mdy(date_text),
         # Not sure why I need to wrap as_date around the ifelse function
         # If I don't date_received becomes a double class
         date_received = as_date(ifelse(date_received >= "2019-01-01", NA, date_received))) %>%
  # Change year_received when we have a different year in date_received
  # Notices commonly report some gifts given for prior years but weren't known at that time to reporting authority
  # date_received much likelier to be more accurate than year_received because it is at entry-level rather than document-level
  mutate(year_received = ifelse(is.na(date_received), year_received, year(date_received))) %>%
  # Get rid of periods at the end of recipient and donor names and titles
  mutate(recipient = str_remove(recipient, "\\.$"),
         donor = str_remove(donor, "\\.$")) %>%
  # Search for countries in donor title using 
  mutate(donor_lower = str_to_lower(donor)) %>%
  regex_left_join(country_list, by = c("donor_lower" = "country_regex")) %>%
  # Convert references to U.S.C. 7342 and U.S.C. 403 in donor field to more meaningful description
  mutate(donor = ifelse(str_detect(donor, "U[.]?S[.]?C[.]?.*(7342)|(403)"),
                        "Redacted -- Disclosure could adversely affect intelligence sources or methods",
                        donor)) %>%
  # Clean inconsistent wording of justification "Non-acceptance would cause embarrassment"
  mutate(justification = ifelse(str_detect(justification, "embarras"),
                                "Non-acceptance would cause embarrassment to donor and U.S. Government",
                                justification)) %>%
  # Clean inconsistent agency names
  mutate(agency_name = case_when(str_detect(agency_name, "Office of Science and Technology") ~ "Office of Science and Technology Policy",
                                 str_detect(agency_name, "Vice President") ~ "Executive Office of the Vice President",
                                 str_detect(agency_name, "Office of the President") ~ "Executive Office of the President",
                                 str_detect(agency_name, "United States Court") ~ "Administrative Office of the United States Courts",
                                 str_detect(agency_name, "Department of Education") ~ "Department of Education",
                                 str_detect(agency_name, "Agriculture") ~ "Department of Agriculture",
                                 str_detect(agency_name, "International Development") ~ "U.S. Agency for International Development",
                                 str_detect(agency_name, "Senate") ~ "U.S. Senate",
                                 str_detect(agency_name, "House of Representatives") ~ "U.S. House of Representatives",
                                 str_detect(agency_name, "NASA") ~ "National Aeronautics and Space Administration",
                                 str_detect(agency_name, "Federal Reserve") ~ "Federal Reserve Board",
                                 str_detect(agency_name, "Marine Corps") ~ "U.S. Marine Corps",
                                 str_detect(agency_name, "National Security Council") ~ "National Security Council",
                                 str_detect(agency_name, "Environmental Protection") ~ "Environmental Protection Agency",
                                 str_detect(agency_name, "Office of the Mayor") ~ "Office of the Mayor of the District of Columbia",
                                 TRUE ~ agency_name),
         agency_name = str_remove(agency_name, "^The "),
         agency_name = str_replace(agency_name, "Department of the", "Department of")) %>%
  # Replacing mis-parsed "<gr-thn-eq>" with quotation mark symbol " (because it appears to represent inches, indicated by ")
  mutate(gift_description = str_replace_all(gift_description, "<gr ?- ?thn ?- ?eq>", "\"")) %>%
  # Manually cleaning 3 entries that did not parse correctly
  mutate(donor = ifelse(id %in% c(314, 1068, 1074), NA, donor),
         gift_description = ifelse(id %in% c(1068, 1074), NA, gift_description)) %>%
  # Change fields to be in a nice order (and get rid of helper fields)
  select(id, recipient, agency_name, year_received, date_received, donor, donor_country, gift_description, value_usd, justification) %>%
  # Remove some duplicate entries that got added when regex matching to country names
  distinct(id, .keep_all = TRUE)

# Fill in additional donor countries based on country adjectivals (e.g., "Italian" for "Italy")
source("./us-government-gifts/src/country-adjective-list.R")

parsed_countries <- gift_notices_clean %>%
  select(id, donor_country, donor) %>%
  unnest_tokens(word, donor) %>%
  regex_left_join(country_adjectives, by = c("word" = "adjective")) %>%
  filter(!is.na(adjective),
         is.na(donor_country)) %>%
  select(id, country_from_adjective = country)

gift_notices <- gift_notices_clean %>%
  left_join(parsed_countries, by = "id") %>%
  mutate(donor_country = ifelse(!is.na(country_from_adjective), country_from_adjective, donor_country)) %>%
  select(-country_from_adjective)

### Write to CSV ----------------------------------------------------------------------------------
write_csv(gift_notices, "./us-government-gifts/gifts.csv")
