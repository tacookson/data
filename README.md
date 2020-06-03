# Data Repository

This repository contains data for my personal projects, which is usually a blog post on [my website](https://www.alexcookson.com/), a submission to [#TidyTuesday](https://github.com/rfordatascience/tidytuesday), something to practice web scraping and data cleaning on, or some combination of these.

Feel free to use this data, but none of it belongs to me, so please do so in accordance with the dataset's license. You don't need to cite me if you use something I scraped or cleaned. (But I would love to hear about what you're doing with it!)

And if you have any questions, please [@ me on Twitter](https://twitter.com/alexcookson) (or DM if you prefer). It makes my day whenever I'm able to help someone, even if it's just answering a quick question!



### Repository Structure

Each dataset has its own folder with the following structure. **Bold** text signifies a folder. Normal text represents files:

**data-folder**
- README.md (description, data dictionary, and link to original source)
- clean data files (usually in CSV format)
- **raw**
  - original data files (if the raw folder exists, these files needed to be cleaned)
- **ref**
  - reference documents (e.g., license, data dictionary from the data source)
- **src**
  - scripts (to scrape or clean the original data)



### Dataset Descriptions



| Folder                                                     | Description                                                  |       Status       |
| ---------------------------------------------------------- | ------------------------------------------------------------ | :----------------: |
| [`broadway-grosses`](./broadway-grosses)                   | Weekly box office grosses from Broadway shows from 1985-2020. Includes weekly grosses, seats sold, and average and top ticket prices for over 1,000 shows. | :heavy_check_mark: |
| [`childrens-book-ratings`](./childrens-book-ratings)       | Ratings (1-5) for ~6,000 children's books, as well as title, author, and publishing details. | :heavy_check_mark: |
| [`caribou-location-tracking`](./caribou-location-tracking) | Time-stamped location tracking of 260 individual caribou from herds in northern British Columbia, Canada, from 1988-2016. Great practice for mapping or animation with `gganimate`. | :heavy_check_mark: |
| [`himalayan-expeditions`](./himalayan-expeditions)         | Records for over 10,000 expeditions from 1905-2019 that have climbed the Nepal Himalayas (which includes Mt. Everest), like dates, outcomes (success/failure), highpoints reached, and details on individual climbers, like sex, age, citizenship, and (if applicable) cause of injury or death. | :heavy_check_mark: |
| [`japanese-mascots`](./japanese-mascots)                   | *Work in progress.* Records of Japanese mascots (yuru-chara), including name, description, home area latitude and longitude, and (possibly) yuru-chara events. | :heavy_minus_sign: |
| [`us-government-gifts`](./us-government-gifts)             | Diplomatic gifts foreign governments given to U.S. government employees -- such as when a a foreign leader visits the White House -- from 1999-2018. Includes recipient, donor, gift description, and estimated dollar value. Fun for text mining with a package like `tidytext`. | :heavy_check_mark: |
