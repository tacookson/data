
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
         ranking_category = ifelse(year <= 2016, "all", ranking_category),
         image_url = paste0("https://www.yurugp.jp/", image_url)) %>%
  # Get rid of double entries (e.g., due to category changes in 2017)
  distinct(year, ranking_category, rank, character_id, .keep_all = TRUE) %>%
  select(-url)


### Write to TXT file -----------------------------------------------------------------------------
write_tsv(yuru_gp, "./japanese-mascots/yuru-chara-grand-prix.txt")




### APPENDIX (Individual character) ---------------------------------------------------------------
url <- "https://www.yurugp.jp/en/vote/detail.php?id=00004000"

message(url)

website <- read_html(url)

html_nodes(website, "strong") %>% html_text(trim = TRUE) # Rank
html_node(website, ".charaname") %>% html_text(trim = TRUE) # Name
html_node(website, ".en") %>% html_text(trim = TRUE) # English
html_node(website, ".region") %>% html_text(trim = TRUE)