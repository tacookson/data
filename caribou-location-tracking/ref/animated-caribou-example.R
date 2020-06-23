### Load packages ---------------------------------------------------------------------------------
library(tidyverse)
library(lubridate) # For working with dates
library(gganimate) # For creating an animated graph


### Load data -------------------------------------------------------------------------------------
locations <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2020/2020-06-23/locations.csv')


### Create small, manageable sample of caribou for this example -----------------------------------
df <- locations %>%
  # Only look at caribou at the Graham site for the year 2002
  filter(study_site == "Graham",
         year(timestamp) == 2002) %>%
  # Only include caribou that had location measurements at the very beginning and end of the year
  # Avoids caribou "popping in" and "dropping out" of the animation
  group_by(animal_id) %>%
  filter(as_date(min(timestamp)) == "2002-01-01",
         as_date(max(timestamp)) == "2002-12-31") %>%
  ungroup() %>%
  # Create a date-formatted field from the timestamp
  # This essentially truncates the time
  mutate(date = as_date(timestamp)) %>%
  group_by(animal_id, date) %>%
  # Calculate the centroid of a caribou's location for each day
  # Measurements are usually taken multiple times a day
  # Taking centroid prevents animation from looking too jittery
  summarise(longitude_centroid = mean(longitude),
            latitude_centroid = mean(latitude)) %>%
  ungroup() %>%
  # When we don't have a location for an individual animal on a given day,
  # take the last known location using the fill() function
  complete(animal_id, date) %>%
  arrange(animal_id, date) %>%
  fill(longitude_centroid, latitude_centroid, .direction = "down")


### Create plot and animation ---------------------------------------------------------------------
p <- df %>%
  # Set animal_id to colour aesthetic so that animation knows they are in different groups
  ggplot(aes(longitude_centroid, latitude_centroid, colour = animal_id)) +
  geom_point(size = 2) +
  # coord_map() and theme_void() useful for geospatial plotting
  coord_map() +
  theme_void() +
  theme(legend.position = "none") +
  # transition_time() animates according to different points in time
  transition_time(time = date) +
  # shadow_mark() leaves caribous' previous locations on the graph
  # Manually setting to make it more transparent (alpha) and smaller (size) ensures that it doesn't
  # distract too much from the "current" point in time
  shadow_mark(alpha = 0.2, size = 0.8) +
  # {frame_time} shows the current date being animated
  ggtitle("Caribou location on {frame_time}")

### Specify animation parameters ------------------------------------------------------------------
# Note: rendering takes ~2 min. (varies depending on your computer)
anim <- animate(p,
                nframes = 1000,
                end_pause = 50)

# Call the anim object to play the animation
anim


### Save animation as a GIF -----------------------------------------------------------------------
# Not necessary, but looks nicer than in the Viewer tab
anim_save("caribou-locations.gif", anim)