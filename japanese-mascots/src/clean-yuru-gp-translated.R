
### Load packages ---------------------------------------------------------------------------------
library(tidyverse)


### Import and clean data -------------------------------------------------------------------------
# Rankings
yuru_gp_no_description <- read_tsv("./japanese-mascots/raw/yuru-gp-translated.txt") %>%
  transmute(year,
            category,
            rank,
            character_id,
            name = name_english,
            area = str_remove(area_english, "\\(") %>% str_remove("\\)"),
            affiliation = organization_english,
            image_url)

# Descriptions
descriptions <- read_tsv("./japanese-mascots/raw/descriptions-translated.txt") %>%
  mutate(affiliation = str_extract(description_english, "Affiliation: [^\\n]*"),
         description = str_remove(description_english, affiliation) %>% str_squish(),
         description = ifelse(description == "", NA_character_, description)) %>%
  select(character_id, description)

# Combine rankings and descriptions
# Note: there is duplication in the description field, but made that trade-off to get everything
# into one dataframe
yuru_gp <- yuru_gp_no_description %>%
  left_join(descriptions, by = "character_id") %>%
  select(year:affiliation, description, image_url)

### Write to TXT file -----------------------------------------------------------------------------
write_tsv(yuru_gp, "./japanese-mascots/yuru-gp.txt")