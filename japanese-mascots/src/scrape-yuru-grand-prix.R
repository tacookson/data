
### Load packages ---------------------------------------------------------------------------------
library(tidyverse)
library(rvest)

### Scrape rankings -------------------------------------------------------------------------------
url <- "https://www.yurugp.jp/jp/ranking/?year=2019&page=1&sort=2" # 2019 company/organization rankings

message(url)

website <- read_html(url)

html_nodes(website, "h4") %>% html_text(trim = TRUE) # Name
html_nodes(website, "h4+ span") %>% html_text(trim = TRUE) # Location
html_nodes(website, ".biko") %>% html_text(trim = TRUE) # Company or Organization
html_nodes(website, ".img img") %>% html_attr("src") # Image path





### APPENDIX (Individual character) ---------------------------------------------------------------
url <- "https://www.yurugp.jp/en/vote/detail.php?id=00004000"

message(url)

website <- read_html(url)

html_node(website, ".charaname") %>% html_text(trim = TRUE) # Name
html_node(website, ".en") %>% html_text(trim = TRUE) # English
html_node(website, ".region") %>% html_text(trim = TRUE)
html_nodes(website, "#content p font")