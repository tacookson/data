# Sakura Flowering

[*Hanami*](https://simple.wikipedia.org/wiki/Hanami) ("flower-viewing") is a Japanese tradition over 1,000 years old that is usually associated with the flowering of the [sakura (cherry blossom)](https://en.wikipedia.org/wiki/Cherry_blossom#Flower_viewing_in_Japan) tree.



Newspapers have recorded the dates of full flowering in Kyoto since the late 19th century, but researchers have estimated flowering dates as far back as 812 CE using historical records like diary entries about *hanami* parties. These dates have been used in [paleoclimatology](https://en.wikipedia.org/wiki/Paleoclimatology) studies to estimate March temperatures in Kyoto since the 9th century. (There is a relationship between the temperatures in March and when sakura trees flower.)



Publications like *The Economist* have [featured this data](https://www.economist.com/graphic-detail/2017/04/07/japans-cherry-blossoms-are-emerging-increasingly-early) to demonstrate how climate change is leading to warmer March temperatures and, subsequently, earlier flowering dates.



Data is from Prof. Yasuyuki Aono's [website](http://atmenv.envi.osakafu-u.ac.jp/aono/kyophenotemp4/) and used in the following publications:

> Aono and Saito (2010; International Journal of Biometeorology, 54, 211-219)

> Aono and Kazui (2008; International Journal of Climatology, 28, 905-914)

The study is also listed on the National Centers for Environmental Information (NOAA) [website](https://www.ncdc.noaa.gov/paleo-search/study/26430)



<p align="center">
<img height="500px" src="https://upload.wikimedia.org/wikipedia/commons/thumb/7/77/Chiyoda_Ooku_Hanami.jpg/1920px-Chiyoda_Ooku_Hanami.jpg">
</p>

### 

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

| variable | class | description |
| :------- | :---- | :---------- |
|          |       |             |
|          |       |             |
|          |       |             |
|          |       |             |
|          |       |             |
|          |       |             |
|          |       |             |
|          |       |             |

