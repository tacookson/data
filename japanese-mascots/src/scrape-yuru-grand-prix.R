
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
  
  # Add 2s delay for "polite" scraping
  Sys.sleep(2)
  
  return(df)
}

# Function to scrape description from individual character page
get_description <- function(url) {
  message(glue("Currently scraping ... {url}"))
  
  website <- read_html(url)

  
  description <- pull_node(website, ".prof")
  
  # Add 2s delay for "polite" scraping
  Sys.sleep(2)
  
  return(description)
}

### Scrape rankings -------------------------------------------------------------------------------
yuru_gp_raw <- crossing(year = 2011:2019,
         page = 1:80) %>%
  mutate(organization = glue("https://www.yurugp.jp/jp/ranking/?year={year}&page={page}&sort=2"),
         area = glue("https://www.yurugp.jp/jp/ranking/?year={year}&page={page}")) %>%
  pivot_longer(organization:area, names_to = "ranking_category", values_to = "url") %>%
  mutate(yuru_chara_data = map(url, possibly(get_yuru_chara, NULL, quiet = FALSE)))

# Clean up dataframe
yuru_gp <- yuru_gp_raw %>%
  unnest(yuru_chara_data) %>%
  mutate(rank = parse_number(rank),
         character_id = str_remove(image_url, "/img/uploads/character/200/"),
         character_id = str_remove(character_id, ".jpg"),
         character_id = parse_number(character_id),
         # Fix rankings to account for there being one category in up to 2016
         # Starting in 2017, there were two categories: area/prefecture and organization
         category = ifelse(year <= 2016, "all", ranking_category),
         image_url = paste0("https://www.yurugp.jp/", image_url)) %>%
  # Get rid of double entries (e.g., due to category changes in 2017)
  distinct(year, ranking_category, rank, character_id, .keep_all = TRUE) %>%
  # Select desired fields and drop fields used only for scraping
  select(year:rank, character_id, name:image_url)


### Scrape descriptions ---------------------------------------------------------------------------
descriptions <- yuru_gp %>%
  distinct(character_id) %>%
  mutate(padded_character_id = str_pad(character_id, 4, side = "left", pad = "0"),
         url = paste0("https://www.yurugp.jp/en/vote/detail.php?id=0000", padded_character_id)) %>%
  mutate(description = map(url, possibly(get_description, NULL, quiet = FALSE))) %>%
  unnest(description) %>%
  select(character_id, description)
  

### Write to TXT file -----------------------------------------------------------------------------
write_tsv(yuru_gp, "./japanese-mascots/raw/yuru-gp-japanese.txt")

write_tsv(descriptions, "./japanese-mascots/raw/descriptions-japanese.txt")
