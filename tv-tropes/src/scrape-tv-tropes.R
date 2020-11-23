
### Load packages ---------------------------------------------------------------------------------
library(tidyverse)
library(rvest)
library(glue)

### Define functions ------------------------------------------------------------------------------

# Function to read website node and convert to text -------------------------------------
pull_node <- function(website, node) {
  html_nodes(website, node) %>% html_text(trim = TRUE)
}


# Function to scrape full list of tropes ------------------------------------------------
get_trope_list <- function(url) {
  message(glue("Currently scraping ... {url}"))
  
  website <- read_html(url)
  
  data <- list(
    trope_name = pull_node(website, "td"),
    trope_url = html_nodes(website, "td") %>% html_children() %>% html_attr("href")
  )
  
  df <- tibble(data = data) %>%
    mutate(field = names(data)) %>%
    pivot_wider(names_from = field, values_from = data) %>%
    unnest(cols = everything())
  
  return(df)
  
  # 2s delay for "polite" scraping
  Sys.sleep(2)
}


# Function to get the "laconic" (very short) description of a trope ---------------------
get_laconic_description <- function(url) {
  laconic_url <- str_replace(url, "Main", "Laconic")
  
  message(glue("Currently scraping ... {laconic_url}"))
  
  description <- read_html(laconic_url) %>%
    html_node("#main-article p") %>%
    html_text()
  
  return(description)
  
  # 1s delay for "polite" scraping
  Sys.sleep(1)
}


# Function to scrape index page page ----------------------------------------------------
get_trope_index <- function(url) {
  message(glue("Currently scraping ... {url}"))
  
  website <- read_html(url)
  
  data <- list(
    trope_name = pull_node(website, ".twikilink"),
    trope_url = html_nodes(website, ".twikilink") %>% html_attr("href")
  )
  
  df <- tibble(data = data) %>%
    mutate(field = names(data)) %>%
    pivot_wider(names_from = field, values_from = data) %>%
    unnest(cols = everything())
  
  return(df)
}


# Function to scrape related tropes on an individual trope page -------------------------
get_related_tropes <- function(url) {
  message(glue("Currently scraping ... {url}"))
  
  website <- read_html(url)
}


### Scrape full list of individual tropes
trope_list <- tibble(url = paste0("https://tvtropes.org/pmwiki/pagelist_having_pagetype_in_namespace.php?n=Main&t=trope&page=", 1:56)) %>%
  mutate(data = map(url, possibly(get_trope_list, NULL))) %>%
  unnest(data) %>%
  mutate(description = map_chr(trope_url, possibly(get_laconic_description, NA_character_)),
         description = str_replace(description, "^$", NA_character_)) %>%
  select(-url)

### APPENDIX

### Scrape trope index ----------------------------------------------------------------------------
trope_index <- get_trope_index("https://tvtropes.org/pmwiki/index_report.php") %>%
  mutate(trope_url = paste0("https://tvtropes.org", trope_url),
         short_description = map_chr(trope_url, possibly(get_laconic_description, NA_character_)),
         short_description = ifelse(short_description == "", NA_character_, short_description))




### Scrape individual tropes ----------------------------------------------------------------------



### Write to TXT file -----------------------------------------------------------------------------
write_delim(trope_list, "./tv-tropes/tropes.txt")
