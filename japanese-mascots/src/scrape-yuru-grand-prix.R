
### Load packages ---------------------------------------------------------------------------------
library(tidyverse)
library(rvest)
library(glue)

### Define functions ------------------------------------------------------------------------------
# Function to read website node and convert to text
pull_node <- function(website, node) {
  html_nodes(website, node) %>% html_text(trim = TRUE)
}

# Function to scrape rankings page
### TO DO: adjust function to account for pages with fewer than 20 characters (last page of yearly rankings, like 2011 p. 18)
get_yuru_chara <- function(url) {
  message(glue("Currently scraping ... {url}"))
  
  website <- read_html(url)
  
  data <- list(
    rank = pull_node(website, "strong"),
    name = pull_node(website, "h4"),
    area = pull_node(website, "h4+ span"),
    organization = pull_node(website, ".biko"),
    # Pull image URL
    image_url = html_nodes(website, ".img img") %>% html_attr("src")
  )
  
  df <- tibble(data = data) %>%
    mutate(field = names(data)) %>%
    pivot_wider(names_from = field, values_from = data) %>%
    unnest(cols = everything())
  
  # Add 3s delay for "polite" scraping
  Sys.sleep(3)
  
  return(df)
}


### Scrape rankings -------------------------------------------------------------------------------
test <- crossing(year = 2011:2019,
         page = 1:30) %>%
  mutate(organization = glue("https://www.yurugp.jp/jp/ranking/?year={year}&page={page}&sort=2"),
         area = glue("https://www.yurugp.jp/jp/ranking/?year={year}&page={page}")) %>%
  pivot_longer(organization:area, names_to = "ranking_category", values_to = "url") %>%
  slice(1:40) %>%
  mutate(yuru_chara_data = map(url, possibly(get_yuru_chara, NULL, quiet = FALSE)))





### APPENDIX (Individual character) ---------------------------------------------------------------
url <- "https://www.yurugp.jp/en/vote/detail.php?id=00004000"

message(url)

website <- read_html(url)

html_nodes(website, "strong") %>% html_text(trim = TRUE) # Rank
html_node(website, ".charaname") %>% html_text(trim = TRUE) # Name
html_node(website, ".en") %>% html_text(trim = TRUE) # English
html_node(website, ".region") %>% html_text(trim = TRUE)