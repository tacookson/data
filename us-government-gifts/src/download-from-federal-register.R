
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
  # Remove corrections -- these are usually short and apply to one or two entries only
  filter(!str_detect(str_to_lower(title), "correction"),
         str_detect(str_to_lower(title), "gifts to federal employees")) %>%
  mutate(publication_date = ymd(publication_date),
         year = year(publication_date),
         # Create two-digit numbers, with 0 in tens digit if less than 10
         month = str_pad(month(publication_date), 2, side = "left", pad = "0"),
         day = str_pad(day(publication_date), 2, side = "left", pad = "0"),
         # URL approach used because I didn't want to figure the API out for only ~ 20 documents :|
         text_url = glue("https://www.federalregister.gov/documents/full_text/text/{year}/{month}/{day}/{document_number}.txt"))

# Create vector of URLs of full text
url_list <- document_list$text_url

# Create list of paths and document names -- {publication_date}_{document_number}.txt
path_list <- glue("./us-government-gifts/raw/{document_text$publication_date}_doc{document_text$document_number}.txt")

# Function with safely() in case of error
safe_download <- safely(~ download.file(.x, .y, mode = "wb"))

# Download full text from Federal Register (takes ~45 seconds)
walk2(url_list, path_list, safe_download)
