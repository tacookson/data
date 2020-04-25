
# Load libraries
library(tidyverse)
library(httr)
library(jsonlite)
library(rvest)
library(glue)
library(lubridate)

# Define API path (no token required)
path <- "https://www.federalregister.gov/api/v1/documents.json?"

# Create request for State Department Notices matching term "gift to federal employees"
request <- GET(url = path,
               query = list(per_page = 100,
                            `conditions[term]` = "gift to federal employees from foreign government sources",
                            `conditions[agencies][]` = "state-department",
                            `conditions[type][]` = "NOTICE"))

# Convert response to text
response <- content(request, as = "text", encoding = "UTF-8") %>%
  fromJSON(flatten = TRUE) %>%
  as_tibble()

# Construct tibble of documents and URLs for their full text
document_list <- as_tibble(response$results, .name_repair = "universal") %>%
  select(title, document_number, publication_date) %>%
  filter(!str_detect(str_to_lower(title), "correction"),
         str_detect(str_to_lower(title), "gifts to federal employees")) %>%
  mutate(publication_date = ymd(publication_date),
         year = year(publication_date),
         month = str_pad(month(publication_date), 2, side = "left", pad = "0"),
         day = str_pad(day(publication_date), 2, side = "left", pad = "0"),
         text_url = glue("https://www.federalregister.gov/documents/full_text/text/{year}/{month}/{day}/{document_number}.txt"))

# Read full text from Federal Register
document_text <- document_list %>%
  mutate(full_text = map(text_url, read_lines))

# Pull first full text as sample
document_text$full_text[[1]]