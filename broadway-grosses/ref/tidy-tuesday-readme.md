# Broadway Weekly Grosses

The data this week comes from [Playbill](https://www.playbill.com/grosses).

This [blog post](LINK_TO_ARTICLE) talks about Broadway Grosses in greater detail.

Credit: [Alex Cookson](https://twitter.com/alexcookson)




# Data Dictionary

### `grosses.csv`

| variable             | class     | description                                                  |
| :------------------- | :-------- | :----------------------------------------------------------- |
| week_ending          | date      | Date of the end of the weekly measurement period. Always a Sunday. |
| week_number          | double    | Week number in the Broadway season. The season starts after the Tony Awards, held in early June. Some seasons have 53 weeks. |
| weekly_gross_overall | double    | Weekly box office gross for all shows                        |
| show                 | character | Name of show. Some shows have the same name, but multiple runs. |
| theatre              | character | Name of theatre                                              |
| weekly_gross         | double    | Weekly box office gross for individual show                  |
| potential_gross      | double    | Weekly box office gross if all seats are sold at full price. Shows can exceed their potential gross by selling premium tickets and/or standing room tickets. |
| avg_ticket_price     | double    | Average price of tickets sold                                |
| top_ticket_price     | double    | Highest price of tickets sold                                |
| seats_sold           | double    | Total seats sold for all performances and previews           |
| seats_in_theatre     | double    | Theatre seat capacity                                        |
| pct_capacity         | double    | Percent of theatre capacity sold. Shows can exceed 100% capacity by selling standing room tickets. |
| performances         | double    | Number of performances in the week                           |
| previews             | double    | Number of preview performances in the week. Previews occur before a show's official open. |



### `synopses.csv`

| variable | class     | description                                                  |
| :------- | :-------- | :----------------------------------------------------------- |
| show     | character | Name of show                                                 |
| synopsis | character | Plot synopsis of show. Contains some missing values, especially for shows with multiple runs (due to how the data was collected). |



# Cleaning Script

```R
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
  write_csv("grosses.csv")




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
  write_csv("synopses.csv")
```