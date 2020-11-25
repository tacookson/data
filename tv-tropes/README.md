# TV Tropes

*Work in progress*



Data is from [TV Tropes](https://tvtropes.org/)



# Data Dictionary

### `tropes.txt`

| variable             | class     | description                                                  |
| :------------------- | :-------- | :----------------------------------------------------------- |
| trope_name | character | Name of trope |
| trope_url | character | Link to trope page on [TV Tropes](https://tvtropes.org/) |
| description | character | Short description |



### `shows.txt`

| variable   | class     | description                                                  |
| :--------- | :-------- | :----------------------------------------------------------- |
| show_id    | integer   | Unique identifier for show                                   |
| show_name  | character | Show name                                                    |
| trope_name | character | Name of trope associated with the show (can be linked to `tropes` dataset) |




### `show_tags.txt`

| variable  | class     | description                  |
| :-------- | :-------- | :--------------------------- |
| show_id   | integer   | Unique identifier for show   |
| show_name | character | Show name                    |
| tag       | character | Tag associated with the show |
