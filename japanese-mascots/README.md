# Japanese Mascots (Yuru-chara)

[Yuru-chara](https://en.wikipedia.org/wiki/Yuru-chara) are Japanese mascot characters, often representing towns or organizations. Western audiences, if they are familiar with yuru-chara at all, might know [*Chiitan*](https://en.wikipedia.org/wiki/Chiitan), who was featured on *Last Week Tonight With John Oliver*. These mascots are often silly and whimsical, and they are definitely [*kawaii*](https://en.wikipedia.org/wiki/Kawaii) (cute)! For example, here is *Chiyopen*, the mascot for the Chiyoda Real Estate Company:

![Chiyopen](https://www.yurugp.jp/img/uploads/character/650/00001884.jpg)

The Twitter account [Mondo Mascots](https://twitter.com/mondomascots) regularly posts pictures and descriptions of the many mascots that exist. Chris Carlier, curator of Mondo Mascots, was also featured on an episode of *99% Invisible*, [Return of the Yokai](https://99percentinvisible.org/episode/return-of-the-yokai/).

The data is from the official website of the [Yuru-Chara Grand Prix](https://www.yurugp.jp/jp/) (Japanese), an annual competition where the public votes for their favourite yuru-chara. The English translation of names, areas, organizations, and descriptions was done using Google's [Cloud Translation API](https://cloud.google.com/translate), so if there is any weird phrasing or syntax, it is likely a result of automated translation.



# Data Dictionary

### `yuru-gp.tsv`

| variable             | class     | description                                                  |
| :------------------- | :-------- | :----------------------------------------------------------- |
| year | double | Year of Yuru-chara Grand Prix |
| category | character | Ranking category. In 2017, it was split into two categories: local and company/organization |
| rank | double | Character's rank within their category for that year |
| character_id | double | Unique identifier of character used by yurugp.jp |
| name | character | Name of character |
| area | character | Area character is from (usually a [prefecture](https://en.wikipedia.org/wiki/Prefectures_of_Japan)) |
| organization | character | Company, town, or organization the character represents |
| image_url | character | Link to a character's picture |
