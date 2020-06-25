
### Load packages ---------------------------------------------------------------------------------
library(tidyverse)
library(googleLanguageR)


### Test translation ------------------------------------------------------------------------------

text_to_translate <- test %>%
  unnest(yuru_chara_data) %>%
  sample_n(1) %>%
  pull(area)

library(googleLanguageR)

gl_auth("./japanese-mascots/src/keys/japanese-mascots-translation-service-account.json")
gl_translate(text_to_translate, target = "en")