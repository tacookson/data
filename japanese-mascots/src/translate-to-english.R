
### Load packages ---------------------------------------------------------------------------------
library(tidyverse)
library(googleLanguageR)


### Authenticate with Google Cloud ----------------------------------------------------------------
# Use your own Google Cloud credentials if you'd like to run this yourself
# Note: this costs money!
gl_auth("./japanese-mascots/ref/keys/japanese-mascots-translation-service-account.json")


### Function definitions --------------------------------------------------------------------------
# Wrapper around googleLanguageR::gl_translate() to return only the translated text
get_translation <- function(origin_text) {
  translation_object <- gl_translate(origin_text, target = "en", format = "text")
  return(translation_object[["translatedText"]])
}


### Translate to English --------------------------------------------------------------------------
# Rankings
yuru_gp_japanese <- read_tsv("./japanese-mascots/raw/yuru-gp-japanese.txt")

yuru_gp_translated <- yuru_gp_japanese %>%
  mutate(name_english = map_chr(name, get_translation),
         area_english = map_chr(area, get_translation),
         organization_english = map_chr(organization, get_translation))

# Descriptions
# Note: translating descriptions separately to cut down on number of characters needing translation
# (Google Cloud Translate charges by character after 500K in a month)
# I should have also translated names, areas, etc. separately to be most efficient
descriptions_japanese <- read_tsv("./japanese-mascots/raw/descriptions-japanese.txt")

descriptions_translated <- descriptions_japanese %>%
  mutate(description_english = map_chr(description, get_translation))


### Save intermediate translated file -------------------------------------------------------------
# Note: I want to save the unaltered output immediately to avoid having to re-run in case of issues
yuru_gp_translated %>%
  write_tsv("./japanese-mascots/raw/yuru-gp-translated.txt")

descriptions_translated %>%
  write_tsv("./japanese-mascots/raw/descriptions-translated.txt")