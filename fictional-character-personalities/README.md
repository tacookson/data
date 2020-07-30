# Fictional Character Personalities

This data contains crowd-sourced personality traits of 800 fictional characters from numerous fictional works. Each character is scored on each of 264 adjective-pair spectrums, such as "trusting / suspicious" or "luddite / technophile".

For example, let's look at two of my favourite fictional characters: **Michael Scott** from *The Office* and **Worf** from *Star Trek*. Let's look at the "playful / serious" spectrum.

- **Michael Scott** has a mean score of 8.3 (out of 100) on this spectrum (low score = very playful)
- **Worf** has a mean score of 93.2 (out of 100) on this spectrum (high score = very serious)



#### Data Source

The data comes from the [Open-Source Psychometrics Project](https://openpsychometrics.org/)'s online ["Which Character" personality quiz](https://openpsychometrics.org/tests/characters/). According to the project's website, the goal is to:

> [provide] a collection of interactive personality tests with detailed results that can be taken for personal entertainment or to learn more about personality assessment. These tests range from very serious and widely used scientific instruments popular psychology to self produced quizzes. A special focus is given to the strengths, weaknesses and validity of the various systems.



Thank you [dbaranger](https://github.com/dbaranger) for finding the data and submitting it as a candidate for [#TidyTuesday](https://github.com/rfordatascience/tidytuesday)!



# Data Dictionary

### `personalities.txt`

| variable       | class     | description                                                  |
| :------------- | :-------- | :----------------------------------------------------------- |
| character_code | character | Unique identifier for character                              |
| fictional_work | character | Fictional work the character comes from                      |
| character_name | character | Name of character                                            |
| spectrum       | character | Unique identifier for spectrum                               |
| spectrum_low   | character | Low end spectrum (a **low** score in `mean` signifies that a character tends more towards this trait) |
| spectrum_high  | character | High end of spectrum (a **high** score in `mean` signifies that a character tends more towards this trait) |
| mean           | double    | Mean rating                                                  |
| ratings        | double    | Number of ratings                                            |
| sd             | double    | Standard deviation of ratings                                |


