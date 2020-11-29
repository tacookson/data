
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
  transmute(taxonomy_code = str_sub(value, 7, 14),
            latin_name = str_sub(value, 15, 43),
            common_name = str_sub(value, 44, 100)) %>%
  slice(2:n()) %>%
  mutate(across(.fns = ~ str_squish(.)))

# Animals
animals_raw %>%
  clean_names() %>%
  transmute(animal_id = dlc_id,
            name = str_to_title(name),
            sex,
            hybrid = case_when(hybrid == "S" ~ "species",
                               hybrid == "B" ~ "sub-species",
                               TRUE ~ "not hybrid"),
            birth_date = dmy(dob),
            birth_type = case_when(birth_type == "CB" ~ "captive",
                                   birth_type == "WB" ~ "wild",
                                   TRUE ~ NA_character_),
            death_date = dmy(dod)) %>% View()