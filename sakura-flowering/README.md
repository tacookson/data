# Sakura Flowering

[*Hanami*](https://simple.wikipedia.org/wiki/Hanami) ("flower-viewing") is a Japanese tradition over 1,000 years old that is usually associated with the flowering of the [sakura (cherry blossom)](https://en.wikipedia.org/wiki/Cherry_blossom#Flower_viewing_in_Japan) tree.



#### Historical Sakura Flowering

##### (812-2015, Kyoto only)

Newspapers have recorded the dates of full flowering in Kyoto since the late 19th century, but researchers have estimated flowering dates as far back as 812 CE using historical records like diary entries about *hanami* parties. These dates have been used in [paleoclimatology](https://en.wikipedia.org/wiki/Paleoclimatology) studies to estimate March temperatures in Kyoto since the 9th century. (There is a relationship between the temperatures in March and when sakura trees flower in Kyoto.)



Publications like *The Economist* have [featured this data](https://www.economist.com/graphic-detail/2017/04/07/japans-cherry-blossoms-are-emerging-increasingly-early) to demonstrate how climate change is leading to warmer March temperatures and, subsequently, earlier flowering dates.



`sakura-historical` data is from Prof. Yasuyuki Aono's [website](http://atmenv.envi.osakafu-u.ac.jp/aono/kyophenotemp4/) and used in the following publications:

> Aono and Saito (2010; International Journal of Biometeorology, 54, 211-219)

> Aono and Kazui (2008; International Journal of Climatology, 28, 905-914)

The study is also listed on the National Centers for Environmental Information (NOAA) [website](https://www.ncdc.noaa.gov/paleo-search/study/26430)



#### Modern Sakura Flowering

##### (1953-2019, Japan-wide)

Since at least 1953, the [Japan Meteorological Agency](https://en.wikipedia.org/wiki/Japan_Meteorological_Agency) (JMA) has recorded the flowering of sakura trees across the country. The [*sakura zensen*](https://en.wikipedia.org/wiki/Cherry_blossom_front) ("cherry blossom front") generally moves from Kyushu (Japan's southernmost main island) in March, to Hokkaido (the northernmost main island) in May.

`sakura-modern` flowering data is from the Japan Meteorological Agency's page on [phenological observation data](http://www.data.jma.go.jp/sakura/data/). Temperature data is from the JMA's [tables of monthly climate statistics (air temperature)](https://www.data.jma.go.jp/obd/stats/data/en/smp/index.html) Station data is from the agency's [page on WIGOS stations](https://www.jma.go.jp/jma/kishou/books/station/station.html).



<p align="center">
<img height="500px" src="https://upload.wikimedia.org/wikipedia/commons/thumb/7/77/Chiyoda_Ooku_Hanami.jpg/1920px-Chiyoda_Ooku_Hanami.jpg">
</p>


# Data Dictionary

### `sakura-historical.csv`

| variable           | class     | description                                                  |
| :----------------- | :-------- | :----------------------------------------------------------- |
| year               | double    | Year CE                                                      |
| temp_c_recon       | double    | Mean March temperature (°C) in Kyoto, reconstructed          |
| temp_c_obs         | double    | Mean March temperature (°C) in Kyoto, observed (first non-missing record is in 1881) |
| flower_doy         | double    | Date of full flowering, in days since beginning of year (Gregorian calendar) |
| flower_date        | date      | Date of full flowering (Gregorian calendar)                  |
| flower_source      | character | Type of data source for flowering date                       |
| flower_source_name | character | Name of data source for flowering date                       |
| study_source       | character | Source of phenological data (paper/study)                    |



### `sakura-modern.csv`

| variable        | class     | description                                                 |
| :-------------- | :-------- | :---------------------------------------------------------- |
| station_id      | double    | Station identifier (from World Meteorological Organization) |
| station_name    | character | Location name (usually a city)                              |
| latitude        | double    | Decimal latitude coordinate                                 |
| longitude       | double    | Decimal longitude coordinate                                |
| year            | double    | Year                                                        |
| flower_date     | date      | Date of flowering                                           |
| flower_doy      | double    | Day of year of flowering                                    |
| full_bloom_date | date      | Date of full bloom                                          |
| full_bloom_doy  | double    | Day of year of full bloom                                   |



### `temperatures-modern.csv`

| variable     | class     | description                                                  |
| :----------- | :-------- | :----------------------------------------------------------- |
| station_id   | double    | Station identifier (from World Meteorological Organization)  |
| station_name | character | Location name (usually a city)                               |
| year         | double    | Year of measurement                                          |
| month        | character | Month of measurement                                         |
| month_date   | date      | Date-formatted month of measurement (note: measurement is for the entire month, not just the 1st day) |
| mean_temp_c  | double    | Monthly mean air temperature (°C)                            |

