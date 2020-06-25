
### Load packages ---------------------------------------------------------------------------------
library(tidyverse)
library(googleLanguageR)


### Authenticate with Google Cloud ----------------------------------------------------------------
gl_auth("./japanese-mascots/src/keys/japanese-mascots-translation-service-account.json")


### Function definitions --------------------------------------------------------------------------
# Wrapper around googleLanguageR::gl_translate() to return only the translated text
get_translation <- function(origin_text) {
  translation_object <- gl_translate(origin_text, target = "en", format = "text")
  return(translation_object[["translatedText"]])
}

### Test translation ------------------------------------------------------------------------------
yuru_gp_japanese <- read_tsv("./japanese-mascots/yuru-chara-grand-prix-japanese.txt")

# Single vector
single_text <- test_translation %>%
  sample_n(1) %>%
  pull(organization)

result <- gl_translate(single_text, target = "en", format = "text")

# In tibble
multi_text <- test_translation %>%
  sample_n(3)

result <- multi_text %>%
  mutate(name_english = map(name, get_translation))