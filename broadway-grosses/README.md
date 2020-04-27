# Broadway Weekly Grosses

This data comes from [Playbill](https://www.playbill.com/grosses). Weekly box office grosses comprise data on revenue and attendance figures for theatres that are part of [The Broadway League](https://en.wikipedia.org/wiki/The_Broadway_League), an industry association for, you guessed it, Broadway theatre.

CPI data is from the [U.S. Bureau of Labor Statistics](https://www.bls.gov/). There are many, *many* measures of CPI, so the one used here is "All items less food and energy in U.S. city average, all urban consumers, seasonally adjusted" (table [CUSR0000SA0L1E](https://beta.bls.gov/dataViewer/view/timeseries/CUSR0000SA0L1E)).



# Data Dictionary

### `grosses.csv`

| variable             | class     | description                                                  |
| :------------------- | :-------- | :----------------------------------------------------------- |
| week_ending          | date      | Date of the end of the weekly measurement period. Always a Sunday. |
| week_number          | double    | Week number in the Broadway season. The season starts after the Tony Awards, held in early June. Some seasons have 53 weeks. |
| weekly_gross_overall | double    | Weekly box office gross for all shows                        |
| show                 | character | Name of show. Some shows have the same name, but multiple runs. |
| theatre              | character | Name of theatre. Only shows most recent theatre for shows that started at one theatre and moved to another (e.g., *The Lion King* will show Minskoff Theatre even though it played at New Amsterdam Theatre from 1997-2006).                                              |
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



### `cpi.csv`

| variable   | class  | description                                    |
| :--------- | :----- | :--------------------------------------------- |
| year_month | date   | Month of CPI value                             |
| cpi        | double | Consumer Price Index value for the given month |



### `pre-1985-starts.csv`

| variable       | class     | description                                                  |
| :------------- | :-------- | :----------------------------------------------------------- |
| week_ending    | date      | Date of the end of the weekly measurement period             |
| show           | character | Name of show                                                 |
| run_start_week | date      | Starting week for shows that premiered before `1985-06-08` (the start of the dataset) |
