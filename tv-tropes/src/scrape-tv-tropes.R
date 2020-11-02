
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
  
  # Add 2s delay for "polite" scraping
  Sys.sleep(2)
  
  return(df)
}

### Scrape trope index ----------------------------------------------------------------------------
trope_index <- get_trope_index("https://tvtropes.org/pmwiki/index_report.php") %>%
  mutate(trope_url = paste0("https://tvtropes.org", trope_url))




### Scrape individual tropes ----------------------------------------------------------------------



### Write to TXT file -----------------------------------------------------------------------------

