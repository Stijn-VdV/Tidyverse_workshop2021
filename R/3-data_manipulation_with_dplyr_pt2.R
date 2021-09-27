###############################################
#######  Tidyverse: Data Wrangling 101  #######
#######  Data manipulation: dplyr pt.II #######
########_______________________________########

# - joining data: basic principle ----
# data spread across two tables
df1 <- tibble(
  ID = c("A", "B", "C"),
  value1 = c(1, 2, 3)
)

df2 <- tibble(
  ID = c("A", "B", "D"),
  value2 = c(1, 2, 4)
)

# bring back to 1 table by joining on common variable (= KEY)
full_join(df1, df2)
full_join(df1, df2, by = "ID")

# - Generate data ----
# names of movies, release year and worldwide box office gross (million $)
movies <- tibble::tribble(
  ~movie,                ~yr_released,   ~box_office,
  "The Lion King",           1994L,        968.6,
  "Up",                      2009L,        735.1,
  "Finding Nemo",            2003L,        940.3,
  "Return of the Jedi",      1983L,        475.3,
  "Raiders of the Lost Ark", 1981L,        389.9,
  "The Matrix",              1999L,        465.3,
  "Star Wars",               1977L,        775.5,
  "Avengers: Endgame",       2019L,       2797.8,
  "Iron Man",                2008L,        585.8,
  "The Notebook",            2004L,        117.8,
  "Guardians of the Galaxy", 2014L,        773.4
)

# information on publishing studios of a couple of films
publishers <- tibble::tribble(
  ~movie,                     ~studio,
  "The Lion King",            "Walt Disney Pictures",
  "Up",                       "Walt Disney Pictures",
  "Finding Nemo",             "Walt Disney Pictures",
  "Return of the Jedi",       "Lucasfilm",
  "Raiders of the Lost Ark",  "Lucasfilm",
  "Star Wars",                "Lucasfilm",
  "Avengers: Endgame",        "Mavel Studios",
  "Iron Man",                 "Mavel Studios",
  "Guardians of the Galaxy",  "Mavel Studios"
)
# - joining data I: mutating joins ----
# inner_join: only rows that appear in both datasets
movies %>% inner_join(publishers)

# left_join: add information to all rows of movies
movies %>% left_join(publishers)

# right_join: add information to all rows of publishers
movies %>% right_join(publishers)

# full_join: combine all information of both datasets
movies %>% full_join(publishers)

# NOTE: All *_join() functions search for common variables in both datasets.
#       You can override this behaviour by specifying which keys:
#              ==> by = "key"
#              ==> by = c("key")

# - joining data II: filtering joins ----
# semi_join: retain all rows in movies where we have matching info in publishers
movies %>% semi_join(publishers)

# anti_join: retain all rows in movies where we DO NOT have matching info in publishers
movies %>% anti_join(publishers)

# - joining data III: non-identical keys ----
# create mismatch of common columns (keys)
movies_edit <- movies %>% rename("MOVIE" = movie)

# try joining tables
movies_edit %>% left_join(publishers)

# define matching keys
movies_edit %>% left_join(publishers, by = c("MOVIE" = "movie"))

# - Exercises ----
# data for exercises
rock_members <- tibble::tribble(
  ~artist,            ~band,
  "John Lennon",      "The Beatles",
  "Paul McCartney",   "The Beatles",
  "George Harrison",  "The Beatles",
  "Ringo Starr",      "The Beatles",
  "Chris Martin",     "Coldplay",
  "Jonny Buckland",   "Coldplay",
  "Guy Berryman",     "Coldplay",
  "Will Champion",    "Coldplay",
  "Phil Harvey",      "Coldplay",
  "John Fogerty",     "Creedence Clearwater Revival",
  "Tom Fogerty",      "Creedence Clearwater Revival",
  "Stu Cook",         "Creedence Clearwater Revival",
  "Doug Clifford",    "Creedence Clearwater Revival"
)

rock_instruments <- tibble::tribble(
  ~name,              ~instrument,
  "John Lennon",      "guitar",
  "Paul McCartney",   "bass",
  "George Harrison",  "guitar",
  "Ringo Starr",      "drums",
  "Mick Jagger",      "silly dance moves",
  "Keith Richards",   "guitar",
  "Ronnie Wood",      "bass",
  "Charlie Watts",    "drums",
  "John Fogerty",     "singer",
  "Tom Fogerty",      "guitar",
  "Stu Cook",         "bass",
  "Doug Clifford",    "drums"
  )

# EXERCISE 1: Join tables to retain only rows that appear in both datasets


# EXERCISE 2: Find out which band members and instruments were dropped from EX.1


# EXERCISE 3: Using the result of EX.2, modify the `band` column by adding a band name


