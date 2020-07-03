# Caribou Location Tracking

This data tracks [woodland caribou](https://en.wikipedia.org/wiki/Boreal_woodland_caribou) in northern British Columbia, a Canadian province. It consists of almost 250,000 location tags of 260 caribou, from 1988 to 2016.

The tracking was part of a study prepared in 2014 by the [B.C. Ministry of Environment & Climate Change](https://gov.bc.ca/env) to inform the management and recovery of the species, which is [classified as "Vulnerable"](https://www.iucnredlist.org/species/29742/22167140) on the International Union for the Conservation of Nature's (IUCN) [Red List](https://www.iucnredlist.org/).

Data was accessed through [Movebank](https://www.movebank.org/cms/movebank-content/about-movebank), "a free online platform that helps researchers manage, share, analyze and archive animal movement data."

![https://upload.wikimedia.org/wikipedia/commons/0/0e/Une_m%C3%A8re_caribou_allaite_son_petit.jpg](https://upload.wikimedia.org/wikipedia/commons/0/0e/Une_mère_caribou_allaite_son_petit.jpg)



**Original article citation**

> BC Ministry of Environment (2014) Science update for the South Peace Northern Caribou (Rangifer tarandus caribou pop. 15) in British Columbia. Victoria, BC. 43 p. url:https://www2.gov.bc.ca/assets/gov/environment/plants-animals-and-ecosystems/wildlife-wildlife-habitat/caribou/science_update_final_from_web_jan_2014.pdf



**Data package citation**

> Seip DR, Price E (2019) Data from: Science update for the South Peace Northern Caribou (Rangifer tarandus caribou pop. 15) in British Columbia. Movebank Data Repository. https://doi.org/10.5441/001/1.p5bn656k





# Data Dictionary

"Deployment" refers to when the animal was fitted with a location-tracking tag.



### `individuals.csv`

| variable             | class     | description                                                  |
| :------------------- | :-------- | :----------------------------------------------------------- |
| animal_id            | character | Individual identifier for animal                             |
| sex                  | character | Sex of animal                                                |
| life_stage           | character | Age class (in years) at beginning of deployment              |
| pregnant             | logical   | Whether animal was pregnant at beginning of deployment       |
| with_calf            | logical   | Whether animal had a calf at time of deployment              |
| death_cause          | character | Cause of death                                               |
| study_site           | character | Deployment site or colony, or a location-related group such as the herd or pack name |
| deploy_on_longitude  | double    | Longitude where animal was released at beginning of deployment |
| deploy_on_latitude   | double    | Latitude where animal was released at beginning of deployment |
| deploy_on_comments   | character | Additional information about tag deployment                  |
| deploy_off_longitude | double    | Longitude where deployment ended                             |
| deploy_off_latitude  | double    | Latitude where deployment ended                              |
| deploy_off_type      | character | Classification of tag deployment end (see table below for full description) |
| deploy_off_comments  | character | Additional information about tag deployment end              |



**`deploy_off_type` classifications**

| deploy_off_type   | description                                                  |
| :---------------- | :----------------------------------------------------------- |
| captured          | Tag remained on the animal but the animal was captured or confined |
| dead              | Deployment ended with the death of the animal that was carrying the tag |
| equipment failure | Tag stopped working                                          |
| fall off          | Attachment of the tag to the animal failed, and it fell of accidentally |
| other             | Catch-all category for other deployment end types            |
| released          | Tag remained on the animal but the animal was released from captivity or confinement |
| removal           | Tag was purposefully removed from the animal                 |
| unknown           | Deployment ended by an unknown cause                         |





### `locations.csv`

| variable   | class     | description                                                  |
| :--------- | :-------- | :----------------------------------------------------------- |
| event_id   | double    | Identifier for an individual measurement                     |
| animal_id  | character | Individual identifier for animal                             |
| study_site | character | Deployment site or colony, or a location-related group such as the herd or pack name |
| season     | character | Season (Summer/Winter) at time of measurement                |
| timestamp  | datetime  | Date and time of measurement                                 |
| longitude  | double    | Longitude of measurement                                     |
| latitude   | double    | Latitude of measurement                                      |

