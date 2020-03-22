# Libraries
library(tidyverse)
library(janitor)


# Peaks
peaks <- read_csv("./himalayan-expeditions/raw/peaks.csv") %>%
  transmute(
    peak_id = PEAKID,
    peak_name = PKNAME,
    peak_alternative_name = PKNAME2,
    height_metres = HEIGHTM,
    climbing_status = PSTATUS,
    first_ascent_year = PYEAR,
    first_ascent_country = PCOUNTRY,
    first_ascent_expedition_id = PEXPID
  ) %>%
  mutate(
    climbing_status = case_when(
      climbing_status == 0 ~ "Unknown",
      climbing_status == 1 ~ "Unclimbed",
      climbing_status == 2 ~ "Climbed"
    )
  )

# Create small dataframe of peak names to join to other dataframes
peak_names <- peaks %>%
  select(peak_id, peak_name)

# Expeditions
expeditions <- read_csv("./himalayan-expeditions/raw/exped.csv") %>%
  left_join(peak_names, by = c("PEAKID" = "peak_id")) %>%
  transmute(
    expedition_id = EXPID,
    peak_id = PEAKID,
    peak_name,
    year = YEAR,
    season = SEASON,
    basecamp_date = BCDATE,
    summit_date = SMTDATE,
    termination_date = TERMDATE,
    termination_reason = TERMREASON,
    highpoint_metres = HIGHPOINT,
    members = TOTMEMBERS,
    member_deaths = MDEATHS,
    hired_staff = TOTHIRED,
    hired_staff_deaths = HDEATHS,
    oxygen_used = O2USED,
    trekking_agency = AGENCY
  ) %>%
  mutate(
    termination_reason = case_when(
      termination_reason == 0 ~ "Unknown",
      termination_reason == 1 ~ "Success (main peak)",
      termination_reason == 2 ~ "Success (subpeak)",
      termination_reason == 3 ~ "Success (claimed)",
      termination_reason == 4 ~ "Bad weather (storms, high winds)",
      termination_reason == 5 ~ "Bad conditions (deep snow, avalanching, falling ice, or rock)",
      termination_reason == 6 ~ "Accident (death or serious injury)",
      termination_reason == 7 ~ "Illness, AMS, exhaustion, or frostbite",
      termination_reason == 8 ~ "Lack (or loss) of supplies or equipment",
      termination_reason == 9 ~ "Lack of time",
      termination_reason == 10 ~ "Route technically too difficult, lack of experience, strength, or motivation",
      termination_reason == 11 ~ "Did not reach base camp",
      termination_reason == 12 ~ "Did not attempt climb",
      termination_reason == 13 ~ "Attempt rumoured",
      termination_reason == 14 ~ "Other"
    ),
    season = case_when(
      season == 0 ~ "Unknown",
      season == 1 ~ "Spring",
      season == 2 ~ "Summer",
      season == 3 ~ "Autumn",
      season == 4 ~ "Winter"
    )
  )

members <-
  read_csv("./himalayan-expeditions/raw/members.csv", guess_max = 100000) %>%
  left_join(peak_names, by = c("PEAKID" = "peak_id")) %>%
  transmute(
    expedition_id = EXPID,
    member_id = paste(EXPID, MEMBID, sep = "-"),
    peak_id = PEAKID,
    peak_name,
    year = MYEAR,
    season = MSEASON,
    sex = SEX,
    age = CALCAGE,
    citizenship = CITIZEN,
    expedition_role = STATUS,
    hired = HIRED,
    success = MSUCCESS,
    solo = MSOLO,
    highpoint_reached = MHIGHPT,
    oxygen_used = MO2USED,
    died = DEATH,
    death_cause = DEATHTYPE,
    death_height_metres = DEATHHGTM,
    injured = INJURY,
    injury_type = INJURYTYPE,
    injury_height_metres = INJURYHGTM
  ) %>%
  mutate(
    season = case_when(
      season == 0 ~ "Unknown",
      season == 1 ~ "Spring",
      season == 2 ~ "Summer",
      season == 3 ~ "Autumn",
      season == 4 ~ "Winter"
    ),
    age = ifelse(age == 0, NA, age),
    death_cause = case_when(
      death_cause == 0 ~ "Unspecified",
      death_cause == 1 ~ "AMS",
      death_cause == 2 ~ "Exhaustion",
      death_cause == 3 ~ "Exposure / frostbite",
      death_cause == 4 ~ "Fall",
      death_cause == 5 ~ "Crevasse",
      death_cause == 6 ~ "Icefall collapse",
      death_cause == 7 ~ "Avalanche",
      death_cause == 8 ~ "Falling rock / ice",
      death_cause == 9 ~ "Disappearance (unexplained)",
      death_cause == 10 ~ "Illness (non-AMS)",
      death_cause == 11 ~ "Other",
      death_cause == 12 ~ "Unknown"
    ),
    injury_type = case_when(
      injury_type == 0 ~ "Unspecified",
      injury_type == 1 ~ "AMS",
      injury_type == 2 ~ "Exhaustion",
      injury_type == 3 ~ "Exposure / frostbite",
      injury_type == 4 ~ "Fall",
      injury_type == 5 ~ "Crevasse",
      injury_type == 6 ~ "Icefall collapse",
      injury_type == 7 ~ "Avalanche",
      injury_type == 8 ~ "Falling rock / ice",
      injury_type == 9 ~ "Disappearance (unexplained)",
      injury_type == 10 ~ "Illness (non-AMS)",
      injury_type == 11 ~ "Other",
      injury_type == 12 ~ "Unknown"
    ),
    death_cause = ifelse(died, death_cause, NA_character_),
    death_height_metres = ifelse(died, death_height_metres, NA),
    injury_type = ifelse(injured, injury_type, NA_character_),
    injury_height_metres = ifelse(injured, injury_height_metres, NA)
  )


### Write to CSV
write_csv(expeditions, "./himalayan-expeditions/expeditions.csv")
write_csv(members, "./himalayan-expeditions/members.csv")
write_csv(peaks, "./himalayan-expeditions/peaks.csv")