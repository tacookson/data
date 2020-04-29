### APPENDIX -----------------

# Function to clean individual notices
clean_notices <- function(x) {
  notice <- x %>%
    # Convert to tibble
    as_tibble_col(column_name = "text") %>%
    # Find rows with agency headers
    mutate(agency_header = str_detect(text, "A(GENCY|gency):"),
           # Extract name of agency
           agency_name = ifelse(agency_header, str_squish(str_remove(text, "AGENCY: |Agency: ")), NA_character_)) %>%
    # Fill name of agency down until hitting another agency header
    tidyr::fill(agency_name, .direction = "down") %>%
    # Find header titles, which are between lines that are only dashes "-----"
    mutate(header_separator = str_detect(text, "^[-]+$"),
           header_separator_number = cumsum(header_separator)) %>%
    # Filter out headers (leaving only actual entries)
    filter(header_separator_number >= 2,
           !header_separator) %>%
    # Find first line of entry, which will be a capitalized alphabetical character
    mutate(entry_first_line = str_detect(text, "^[A-Z]"),
           # Create entry number based on where first lines occur
           entry_number = cumsum(entry_first_line)) %>%
    # Get rid of helper columns
    select(agency_name, entry_number, text)
  
  # Find end of string of at least three periods "..." (indicates end of first column)
  first_col <- str_locate(notice$text, "[.]{3,}")
  min(first_col[, 2], na.rm = TRUE)
  
  # Find start of string with "His Excellency" (there is always a "His Excellency to give a gift")
  third_col <- str_locate(notice$text, "His Excellency")
  min(third_col[, 1], na.rm = TRUE)
  
  # Find start of string with "Non-acceptance" (indicating start of justification column)
  fourth_col <- str_locate(notice$text, "Non-acceptance")
  min(fourth_col[, 1], na.rm = TRUE)
  
  split_locations <- c(min(first_col[, 2], na.rm = TRUE),
                       min(third_col[, 1], na.rm = TRUE),
                       min(fourth_col[, 1], na.rm = TRUE))
  
  notice %>%
    mutate(recipient = str_sub(text, start = 1L, end = split_locations[[1]]),
           gift_description = str_sub(text, start = split_locations[[1]], end = split_locations[[2]] - 1),
           donor = str_sub(text, start = split_locations[[2]], end = split_locations[[3]] - 1),
           justification = str_sub(text, start = split_locations[[3]])) %>%
    select(-text) %>%
    pivot_longer(cols = recipient:justification, names_to = "category", values_to = "text") %>%
    mutate(text = str_remove_all(text, "\\[\\[(.+?)\\]\\]"),
           text = str_squish(text)) %>%
    filter(text != "") %>%
    mutate(text = str_replace(text, "[..]{2,}", "")) %>%
    group_by(agency_name, entry_number, category) %>%
    summarise(text = str_c(text, collapse = " ")) %>%
    ungroup() %>%
    pivot_wider(id_cols = agency_name:entry_number, names_from = category, values_from = text) %>%
    filter(str_detect(gift_description, "Est. Value") | str_detect(gift_description, "\\$[0-9]+"))
}



# Create vector of agency names to check for in cleaning function
agency_list <- c("Central Intelligence Agency",
                 "Department of Defense",
                 "Department of Energy",
                 "Department of State",
                 "Department of the Air Force",
                 "Department of the Navy",
                 "Department of the Treasury",
                 "FBI",
                 "U.S. House of Representatives",
                 "United States Agency for International Development",
                 "United States Department of Agriculture",
                 "United States Senate",
                 "White House Office and the National Security Council",
                 "Department of Agriculture",
                 "Department of Commerce",
                 "Executive Office of the President",
                 "Executive Office of the President, Office of Science and Technology Policy",
                 "Office of the Vice President",
                 "Department of Air Force",
                 "Department of Homeland Security",
                 "Department of Navy",
                 "Federal Reserve Board",
                 "Health and Human Services",
                 "National Archives and Records Administration",
                 "Department of Health and Human Services",
                 "National Transportation Safety Board",
                 "Office of Personnel Management",
                 "Office of the Director of National Intelligence",
                 "President of the U.S. and the National Security Council",
                 "United States House of Representatives",
                 "Vice President",
                 "Department of Justice",
                 "Department of the Army",
                 "Department of Treasury",
                 "Department of Defense, U.S. Marine Corps",
                 "Department of Education",
                 "Federal Housing Finance Board",
                 "Research and Innovative Technology Administration/Volpe National Transportation Systems Center",
                 "The White House, Office of the Vice President",
                 "U.S. Agency for International Development",
                 "Administrative Offices of the United States Court",
                 "Appalachian Regional Commission",
                 "Defense Intelligence Agency",
                 "Federal Energy Regulatory Commission",
                 "Office of Science and Technology Policy",
                 "The White House--Executive Office of the President",
                 "The White House--Office of the Vice President",
                 "Environmental Protection Agency",
                 "Export Import Bank",
                 "Federal Communications Commission",
                 "Holocaust Memorial Museum",
                 "National Aeronautics and Space Administration",
                 "Office of Director of National Intelligence",
                 "Peace Corps",
                 "U.S. Senate",
                 "United States Marine Corps",
                 "Administrative Office of the United States Courts",
                 "Defense Logistics Agency",
                 "Department of Education",
                 "Department of Veterans' Affairs",
                 "Office of National Drug Control Policy",
                 "Department of Housing and Urban Development",
                 "Department of Transportation",
                 "United States Central Command")

agency_regex <- agency_list %>%
  str_c(., collapse = "|")


### This was included as a line in final cleaning step
###   mutate(gift_description = str_remove(gift_description, "^[^0-9A-Z(]"))