
### Load packages ---------------------------------------------------------------------------------
library(tidyverse)


### Import and clean data -------------------------------------------------------------------------
yuru_gp <- read_tsv("./japanese-mascots/yuru-gp-translated.txt") %>%
  transmute(year,
            category,
            rank,
            character_id,
            name = name_english,
            area = str_remove(area_english, "\\(") %>% str_remove("\\)"),
            organization = organization_english,
            image_url)

### Write to TXT file -----------------------------------------------------------------------------
write_tsv(yuru_gp, "./japanese-mascots/yuru-gp.txt")