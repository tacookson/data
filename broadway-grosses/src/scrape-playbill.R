
# Load packages
library(tidyverse)
library(lubridate)
library(rvest)


# Weekly grosses
### Create function to scrape grosses table
get_playbill_data = function(url) {
  message(url)
  
  website <- read_html(url)
  
  show_stats <- list(
    week_number = html_nodes(website, ".week-count .accent") %>% html_text(trim = TRUE),
    weekly_gross_overall = html_nodes(website, ".week-total .accent") %>% html_text(trim = TRUE),
    show = html_nodes(website, ".col-0 .data-value") %>% html_text(trim = TRUE),
    theatre = html_nodes(website, ".col-0 .subtext") %>% html_text(trim = TRUE),
    weekly_gross = html_nodes(website, ".col-1 .data-value") %>% html_text(trim = TRUE),
    potential_gross = html_nodes(website, "td.col-1 .subtext") %>% html_text(trim = TRUE),
    avg_ticket_price = html_nodes(website, ".col-3 .data-value") %>% html_text(trim = TRUE),
    top_ticket_price = html_nodes(website, "td.col-3 .subtext") %>% html_text(trim = TRUE),
    seats_sold = html_nodes(website, ".col-4 .data-value") %>% html_text(trim = TRUE),
    seats_in_theatre = html_nodes(website, "td.col-4 .subtext") %>% html_text(trim = TRUE),
    pct_capacity = html_nodes(website, ".col-6 .data-value") %>% html_text(trim = TRUE),
    performances = html_nodes(website, ".col-5 .data-value") %>% html_text(trim = TRUE),
    previews = html_nodes(website, "td.col-5 .subtext") %>% html_text(trim = TRUE)
  )
  
  tibble(show_stats = show_stats) %>%
    mutate(variable_name = names(show_stats)) %>%
    pivot_wider(names_from = variable_name, values_from = show_stats) %>%
    unnest(cols = everything())
}


### Create tibble with list of URLs and scrape data
### TAKES A LONG TIME (~10 HOURS)
broadway_grosses_raw <-
  tibble(week_ending = seq(ymd("1985-06-09"), ymd("2020-03-01"), by = "1 week")) %>%
  mutate(grosses_url = paste0("https://www.playbill.com/grosses?week=", week_ending)) %>%
  mutate(week_data = map(grosses_url, possibly(get_playbill_data, NULL, quiet = FALSE)))

### Clean grosses data
broadway_grosses <- broadway_grosses_raw %>%
  unnest(week_data, keep_empty = TRUE) %>%
  mutate_at(vars(week_number:weekly_gross_overall, weekly_gross:previews),
            parse_number) %>%
  mutate(
    pct_capacity = pct_capacity / 100,
    show = stringi::stri_trans_general(show, "Latin-ASCII")
  ) %>%
  mutate_at(vars(potential_gross, top_ticket_price), ~ ifelse(. == 0, NA, .)) %>%
  select(-grosses_url)

### Write to CSV
broadway_grosses %>%
  write_csv("./broadway-grosses/grosses.csv")




# Show synopses
### Create function to scrape show synopses
get_synopsis <- function(url) {
  message(url)
  
  read_html(url) %>%
    html_nodes(".spotlight-search-result .bsp-list-promo-desc") %>%
    html_text(trim = TRUE)
}

synopses_raw <- broadway_grosses %>%
  distinct(show) %>%
  mutate(
    synopsis_url = paste0(
      "https://www.playbill.com/searchpage/search?q=",
      urltools::url_encode(show),
      "&qasset="
    ),
    synopsis = map(
      synopsis_url,
      possibly(get_synopsis, NA_character_, quiet = FALSE)
    )
  )

# Clean synopsis data
synopses <- synopses_raw %>%
  select(-synopsis_url) %>%
  unnest(cols = c(synopsis), keep_empty = TRUE)

### Write to CSV
synopses %>%
  write_csv("./broadway-grosses/synopses.csv")