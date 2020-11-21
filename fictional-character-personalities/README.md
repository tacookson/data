# Fictional Character Personalities

This data contains crowd-sourced personality traits of 800 fictional characters from numerous fictional works. Each character is scored on 264 adjective-pair spectrums, such as "trusting / suspicious" or "luddite / technophile".

To illustrate, let's look at two of my favourite fictional characters: Michael Scott from *The Office* and Worf from *Star Trek*. We'll look at where they are on the "playful / serious" spectrum.

- **Michael Scott** has a mean score of -41.7 (on a -50 to +50 scale), a **low score** indicating he is **very playful**. (After all, he is a friend first, boss second, and entertainer third!)
- **Worf** has a mean score of 43.2 (on a -50 to +50 scale), a **high score** indicating he is **very serious**. (Worf himself states that he "is not a merry man".)



#### Data Source

The data comes from the [Open-Source Psychometrics Project](https://openpsychometrics.org/)'s online ["Which Character" personality quiz](https://openpsychometrics.org/tests/characters/). According to the quiz website:

> This test is provided for educational and entertainment use only. It should not be used as psychological advice of any kind and comes without any guarantee of accuracy or fitness for any particular purpose.

In other words, don't take it too seriously. :tada: ​It's just a bit of fun! :tada:



Thank you [dbaranger](https://github.com/dbaranger) for finding the data and submitting it as a candidate for [#TidyTuesday](https://github.com/rfordatascience/tidytuesday)!



# Data Dictionary

### `personalities.txt`

| variable       | class     | description                                                  |
| :------------- | :-------- | :----------------------------------------------------------- |
| character_code | character | Unique identifier for character                              |
| fictional_work | character | Fictional work the character comes from                      |
| character_name | character | Name of character                                            |
| gender         | character | Gender of character                                          |
| spectrum       | character | Unique identifier for spectrum                               |
| spectrum_low   | character | Low end spectrum (a **low** score in `mean` signifies that a character tends more towards this trait) |
| spectrum_high  | character | High end of spectrum (a **high** score in `mean` signifies that a character tends more towards this trait) |
| is_emoji       | logical   | Indicates if `spectrum_low` or `spectrum_high` uses emojis   |
| mean           | double    | Mean rating                                                  |
| ratings        | double    | Number of ratings                                            |
| sd             | double    | Standard deviation of ratings                                |


