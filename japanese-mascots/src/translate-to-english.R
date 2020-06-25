
### Load packages ---------------------------------------------------------------------------------
library(tidyverse)
library(googleLanguageR)


### Authenticate with Google Cloud ----------------------------------------------------------------
# Use your own Google Cloud credentials if you'd like to run this yourself
# Note: this costs money!
gl_auth("./japanese-mascots/src/keys/japanese-mascots-translation-service-account.json")


### Function definitions --------------------------------------------------------------------------
# Wrapper around googleLanguageR::gl_translate() to return only the translated text
get_translation <- function(origin_text) {
  translation_object <- gl_translate(origin_text, target = "en", format = "text")
  return(translation_object[["translatedText"]])
}


### Translate to English --------------------------------------------------------------------------
yuru_gp_japanese <- read_tsv("./japanese-mascots/yuru-gp-japanese.txt")

yuru_gp_translated <- yuru_gp_japanese %>%
  mutate(name_english = map(name, get_translation),
         area_english = map(area, get_translation),
         organization_english = map(organization, get_translation))


### Save intermediate translated file -------------------------------------------------------------
# Note: I want to save the unaltered output immediately to avoid having to re-run in case of issues
yuru_gp_translated %>%
  unnest(name_english:organization_english) %>%
  write_tsv("./japanese-mascots/yuru-gp-translated.txt")