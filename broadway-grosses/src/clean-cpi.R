
# Load packages
library(tidyverse)
library(lubridate)

# Import raw CPI data
# 1988-2020 from https://beta.bls.gov/dataViewer/view/timeseries/CUSR0000SA0L1E
cpi_raw <- read_csv("./broadway-grosses/raw/CUSR0000SA0L1E.csv")

# Create proper field for date (year_month) and rename CPI field
cpi <- cpi_raw %>%
  transmute(year_month = make_date(year = Year, month = parse_number(Period)),
            cpi = Value)

# Write result to broadway-grosses folder
cpi %>%
  write_csv("./broadway-grosses/cpi.csv")