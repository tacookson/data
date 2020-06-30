# Sakura Flowering

*Note: Full description forthcoming*



Sakura (Cherry Blossom): https://en.wikipedia.org/wiki/Cherry_blossom#Flower_viewing_in_Japan

*Hanami*: https://simple.wikipedia.org/wiki/Hanami

Data source: http://atmenv.envi.osakafu-u.ac.jp/aono/kyophenotemp4/

Example graph and article: https://www.economist.com/graphic-detail/2017/04/07/japans-cherry-blossoms-are-emerging-increasingly-early

<p align="center">
<img height="500px" src="https://upload.wikimedia.org/wikipedia/commons/thumb/7/77/Chiyoda_Ooku_Hanami.jpg/1920px-Chiyoda_Ooku_Hanami.jpg">
</p>

   

   

# Data Dictionary

### `sakura.csv`

| variable           | class     | description                                                  |
| :----------------- | :-------- | :----------------------------------------------------------- |
| year               | double    | Year CE                                                      |
| temp_c_recon       | double    | Mean March temperature (°C) in Kyoto, reconstructed          |
| temp_c_obs         | double    | Mean March temperature (°C) in Kyoto, observed (first non-missing record is in 1881) |
| flower_doy         | double    | Date of full flowering, in days since beginning of year (Gregorian calendar) |
| flower_date        | date      | Date of full flowering (Gregorian calendar)                  |
| source             | character | Source of phenological data                                  |
| flower_source      | character | Type of data source for flowering date                       |
| flower_source_name | character | Name of data source for flowering date                       |