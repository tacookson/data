```
# Broadway Weekly Grosses

The data this week comes from [Playbill](https://www.playbill.com/grosses).

This [blog post](LINK_TO_ARTICLE) talks about Broadway Grosses in greater detail.

Credit: [Alex Cookson](https://twitter.com/alexcookson)


# Data Dictionary

### `grosses.csv`

| variable                      | class      | description |
|:------------------------------|:-----------|:------------|
| week_ending                   | date       | Date of the end of the weekly measurement period. Always a Sunday. |
| week_number                   | double     | Week number in the Broadway season. The season starts after the Tony Awards, held in early June. Some seasons have 53 weeks. |
| weekly_gross_overall          | double     | Weekly box office gross for all shows. |
| show                          | character  | Name of show. Some shows have the same name, but multiple runs.  |
| theatre                       | character  | Name of theatre |
| weekly_gross                  | double     | Weekly box office gross for individual show |
| potential_gross               | double     | Weekly box office gross if all seats are sold at full price. Shows can exceed their potential gross by selling premium tickets and/or standing room tickets. |
| avg_ticket_price              | double     | Average price of tickets sold |
| top_ticket_price              | double     | Highest price of tickets sold |
| seats_sold                    | double     | Total seats sold for all performances and previews |
| seats_in_theatre              | double     | Theatre seat capacity |
| pct_capacity                  | double     | Percent of theatre capacity sold. Shows can exceed 100% capacity by selling standing room tickets. |
| performances                  | double     | Number of performances in the week |
| previews                      | double     | Number of preview performances in the week. Previews occur before a show's official open. |


### `synopses.csv`

| variable                      | class      | description |
|:------------------------------|:-----------|:------------|
| show                          | character  | Name of show |
| synopsis                      | character  | Plot synopsis of show. Contains some missing values, especially for shows with multiple runs (due to how the data was collected). |
```