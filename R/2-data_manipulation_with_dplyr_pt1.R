###############################################
######## Tidyverse: Data Wrangling 101 ########
######## Data manipulation: dplyr pt.I ########
########_______________________________########
#rm(list = ls())
# dataset: starwars (included with dplyr)
?starwars
glimpse(starwars)
head(starwars)

# - select() to select columns ----
# select columns by name #1
select(starwars, name, height, mass, homeworld, species)

starwars %>%
  select(name, height, mass, homeworld, species)

# remove columns by name #1
starwars %>%
  select(-hair_color, -skin_color, -eye_color, -birth_year,
         -sex, -gender, -films, -vehicles, -starships)

# select columns by name #2
colnames(starwars)
starwars %>%
  select(name:mass, homeworld, species)

# remove columns by name #2
starwars %>%
  select(-c(hair_color:gender, films:starships))

# using selection helpers (?tidyselect::language)
starwars %>%
  select(where(is.numeric))

starwars %>%
  select(contains("o"))

# use select() to prepare data
starwars <- select(starwars, -c(films, vehicles, starships))

# - filter() to filter rows using TRUE/FALSE statements ----
# characters with a gold skin colour
1 == 1
1 == 2

starwars %>%
  filter(skin_color == "gold")

# return only characters that are:
  # masculine,
  # not with a golden skin colour,
  # and at least 176.5 cm tall
starwars %>%
  filter(gender == "masculine",
         skin_color != "gold",
         height >= 176.5) %>% view()

# characters with eye_color == "blue" OR eye_color == "red"
starwars %>%
  filter(eye_color %in% c("blue", "red"))

# characters NOT with eye_color == "blue" OR eye_color == "red
starwars %>%
  filter(!eye_color %in% c("blue", "red"))

starwars %>%
  filter(str_detect(eye_color, pattern = "blu"))

# see `?base::Logic` for an overview of logic operators
  # NOT: !x
  # AND: x & y
  # OR: x | y

# - arrange() to reorder rows ----
# reordering a character column from A to Z
starwars %>%
  arrange(name)

# reordering a numeric column from smallest to largest values
starwars %>%
  arrange(height)

# reordering a numeric column from largest to smallest values
starwars %>%
  arrange(desc(height))

# arranging using multiple columns
starwars %>%
  arrange(skin_color, species)

# - mutate() to create/modify columns ----
# calculate BMI and arrange from highest to lowest
sw_bmi <- starwars %>%
  mutate(bmi = mass/(height/100)^2) %>%
  select(name:mass, bmi)

sw_bmi %>%
  arrange(desc(bmi))

# calculate the force based on an individuals mass
starwars %>%
  mutate(
    bmi = mass/(height/100)^2,
    the_force = 1/bmi*birth_year) %>%
  select(name, the_force) %>%
  arrange(desc(the_force))

# transform columns 'in place'
starwars %>%
  mutate(
    height = height/100,
    mass = mass*.5,
    skin_color = factor(skin_color)
  )

# advanced mutations
  # verbose code
starwars %>%
  mutate(across(where(is.numeric), function(x) {x*10}))

  # tidy code
starwars %>%
  mutate(across(where(is.numeric), ~.x*10))

# using custom functions
  # create function to multiply by 10
force10 <- function(x){
  x*10
}

  # apply function
starwars %>%
  mutate(across(where(is.numeric), ~force10(.x)))

# - group_by() and summarize() to group and collapse (one row per group) ----
# group_by() alters the STRUCTURE of your data
sw_subset <- starwars %>% select(name, height, mass, gender)

sw_subset_gr <- sw_subset %>% group_by(gender)

  # ungrouped data
glimpse(sw_subset, width = 75)

  # grouped data
glimpse(sw_subset_gr, width = 75)

# summarize() collapses your data to 1 row per group

# average height and weight
starwars %>%
  summarize(average_height = mean(height, na.rm = TRUE),
            stdev_height = sd(height, na.rm = TRUE),
            average_weight = mean(mass, na.rm = TRUE),
            stdev_weight = sd(mass, na.rm = TRUE))

groups(starwars)

# average height and weight PER SPECIES #1
starwars %>%
  group_by(species) %>%
  summarize(average_height = mean(height, na.rm = TRUE),
            stdev_height = sd(height, na.rm = TRUE),
            average_weight = mean(mass, na.rm = TRUE),
            stdev_weight = sd(mass, na.rm = TRUE))

# average height and weight PER SPECIES #2
starwars %>%
  drop_na(species) %>%
  group_by(species) %>%
  filter(n() >= 3) %>%
  summarize(average_height = mean(height, na.rm = TRUE),
            average_weight = mean(mass, na.rm = TRUE),
            individuals = n()) %>%
  arrange(-average_height, -average_weight)

# count() as a quick-and-dirty group_by() %>% summarize()
starwars %>%
  count(species) %>%
  arrange(-n)

starwars %>%
  group_by(species) %>%
  summarize(n = n()) %>%
  arrange(-n)

# - slice() ----
# pre-wrangle dataset into R object
sw_force <- starwars %>%
  mutate(
    bmi = mass/(height/100)^2,
    the_force = 1/bmi*birth_year) %>%
  select(name, the_force) %>%
  arrange(name) %>%
  drop_na(the_force)

# slice() to select/remove specific rows
sw_force %>%
  slice(1)

sw_force %>%
  slice(1, 3, 5)

sw_force %>%
  slice(-2)

# slice_head() to select n FIRST rows
sw_force %>%
  slice_head(n = 5)

# slice_tail() to select n LAST rows
sw_force %>%
  slice_tail(n = 5)

# slice_max() to select rows with highest values
  # top 5 characters with highest the_force values
sw_force %>%
  slice_max(order_by = the_force, n = 5)

# slice_min() to select rows with lowest values
  # top 5 characters with lowest the_force values
sw_force %>%
  slice_min(order_by = the_force, n = 5)

# slice_sample() to select random rows
set.seed(1)
sw_force %>%
  slice_sample(n = 5)

# - distinct() ----
# create starwars clones
set.seed(1)
clone_wars <- starwars %>%
  slice_sample(n = 100, replace = TRUE)

# confirm duplicates using name
clone_wars %>%
  count(name) %>%
  filter(n > 1) %>%
  arrange(desc(n))

# keep only distinct rows
nonclone_wars <- clone_wars %>%
  distinct()

# confirm we only have 1 row per name
nonclone_wars %>%
  count(name) %>%
  arrange(desc(n))

# by default, distinct() applied to all columns, unless specified otherwise
# define columns to override this behaviour
clone_wars %>%
  distinct(name, height, mass)

clone_wars %>%
  distinct(across(contains("color")))

# - Exercises ----
# EXERCISE 1: Use the `starwars` dataset to:
#             1) Select all character columns, along with height
#             2) Find all characters that are:
#                   - taller than 150 cm and a maximum height of 210 cm
#                   - have blond or no hair colour ("none")
#                   - are of the Human species
#                   - not born on planets Bespin, Coruscant or Haruun Kal
starwars %>%
  select(where(is.character), height)

# EXERCISE 2: Use the `starwars` dataset to calculate the average and stdev of
#             weight per sex.
#             HINT 1: average -> mean()
#             HINT 2: standard deviation -> sd()
#             HINT 3: na.rm = TRUE!


# EXERCISE 3: Using the `starwars` dataset, figure out a way to:
#             1) Count the number of individuals that identify with each gender
#                in the dataset.
#             2) Figure out which characters have a missing (NA) gender
#             HINT: This exercise can be broken up in two separate code blocks.

# EXERCISE 4: ADVANCED
#             Using the `storms` dataset (?storms):
#             1) Find the maximum windspeed for each storm
#             2) Make sure you have only 1 row for each storm
#             3) Arrange all storms by wind speed, in descending order
#             4) Filter to keep only storms since the year 2000, and
#                a Safirr-Simpson storm category of at least 4
#             5) Modify the `name` column to contain
#                "Hurrican *name of storm*", e.g. "Hurricane Alberto"
#                 HINT: use paste() (`?paste()`)
#             6) Keep only the columns: name, year, month, day, category and wind
#             You can start with the code provided below

storms %>%
  filter(!str_detect(name, "AL|Al2"))



