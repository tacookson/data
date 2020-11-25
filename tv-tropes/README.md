# TV Tropes

According to the website [TV Tropes](https://tvtropes.org/)...

> A [trope](https://tvtropes.org/pmwiki/pmwiki.php/Main/Trope) is a storytelling device or convention, a shortcut for describing situations the storyteller can reasonably assume the audience will recognize. Tropes are the means by which a story is told by anyone who has a story to tell.



Some interesting examples of tropes include:

- [Running Gag](https://tvtropes.org/pmwiki/pmwiki.php/Main/RunningGag), like Dean Pelton's dean-related puns in *Community* (there is even a sub-trope called [Overused Running Gag](https://tvtropes.org/pmwiki/pmwiki.php/Main/OverusedRunningGag))
- [Air Vent Passageway](https://tvtropes.org/pmwiki/pmwiki.php/Main/AirVentPassageway), when people are trapped in a room and escape through the air vents, like in *Die Hard* or many episode of *Star Trek* (Jefferies Tube)
- [Wham Episode](https://tvtropes.org/pmwiki/pmwiki.php/Main/WhamEpisode), an episode in a series "where the story takes a sudden dramatic turn. Things will never be quite the same again." A lot of episodes of *Game of Thrones* are wham episodes, but a notable example is when Ned Stark is executed.



<p align="center">
<img src="https://www.mediavillage.com/media/articles/i-love-lucy-ss2.jpg.1440x1000_q85_box-74%2C0%2C529%2C315_crop_detail.jpg" alt="https://www.mediavillage.com/media/articles/i-love-lucy-ss2.jpg.1440x1000_q85_box-74%2C0%2C529%2C315_crop_detail.jpg" style="zoom:125%;" />
</p>




#### Data Source

The data, needless to say, is from [TV Tropes](https://tvtropes.org/). This data includes all individual tropes, but because of how extensive the site is, only includes shows and related tropes for American television series.



# Data Dictionary

### `tropes.txt`

| variable             | class     | description                                                  |
| :------------------- | :-------- | :----------------------------------------------------------- |
| trope | character | Name of trope |
| trope_url | character | Link to trope page on [TV Tropes](https://tvtropes.org/) |
| description | character | Short description |



### `shows.txt`

| variable   | class     | description                                                  |
| :--------- | :-------- | :----------------------------------------------------------- |
| show_id    | integer   | Unique identifier for show                                   |
| show       | character | Show name                                                    |
| trope_name | character | Name of trope associated with the show (can be linked to `tropes` dataset) |




### `show_tags.txt`

| variable | class     | description                  |
| :------- | :-------- | :--------------------------- |
| show_id  | integer   | Unique identifier for show   |
| show     | character | Show name                    |
| tag      | character | Tag associated with the show |
