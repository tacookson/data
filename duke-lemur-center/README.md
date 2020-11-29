# Duke Lemur Center

*Work in progress*



#### Data Source

[Duke Lemur Center](https://lemur.duke.edu/)



# Data Dictionary

### `animals.txt`

| variable              | class     | description                                                  |
| :-------------------- | :-------- | :----------------------------------------------------------- |
| animal_id             | character | Duke Lemur Center (DLC) animal ID                            |
| studbook_id           | character | Studbook ID, assigned by [AZA (Association of Zoos & Aquariums)](https://www.aza.org/studbooks?locale=en) |
| name                  | character | Animal name                                                  |
| taxonomic_code        | character | Taxonomic code (first letter is usually genus, followed by three letters indicating species) |
| species               | character | Common name of species                                       |
| sex                   | character | Sex                                                          |
| birth_date            | date      | Date of birth                                                |
| birth_type            | character | Born in captivity or the wild                                |
| litter_size           | double    | Size of litter animal was born into (including the focal animal) |
| death_date            | date      | Date of death                                                |
| mother_id             | character | Unique identifier for animal's mother (Duke Lemur Center ID, `animal_id`, is preferred if there is one) |
| mother_name           | character | Name of animal's mother                                      |
| mother_taxonomic_code | character | Taxonomic code of animal's mother                            |
| mother_species        | character | Species of animal's mother                                   |
| mother_birth_date     | date      | Date of birth of animal's mother                             |
| father_id             | character | Unique identifier for animal's father (Duke Lemur Center ID, `animal_id`, is preferred if there is one). If there are multiple possible fathers, this is indicated with "multiple", followed by the number of possible fathers in parentheses. |
| father_name           | character | Name of animal's father                                      |
| father_taxonomic_code | character | Taxonomic code of animal's father                            |
| father_species        | character | Species of animal's father                                   |
| father_birth_date     | date      | Date of birth of animal's father                             |



### `weights.txt`

| variable           | class     | description                                       |
| :----------------- | :-------- | :------------------------------------------------ |
| animal_id          | character | Duke Lemur Center (DLC) animal ID                 |
| weight_g           | double    | Weight (in grams) on `weight_date`                |
| weight_date        | date      | Date the animal was weighed                       |
| is_pregnant        | logical   | Was the animal pregnant on `weight_date`          |
| conception_date    | date      | Date of conception (if pregnant)                  |
| infant_birth_date  | date      | Eventual date the animal gave birth (if pregnant) |
| infant_litter_size | double    | Eventual litter size (if pregnant)                |