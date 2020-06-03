# Children's Book Ratings

Data is meant to feed into a blog post on empirical Bayes estimation on [alexcookson.com](https://www.alexcookson.com).



# Data Dictionary

### `childrens-books.txt`

| variable              | class     | description                                                  |
| :-------------------- | :-------- | :----------------------------------------------------------- |
| isbn10                | character | Ten-digit ISBN (International Standard Book Number)          |
| isbn13                | character | Thirteen-digit ISBN (International Standard Book Number)     |
| title                 | character | Book title                                                   |
| author                | character | Book author, illustrator, translator, etc.                   |
| description           | character | Brief description, sometimes only partial and cut off mid-sentence |
| cover                 | character | Cover type (e.g., hardcover, paperback)                      |
| publisher             | character | Publisher                                                    |
| original_publish_year | double    | Original year of publishing (if publishing date is different than `publish_year`) |
| publish_year          | double    | Year of publishing                                           |
| rating                | double    | Mean rating (out of 5)                                       |
| rating_5              | double    | Number of 5-star ratings                                     |
| rating_4              | double    | Number of 4-star ratings                                     |
| rating_3              | double    | Number of 3-star ratings                                     |
| rating_2              | double    | Number of 2-star ratings                                     |
| rating_1              | double    | Number of 1-star ratings                                     |
