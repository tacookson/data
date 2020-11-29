
### Load packages ---------------------------------------------------------------------------------
library(tidyverse)
library(janitor)
library(pdftools)
library(lubridate)


### Import data from raw folder -------------------------------------------------------------------
species_raw <- pdf_text("./duke-lemur-center/raw/1_Species_List_and_Data_Paper/Species list 08Feb2019.pdf")

animals_raw <- read_csv("./duke-lemur-center/raw/3_DLC_Animal_List_Folder/DataRecord_2_DLC_Animal_List_05Feb2019.csv")

weights_raw <- read_csv("./duke-lemur-center/raw/4_DLC_Weight_File_Folder/DataRecord_3_DLC_Weight_File_05Feb2019.csv")


### Clean data
# Species list
species <- species_raw %>%
  str_split(pattern = "\r\n") %>%
  unlist() %>%
  as_tibble() %>%
  transmute(taxonomic_code = str_sub(value, 7, 14),
            latin_name = str_sub(value, 15, 43),
            common_name = str_sub(value, 44, 100)) %>%
  slice(2:n()) %>%
  mutate(across(.fns = ~ str_squish(.)))

# Animals
# NOTE: you'll get a warning for parsing failures with sire_id. This is normal and expected.
animals <- animals_raw %>%
  clean_names() %>%
  left_join(species, by = c("taxon" = "taxonomic_code")) %>%
  left_join(species, by = c("dam_taxon" = "taxonomic_code")) %>%
  left_join(species, by = c("sire_taxon" = "taxonomic_code")) %>%
  transmute(animal_id = dlc_id,
            studbook_id = stud_book,
            name = str_to_title(name),
            taxonomic_code = taxon,
            species = common_name.x,
            sex = ifelse(sex == "ND", NA_character_, sex),
            birth_date = dmy(dob),
            birth_type = case_when(birth_type == "CB" ~ "captive",
                                   birth_type == "WB" ~ "wild",
                                   TRUE ~ NA_character_),
            litter_size,
            death_date = dmy(dod),
            mother_id = ifelse(dam_id == "WILD", "wild", dam_id),
            mother_name = str_to_title(dam_name),
            mother_taxonomic_code = dam_taxon,
            mother_species = common_name.y,
            mother_birth_date = dmy(dam_dob),
            father_id = case_when(sire_id == "WILD" ~ "wild",
                                  str_detect(sire_id, "MULT") ~ paste0("multiple possibilities (", parse_number(sire_id), ")"),
                                  sire_id == "UNK" ~ NA_character_,
                                  TRUE ~ sire_id),
            father_name = str_to_title(sire_name),
            father_taxonomic_code = sire_taxon,
            father_species = common_name,
            father_birth_date = dmy(sire_dob))

# Weights
weights <- weights_raw %>%
  clean_names() %>%
  left_join(species, by = c("taxon" = "taxonomic_code")) %>%
  transmute(animal_id = dlc_id,
            weight_g,
            weight_date = dmy(weight_date),
            is_pregnant = preg_status == "P",
            conception_date = dmy(concep_date_if_preg),
            infant_birth_date = dmy(infant_dob_if_preg),
            infant_litter_size = infant_lit_sz_if_preg)


### Write to TXT ----------------------------------------------------------------------------------
write_tsv(animals, "./duke-lemur-center/animals.txt")

write_tsv(weights, "./duke-lemur-center/weights.txt")
