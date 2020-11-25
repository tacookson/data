
### Load packages ---------------------------------------------------------------------------------
library(tidyverse)
library(rvest)
library(glue)


### Define functions ------------------------------------------------------------------------------

# (Helper function) Read website node and convert to text -------------------------------
pull_node <- function(website, node) {
  html_nodes(website, node) %>% html_text(trim = TRUE)
}

# Scrape full list of tropes ------------------------------------------------------------
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
  
  # 2s delay for "polite" scraping
  Sys.sleep(2)
  
  return(df)
}

# Get the "laconic" (very short) description of a trope ---------------------------------
get_laconic_description <- function(url) {
  laconic_url <- str_replace(url, "Main", "Laconic")
  
  message(glue("Currently scraping ... {laconic_url}"))
  
  description <- read_html(laconic_url) %>%
    html_node("#main-article p") %>%
    html_text()
  
  # 1s delay for "polite" scraping
  Sys.sleep(1)
 
  return(description)
}

# Scrape American TV series list --------------------------------------------------------
get_tv_shows <- function(url) {
  message(glue("Currently scraping ... {url}"))
  
  website <- read_html(url)
  
  data <- list(
    show_name = pull_node(website, ".twikilink"),
    show_url = html_nodes(website, ".twikilink") %>% html_attr("href")
  )
  
  df <- tibble(data = data) %>%
    mutate(field = names(data)) %>%
    pivot_wider(names_from = field, values_from = data) %>%
    unnest(cols = everything())
  
  return(df)
}

# Scrape related tropes on a media page -------------------------------------------------
get_related_tropes <- function(url) {
  message(glue("Currently scraping ... {url}"))
  
  df <- read_html(url) %>%
    html_nodes(".twikilink") %>%
    html_attr("href")
  
  # 2s delay for "polite" scraping
  Sys.sleep(2)
  
  return(df)
}

# Scrape index tags on a media page -----------------------------------------------------
get_index_tags <- function(url) {
  message(glue("Currently scraping ... {url}"))
  
  df <- read_html(url) %>%
    pull_node(".links li:nth-child(2)")
  
  # 2s delay for "polite" scraping
  Sys.sleep(2)
  
  return(df)
}


### Scrape trope data -----------------------------------------------------------------------------
### NOTE: THIS TAKES A WHILE (~ 8 HOURS) DUE TO THE NUMBER OF TROPES (~ 28,000) AND
### AND POLITE SCRAPING IN OUR FUNCTION (1-SECOND DELAY BETWEEN SCRAPES)

# Full list of individual tropes ---------------------------------------------------------
tropes <- tibble(url = paste0("https://tvtropes.org/pmwiki/pagelist_having_pagetype_in_namespace.php?n=Main&t=trope&page=",
                                  1:56)) %>%
  mutate(data = map(url, possibly(get_trope_list, NULL))) %>%
  unnest(data) %>%
  mutate(description = map_chr(trope_url, possibly(get_laconic_description, NA_character_)),
         description = str_replace(description, "^$", NA_character_)) %>%
  distinct(trope_name, trope_url, .keep_all = TRUE) %>%
  select(-url)

# List of American TV shows -------------------------------------------------------------
show_list <- get_tv_shows("https://tvtropes.org/pmwiki/pmwiki.php/Main/AmericanSeries") %>%
  mutate(show_url = paste0("https://tvtropes.org", show_url)) %>%
  distinct(show_name, show_url) %>%
  mutate(show_id = row_number())

# Related tropes in shows ---------------------------------------------------------------
shows <- show_list %>%
  mutate(trope_url = map(show_url, possibly(get_related_tropes, NULL))) %>%
  unnest(trope_url) %>%
  mutate(trope_url = paste0("http://tvtropes.org", trope_url)) %>%
  # We scraped all hyperlinks, so an inner_join will filter out non-trope links
  # (semi_join would probably work better, but I had already run this code)
  inner_join(tropes %>% select(-description), by = "trope_url") %>%
  select(show_id, show_name, trope_name)

# Index tags of shows -------------------------------------------------------------------
tags <- show_list %>%
  mutate(tag = map(show_url, possibly(get_index_tags, NULL))) %>%
  unnest(tag) %>%
  filter(!str_detect(tag, "ImageSource"),
         !str_detect(tag, "QuoteSource"),
         !str_detect(tag, "Administrivia"),
         !str_detect(tag, "VideoSource")) %>%
  select(show_id, show_name, tag)


### Write to TXT file -----------------------------------------------------------------------------
write_tsv(tropes, "./tv-tropes/tropes.txt")

write_tsv(shows, "./tv-tropes/shows.txt")

write_tsv(tags, "./tv-tropes/show_tags.txt")