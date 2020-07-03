# Himalayan Climbing Expeditions

Data is from [The Himalayan Database](https://www.himalayandatabase.com/):

>The Himalayan Database is a compilation of records for all expeditions that have climbed in the Nepal Himalaya. The database is based on the expedition archives of Elizabeth Hawley, a longtime journalist based in Kathmandu, and it is supplemented by information gathered from books, alpine journals and correspondence with Himalayan climbers.
>
>The data cover all expeditions from 1905 through Spring 2019 to more than 465 significant peaks in Nepal. Also included are expeditions to both sides of border peaks such as Everest, Cho Oyu, Makalu and Kangchenjunga as well as to some smaller border peaks. Data on expeditions to trekking peaks are included for early attempts, first ascents and major accidents.



![](https://upload.wikimedia.org/wikipedia/commons/2/25/Himalayas_landsat_7.png)



# Data Dictionary

### `peaks.csv`

| variable                   | class     | description                                                  |
| :------------------------- | :-------- | :----------------------------------------------------------- |
| peak_id                    | character | Unique identifier for peak                                   |
| peak_name                  | character | Common name of peak                                          |
| peak_alternative_name      | character | Alternative name of peak (for example, the "Mount Everest" is "Sagarmatha" in Nepalese) |
| height_metres              | double    | Height of peak in metres                                     |
| climbing_status            | character | Whether the peak has been climbed                            |
| first_ascent_year          | double    | Year of first successful ascent, if applicable               |
| first_ascent_country       | character | Country name(s) of expedition members part of the first ascent. Can have multiple values if members were from different countries. Country name is as of date of ascent (for example, "W Germany" for ascents before 1990). |
| first_ascent_expedition_id | character | Unique identifier for expedition. Can be linked to `expeditions` or `members` tables. |



### `expeditions.csv`

| variable           | class     | description                                                  |
| :----------------- | :-------- | :----------------------------------------------------------- |
| expedition_id      | character | Unique identifier for expedition. Can be linked to `peaks` or `members` tables. |
| peak_id            | character | Unique identifier for peak. Can be linked to `peaks` table.  |
| peak_name          | character | Common name for peak                                         |
| year               | double    | Year of expedition                                           |
| season             | character | Season of expedition (Spring, Summer, etc.)                  |
| basecamp_date      | date      | Date of expedition arrival at basecamp                       |
| highpoint_date     | date      | Date of expedition summiting the peak for the first time or, if peak wasn't reached, date of reaching its highpoint |
| termination_date   | date      | Date the expedition was terminated                           |
| termination_reason | character | Primary reason the expedition was terminated. There are two possibilities for a successful expeditions, depending on whether the main peak or a sub-peak was summitted. |
| highpoint_metres   | double    | Elevation highpoint of the expedition                        |
| members            | double    | Number of expedition members. For expeditions in Nepal, this is usually the number of foreigners listed on the expedition permit. For expeditions in China, this is usually the number of non-hired members. |
| member_deaths      | double    | Number of expeditions members who died                       |
| hired_staff        | double    | Number of hired staff who went above basecamp                |
| hired_staff_deaths | double    | Number of hired staff who died                               |
| oxygen_used        | logical   | Whether oxygen was used by at least one member of the expedition |
| trekking_agency    | character | Name of the trekking agency                                  |



### `members.csv`

| variable             | class     | description                                                  |
| :------------------- | :-------- | :----------------------------------------------------------- |
| expedition_id        | character | Unique identifier for expedition. Can be linked to `peaks` or `members` tables. |
| member_id            | character | Unique identifier for the person. This is *not* consistent across expeditions, so you cannot use a single `member_id` to look up all expeditions a person was part of. |
| peak_id              | character | Unique identifier for peak. Can be linked to `peaks` table.  |
| peak_name            | character | Common name for peak                                         |
| year                 | double    | Year of expedition                                           |
| season               | character | Season of expedition (Spring, Summer, etc.)                  |
| sex                  | character | Sex of the person                                            |
| age                  | double    | Age of the person. Depending on the best available data, this could be as of the summit date, the date of death, or the date of arrival at basecamp. |
| citizenship          | character | Citizenship of the person                                    |
| expedition_role      | character | Role of the person on the expedition                         |
| hired                | logical   | Whether the person was hired by the expedition               |
| highpoint_metres     | double    | Elevation highpoint of the person                            |
| success              | logical   | Whether the person was successful in summitting a main peak or sub-peak, depending on the goal of expedition |
| solo                 | logical   | Whether the person attempted a solo ascent                   |
| oxygen_used          | logical   | Whether the person used oxygen                               |
| died                 | logical   | Whether the person died                                      |
| death_cause          | character | Primary cause of death                                       |
| death_height_metres  | double    | Height at which the person died                              |
| injured              | logical   | Whether the person was injured                               |
| injury_type          | character | Primary cause of injury                                      |
| injury_height_metres | double    | Height at which the injury occurred                          |
