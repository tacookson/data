
### Load packages ---------------------------------------------------------------------------------
library(tidyverse)
library(googleLanguageR)


### Authenticate with Google Cloud ----------------------------------------------------------------
gl_auth("./japanese-mascots/src/keys/japanese-mascots-translation-service-account.json")


### Test translation ------------------------------------------------------------------------------
test_translation <- read_tsv("./japanese-mascots/src/test-for-translating.txt")

single_text <- test_translation %>%
  sample_n(1) %>%
  pull(organization)

gl_translate(single_text, target = "en", format = "text")