library(tidyverse)
library(httr)
library(jsonlite)

# path <- "https://www.federalregister.gov/api/v1/documents.json?"
# 
# fields <- list(`fields[]` = c("title", "document_number", "json_url", "publication_date"))
# 
# request <- GET(url = path,
#                query = list(per_page = 20,
#                             `fields[]` = list(`fields[]` = c("title", "document_number")),
#                             `conditions[term]` = "gift to federal employees",
#                             `conditions[agencies][]` = "state-department",
#                             `conditions[type][]` = "NOTICE"))
# 
# status_code(request)
# 
# response <- content(request, as = "text", encoding = "UTF-8")
# 
# df <- fromJSON(response, flatten = TRUE) %>%
#   as_tibble()
# 
# df_parsed <- df %>%
#   hoist(results, title = "title", document_number = "document_number")

url <- "https://www.federalregister.gov/api/v1/documents.json?fields%5B%5D=document_number&fields%5B%5D=json_url&fields%5B%5D=publication_date&fields%5B%5D=raw_text_url&fields%5B%5D=title&per_page=500&conditions%5Bterm%5D=gifts%20to%20federal%20employees&conditions%5Bagencies%5D%5B%5D=state-department&conditions%5Btype%5D%5B%5D=NOTICE"

request <- GET(url)

response <- content(request, as = "text", encoding = "UTF-8")

df <- fromJSON(response) %>%
  as_tibble() %>%
  .$results %>%
  as_tibble()

test_read <- read_lines("https://www.federalregister.gov/documents/full_text/text/2020/02/25/2020-03722.txt")